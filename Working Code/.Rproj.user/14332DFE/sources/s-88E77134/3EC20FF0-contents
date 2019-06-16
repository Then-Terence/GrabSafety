
rm(list = ls()); gc()

library(data.table)
library(bit64)

# Read the 40 pieces of data, each containing 500 booking IDs
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

FileLabel <- list.files("../safety/labels/", ".csv", full.names = T)

DTLabel <- fread(FileLabel)
DTLabel <- DTLabel[, .(label = max(label)), bookingID]

# Data split of 90% training, 10% testing
set.seed(123)
Index <- sample(1:20000, 18000)

TrainDT <- DT[Index, ]
TestDT <- DT[!Index, ]

setkey(TrainDT, bookingID)
setkey(TestDT, bookingID)
setkey(DTLabel, bookingID)

# Merge with the labels of dangerous driving
TrainDT <- DTLabel[TrainDT]
TestDT <- DTLabel[TestDT]

save(TrainDT, TestDT, file = "Output/ModelDT.RData")
