# Grab AI For SEA - Safety

This repository is created for the submission for the Grab AI For SEA Challenge (https://www.aiforsea.com/).

As part of the challenge, I have signed up for the question under the theme of Safety. I have used the R programming language in this challenge.

# The Repository

## Documentation

The documentation of the modelling process is available in the file "Grab_AI_For_SEA_-_Safety.md".

## Folder "Working Code"

This folder contains the scripts used for data preprocessing and model development. There are folders within the folder which corresponds to the scripts, with regards to where to read the data from, and where to store intermediate outputs.

There are a few scripts which handle different parts of the process, from reading the data, to aggregating features, tuning model and training the final model. This is due to the fact that I am working on limited memory on my machine, and it would be more convenient for me to split the tasks into several scripts.

## Folder "Testing Code"

This folder contains the scripts that will be used for evaluating an unseen dataset. Similarly, there are a few scripts that have to be run in order to produce the results.

I have created an empty folder "Output" to store some intermediate results between running the scripts required to evaluate the model. Inside there, is another empty folder "Pieces" for which the script "Evaluate 02.R" is coded to use for storing some small pieces of intermediate results. This is necessary when the data is big and the memory available is limited.

The scripts "Helpers.R" has some user-defined functions that help in some pre-processing steps, and to calculate AUC.

The script "Evaluate 01.R" reads in data files for telematics and label data, and save as .RData files for faster subsequent loading.

The script "Evaluate 02.R" aggregates the telematics data by bookingID. I have included a part where it runs a loop by only aggregating some but not all booking IDs at once. The results are saved in .RData files as well.

The script "Evaluate 03.R" reads the pieces of data generated by the previous script, combine them together, then make the predictions based on the XGBoost model previously trained.

