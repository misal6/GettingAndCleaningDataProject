README for the UCI HAR Tidy Dataset
----------

The purpose of this readme is to describe the algorithm and approach of obtaining the tidy dataset from UCI HAR dataset.

    Please save and run the run_analysis.R file in same directory 
    of unzipped UCI HAR Dataset zip files so that 
    features.txt is a sibling file. and train is a sibling directory.

    Set the current directory to unzipped directory.
    similar to setwd("C:\DirPath\UCI HAR Dataset")

A simple serial algorithm is followed step by step to read, merge, label, melt and finally dcast the data into a tidy dataset. At the same time, making sure no information about the data is lost.

In my view, the variables represent concatenation of 3 independent variables.

1. The time or frequency domain in which data is captured. Both are mutually exclusive variables. This is represented by the first character of variables.
2. The aggregation of variables is appended of mixed into the variable, which by itself an independent variable. Such as mean() and std() are part of variable name.
3. The actual variable which is a feature of accelerometer and gyroscope. 

There is a common set of variables between time and frequency domains and must be represented independently in order to analyze by domains. So, I have split the variable names and formed two separate variables, Domain and Feature. And since the mean and standard deviation are mutually exclusive measures, they are represented by separate variables STD and Mean.

### Algorithm: ###
 
- **Step1**: Make sure all files are present in the current directory. Please run the run_analysis.R file from the directory where UCI data set is unzipped. This directory must have features.txt file in the *same place* as the script file. Secondly, the script makes sure all required packages are installed.

- **Step1**: Read all the necessary files and label them either from activity_labels file or manually.

- **Step3**: Bind the test and train data sets and keep only the mean and std variables. Please note that we are not including the angle() variables as they are obtained in single signal window samples. After binding the two data sets, melt function is used to reshape variables into single column.

- **Step4**: In this step I am splitting and factorizing the variables as explained above. This will make it easy to analyze the data across two domains.

- **Step5**: Data frame is cast as data.table. It’s much faster than merge function. dcast function is used with mean function to aggregate the data.

- **Step6**: Finally, data.table is written to file "tidyDataSet.txt" file.

#### Notes:  ####
- The final data set retains the source data classification of subjects as Train and Test. With this there will be no need to again join this set to identify the class.
- Angle() data is not included in the data set, even though it has "Mean" in their variable names.
