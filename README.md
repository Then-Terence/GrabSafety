# Grab AI For SEA - Safety

This repository is created for the submission for the Grab AI For SEA Challenge (https://www.aiforsea.com/).

As part of the challenge, I have signed up for the question under the theme of Safety. I have used the R programming language in this challenge.

[tbc]

# The Data

The data provided is made up of:
1. Telematics Data
2. Label of Dangerous Driving

The telematics data has a total number of [...] rows and [...] columns.

The label of dangerous driving records in binary form of whether a trip is considered dangerous, 1 if yes and 0 otherwise.

Note that there are some of the bookings with multiple labels. [How to deal with it?]

## Some Visualizations

# Feature Engineering

Based on the fields in the telematics data, feature engineering has to be conducted in order to obtain aggregate features that are meaningful in determining the riskiness in a particular booking.

# Model Training

Based on the features, I have trained a model using the XGB algorithm.

## Parameter Tuning

In order to get the optimal results, some parameters for the algorithm have to be tuned. This is done by using cross-validation.

As a Grid Search will be very time and memory consuming, I have opted to tune the parameters one at a time, while keeping the other parameters at their default values.

### Learning Parameters

The parameters which I have tuned are:

eta: [What is eta?]

maximum_depth

subsample

colsaple_by_tree

As we can see from the plots above, even when using the same algorithm, the parameters can have a significant effect on the model training.

### Number of Features


### Number of Rounds

Another obvious thing is that after a certain number of iterations, the performance may actually deteriorate. Therefore, the number of iterations in model training has to be tuned as well. [after having the parameters tuned] The results are shown in the plot below.

[plot for iteration]


# Results

[AUC Plot, Figure]
[How to use the model?]

