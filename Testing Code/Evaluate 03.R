
rm(list = ls()); gc()

library(data.table)
library(bit64)

# Read the small pieces of data, and combine together
AllFiles <- list.files("Output/Pieces", full.names = T)

for(i in 1:length(AllFiles)){
  
  load(AllFiles[i])
  
  if(i == 1){
    
    DT <- copy(DT1)
    
  } else {
    
    DT <- rbind(DT, DT1)
    
  }
  
  rm(DT1)
  
}

# Correct for NaN and Inf

for(i in 1:ncol(DT)){
  
  OriginalName <- names(DT)[i]
  setnames(DT, OriginalName, "PlaceHolder")
  DT[is.nan(PlaceHolder) | is.infinite(PlaceHolder), PlaceHolder := NA]
  setnames(DT, "PlaceHolder", OriginalName)
  
}

# Merge with the labels of dangerous driving
setkey(DT, bookingID)
setkey(DTLabel, bookingID)
DT <- DTLabel[DT]

load("FinalModel.RData")

XMatrix <- as.matrix(DT)
XMatrix <- XMatrix[, importance_matrix[1:80, Feature]]

DT[, Prediction := predict(FinalModel, XMatrix)]
AUROC(DT[, label], DT[, Prediction])
