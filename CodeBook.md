CodeBook for the UCI HAR Tidy Dataset
----------

The purpose of this codebook is to describes the variables, the data, and any transformations or work that was performed to clean up the data

Following are the variables in the output of run_analysis.R (for description and algorithm of the script, please refer to README.md file)

 **1. SubjectID**: Identifier of the subject who carried out the experiment. Its a Factor (30 levels) for 30 subjects, sourced (merged) from subject_train.txt and subject_test.txt. No transformations performed.

**2. Activity**: Activities performed by the subjects. Its a factor (6 levels) for 6 activities, sourced from activity_labels.txt. No transformation on source data is applied.

**3. DataSet**: Identifies if the subject is in the train or test group of data. Its a factor (2 levels) with Train or Test level. The purpose is to include the source datasets in the final dataset even though the subjects are mutually exclusive. Its a new variable introduced with mutate function.

**4. Domain**: Identifies the "Time" or "Frequency" domain of feature variables. Its a factor (2 levels). The purpose is to enable analysis of a variable by time or frequency. Its derived from the first character of the feature variable name. A "t" in the first character identifies the variable as time variable and "f", a frequency. 

**5. Feature**: Identifies the features of the data collected. Its derived from "feature.txt" file which are variables in the Training and Test datasets. Each variable (feature) in the dataset is a concatination of 3 distinct variables. 

- Domain: First character, extracted as "Domain" in final tidy data.
- Feature: The actual feature variables from sensor signals (accelerometer and gyroscope)
- Feature Estimate: The estimates that qualify the feature variable. e.g. std() in the feature qualifies it as standard deviation of the feature. Factors are listed below.

The tidy dataset extracts the actual feature so that its common for Time/Frequency domain as well as for mean/std estimates. This will enable more in-depth analysis from the tidy data.

**6. STD**: Is the standard deviation average by all the dimensions. Type numeric.

**7. Mean**: Is the mean average by all the dimensions. Type numeric.





    List of Features extracted from variable names:	

1. BodyAcc-X
1. BodyAcc-X
1. BodyAcc-Y
1. BodyAcc-Z
1. BodyAccJerk-X
1. BodyAccJerk-Y
1. BodyAccJerk-Z
1. BodyAccJerkMag
1. BodyAccMag
1. BodyBodyAccJerkMag
1. BodyBodyGyroJerkMag
1. BodyBodyGyroMag
1. BodyGyro-X
1. BodyGyro-Y
1. BodyGyro-Z
1. BodyGyroJerk-X
1. BodyGyroJerk-Y
1. BodyGyroJerk-Z
1. BodyGyroJerkMag
1. BodyGyroMag
1. GravityAcc-X
1. GravityAcc-Y
1. GravityAcc-Z
1. GravityAccMag
