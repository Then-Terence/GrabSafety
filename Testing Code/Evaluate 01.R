
rm(list = ls(all.names = T)); gc()

library(data.table)
library(bit64)

# Pointing at the directory of the files
FileFeature <- list.files("Data/features/", ".csv", full.names = T)
FileLabel <- list.files("Data/labels/", ".csv", full.names = T)

DTLabel <- fread(FileLabel)
# Aggregate based on maximum, giving a label 1 if there is at least one label of 1
DTLabel <- DTLabel[, .(label = max(label)), bookingID]

# Run a loop to combine all the feature files
DTFeature <- data.table()

for(i in 1:length(FileFeature)){
  
  DTFeature <- rbind(DTFeature, fread(FileFeature[i]))
  gc()
  
}

# Save the datasets as .RData files
save(DTFeature, file = "Output/DTFeature.RData")
save(DTLabel, file = "Output/DTLabel.RData")

