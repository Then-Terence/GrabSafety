# Code to evaluate the model

The files in this folder are crucial in testing the model developed for this challenge. In this document, I will elaborate in details what the scripts do.

## Script "Helpers.R"

This script contains a function that calculates Area Under the Curve, and also a function that fills in missing seconds in the telematics data so that the lead and lag speeds can be computed correctly.

## "FinalModel.RData"

This .RData file contains the details of the XGBoost model that has been trained. After the features have been constructed from the telematics data, this can be used to make predictions on it.

## Folder "Output"

I have created an empty folder "Output" to store some intermediate results between running the scripts required to evaluate the model. Inside there, is another empty folder "Pieces" for which the script "Evaluate 02.R" is coded to use for storing some small pieces of intermediate results. This is necessary when the data is big and the memory available is limited.

## Script "Evaluate 01.R"
The script "Evaluate 01.R" reads in data files for telematics and label data, and save as .RData files for faster subsequent loading.

## Script "Evaluate 02.R"

The script "Evaluate 02.R" aggregates the telematics data by bookingID. I have included a part where it runs a loop by only aggregating some but not all booking IDs at once. The results are saved in .RData files as well.

## Script "Evaluate 03.R"

The script "Evaluate 03.R" reads the pieces of data generated by the previous script, combine them together, then make the predictions based on the XGBoost model previously trained.
