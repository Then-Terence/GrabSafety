
rm(list = ls()); gc()

library(xgboost)
library(ggplot2)

load("Output/ModelDT.RData")

YTrain <- as.matrix(TrainDT[, label])
XTrain <-
  as.matrix(TrainDT[, names(TrainDT)[!names(TrainDT) %in% c("bookingID", "label")],
                    with = F])

YTest <- as.matrix(TestDT[, label])
XTest <-
  as.matrix(TestDT[, names(TestDT)[!names(TestDT) %in% c("bookingID", "label")],
                   with = F])

# Tuning for learning parameters

## Candidates for parameters ##
eta = seq(0.05, 0.25, 0.05)  # eta
md = seq(2, 10, 2)           # maximum depth
ss = seq(0.25, 1, 0.25)      # subsample
cs = seq(0.25, 1, 0.25)      # colsample_by_tree

cv.nround <- 200

#### CV for eta ####
set.seed(123)

test_eta <- matrix(NA, cv.nround, length(eta))
colnames(test_eta) = paste0("eta", eta)

for(i in 1:length(eta)){
  
  params <- list(eta = eta[i], objective = "binary:logistic",
                 eval_metric = "auc", eta = 0.2)
  
  CVModel <- xgb.cv(data = XTrain, label = YTrain, params = params,
                    nfold = 5, nrounds = cv.nround,
                    verbose = T)
  
  test_eta[, i] <- CVModel[["evaluation_log"]][, test_auc_mean]
  
}

test_eta <- data.table(iteration = 1:cv.nround, test_eta)
test_eta <- melt(test_eta, id.vars = "iteration")
ggplot(data = test_eta) +
  geom_line(aes(x = iteration, y = value, color = variable))

#### CV for md ####
set.seed(123)

test_md <- matrix(NA, cv.nround, length(md))
colnames(test_md) = paste0("md", md)

for(i in 1:length(md)){
  
  params <- list(max_depth = md[i], objective = "binary:logistic",
                 eval_metric = "auc",
                 eta = 0.2)
  
  CVModel <- xgb.cv(data = XTrain, label = YTrain, params = params,
                    nfold = 5, nrounds = cv.nround,
                    verbose = T)
  
  test_md[, i] <- CVModel[["evaluation_log"]][, test_auc_mean]
  
}

test_md <- data.table(iteration = 1:cv.nround, test_md)
test_md <- melt(test_md, id.vars = "iteration")
ggplot(data = test_md) +
  geom_line(aes(x = iteration, y = value, color = variable))

#### CV for ss ####
set.seed(123)

test_ss <- matrix(NA, cv.nround, length(ss))
colnames(test_ss) = paste0("ss", ss)

for(i in 1:length(ss)){
  
  params <- list(subsample = ss[i], objective = "binary:logistic",
                 eval_metric = "auc", eta = 0.2)
  
  CVModel <- xgb.cv(data = XTrain, label = YTrain, params = params,
                    nfold = 5, nrounds = cv.nround,
                    verbose = T)
  
  test_ss[, i] <- CVModel[["evaluation_log"]][, test_auc_mean]
  
}

test_ss <- data.table(iteration = 1:cv.nround, test_ss)
test_ss <- melt(test_ss, id.vars = "iteration")
ggplot(data = test_ss) +
  geom_line(aes(x = iteration, y = value, color = variable))

#### CV for cs ####
set.seed(123)

test_cs <- matrix(NA, cv.nround, length(cs))
colnames(test_cs) = paste0("cs", cs)

for(i in 1:length(cs)){
  
  params <- list(colsample_by_tree = cs[i], objective = "binary:logistic",
                 eval_metric = "auc", eta = 0.2)
  
  CVModel <- xgb.cv(data = XTrain, label = YTrain, params = params,
                    nfold = 5, nrounds = cv.nround,
                    verbose = T)
  
  test_cs[, i] <- CVModel[["evaluation_log"]][, test_auc_mean]
  
}

test_cs <- data.table(iteration = 1:cv.nround, test_cs)
test_cs <- melt(test_cs, id.vars = "iteration")
ggplot(data = test_cs) +
  geom_line(aes(x = iteration, y = value, color = variable))

save.image(file = "Output/TuneXGB.RData")
