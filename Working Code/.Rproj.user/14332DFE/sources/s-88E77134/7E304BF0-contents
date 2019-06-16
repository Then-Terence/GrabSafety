
rm(list = ls(all.names = T)); gc()

library(data.table)
library(bit64)

ReadFeatureFiles <- F

# Pointing at the directory of the files
FileFeature <- list.files("Data/features/", ".csv", full.names = T)
FileLabel <- list.files("Data/labels/", ".csv", full.names = T)

DTLabel <- fread(FileLabel)
# Aggregate based on maximum, ie giving a label 1 if there is at least one label of 1
DTLabel <- DTLabel[, .(label = max(label)), bookingID]

# Generate a small sample to further investigate the dataset
set.seed(123)
SampleID <- sample(DTLabel[, bookingID], 200, F)

# Run a loop to combine all the feature files
if(ReadFeatureFiles == T){
  
  DTFeature <- data.table()
  
  for(i in 1:length(FileFeature)){
    
    DTFeature <- rbind(DTFeature, fread(FileFeature[i]))
    gc()
    
  }
  
  # and save as .RData file
  save(DTFeature, file = "Output/DTFeature.RData")
  
} else {
  
  load("Output/DTFeature.RData")
  
}
# save the labels in a .RData file
save(DTLabel, file = "Output/DTLabel.RData")

# save the small sample in a .RData file
DTFeature <- DTFeature[bookingID %in% SampleID, ]
save(DTFeature, file = "Output/DTSample.RData")
