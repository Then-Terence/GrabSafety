
rm(list = ls()); gc()

library(xgboost)
library(LiteXploreR)

source("Scripts/Helpers.R")

load("Output/ModelDT.RData")

YTrain <- as.matrix(TrainDT[, label])
XTrain <-
  as.matrix(TrainDT[, names(TrainDT)[!names(TrainDT) %in% c("bookingID", "label")],
                    with = F])

YTest <- as.matrix(TestDT[, label])
XTest <-
  as.matrix(TestDT[, names(TestDT)[!names(TestDT) %in% c("bookingID", "label")],
                   with = F])

# Build a preliminary model
params <- list(objective = "binary:logistic",
               eval_metric = "auc",
               eta = 0.05,
               md = 2,
               ss = 0.75,
               cs = 0.75)

set.seed(12345)
xgb <- xgboost(XTrain, label = YTrain,
               nrounds = 100, params = params)

# Compute feature importance
importance_matrix <- xgb.importance(names(XTrain), model = xgb)


# Tune for the number of features to be used
## CV for Number of Features

nfeature <- seq(40, 100, 20)
cv.nround <- 150

set.seed(123)

test_nfeature <- matrix(NA, cv.nround, length(nfeature))
colnames(test_nfeature) = paste0("nfeature", nfeature)

for(i in 1:length(nfeature)){
  
  TempTrain <- XTrain[, importance_matrix[1:nfeature[i], Feature]]
  
  CVModel <- xgb.cv(data = TempTrain, label = YTrain, params = params,
                    nfold = 5, nrounds = cv.nround,
                    verbose = T)
  test_nfeature[, i] <- CVModel[["evaluation_log"]][, test_auc_mean]
  
}

test_nfeature <- data.table(iteration = 1:cv.nround, test_nfeature)
test_nfeature <- melt(test_nfeature, id.vars = "iteration")
ggplot(data = test_nfeature) +
  geom_line(aes(x = iteration, y = value, color = variable))

# Tune for the number of rounds of training
## CV for nrounds

XTrain <- XTrain[, importance_matrix[1:80, Feature]]
XTest <- XTest[, importance_matrix[1:80, Feature]]

set.seed(12345)
CVRounds <- xgb.cv(data = XTrain, label = YTrain, params = params,
                    nfold = 5, nrounds = cv.nround,
                    verbose = T)

ggplot(data = CVRounds[["evaluation_log"]]) +
  geom_line(aes(x = iter, y = test_auc_mean))

which.max(CVRounds[["evaluation_log"]][, test_auc_mean])
max(CVRounds[["evaluation_log"]][, test_auc_mean])

set.seed(12345)
FinalModel <- xgboost(XTrain, label = YTrain,
                      nrounds = 85, params = params)

TrainDT[, Results := predict(FinalModel, XTrain)]
AUROC(TrainDT[, label], TrainDT[, Results]) # 0.8566438

TestDT[, Results := predict(FinalModel, XTest)]
AUROC(TestDT[, label], TestDT[, Results]) # 0.7181272
PlotROC(TestDT[, label], TestDT[, Results], col = "blue", lwd = 2,
        main = "Area Under the Curve of 0.7181")
abline(0, 1)

save.image(file = "Output/FinalModel.RData")
