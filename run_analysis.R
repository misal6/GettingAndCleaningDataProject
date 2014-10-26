### Step 1 ################################################################################
# Formalities, check if the current directory is in the unzipped dataset directory.
CurDir = getwd()
pFiles <- c("activity_labels.txt","features.txt","train/X_train.txt","train/y_train.txt","test/X_test.txt","test/y_test.txt")
for (pFile in pFiles) {
  x=file.exists(paste(CurDir,pFile,sep = "/", collapse = "/"))
  if (!x) {stop("Please ensure the current directory is UCI HAR Dataset. e.g. C:/myDir/UCI HAR Dataset/. and all the required files exists.", call. = FALSE)}
}
# Formalities, check if all packages are loaded.
pPkgs <- c("reshape2","dplyr","data.table")
for (pPkg in pPkgs) {
  if(!is.element(paste(pPkg), installed.packages()[,1]))
  {stop(paste("Please install ...",pPkg), call. = FALSE)} 
}
suppressMessages(library(reshape2))
suppressMessages(library(dplyr))
suppressMessages(require(data.table))

### Step 2 ################################################################################
# Load all necessary files and naming the activity lables
activity_labels <- as.character(read.table("activity_labels.txt",sep="")$V2)
features <- read.table("features.txt",sep="")$V2

X_train <- read.table("train/X_train.txt",sep="");names(X_train) <- features
y_train <- read.table("train/y_train.txt",sep="");names(y_train) <- "Activity"
y_train$Activity <- as.factor(y_train$Activity);levels(y_train$Activity) <- activity_labels
subject_train <- read.table("train/subject_train.txt",sep="");names(subject_train) <- "SubjectID"
subject_train$SubjectID <- as.factor(subject_train$SubjectID)
train <- cbind(subject_train, y_train,X_train)
train <- mutate(train,DataSet="Train")

X_test <- read.table("test/X_test.txt",sep="");names(X_test) <- features
y_test <- read.table("test/y_test.txt",sep="");names(y_test) <- "Activity"
y_test$Activity <- as.factor(y_test$Activity);levels(y_test$Activity) <- activity_labels
subject_test <- read.table("test/subject_test.txt",sep="");names(subject_test) <-"SubjectID"
subject_test$SubjectID <- as.factor(subject_test$SubjectID)
test <- cbind(subject_test, y_test,X_test)
test <- mutate(test,DataSet="Test")

### Step 3 ################################################################################
# Full Dataset (Requirement 1-4 of the project is complete).
HAR <- rbind(train,test) # Full data

HAR$DataSet <- as.factor(HAR$DataSet)

# Major step, keeping only mean and std variables
keeponly <- c("SubjectID","Activity","DataSet","mean\\(")
HAR_mean <- HAR[,grep(paste(keeponly,collapse="|"),(names(HAR)))] # Data Subset (mean)
HAR_mean <-melt(HAR_mean,id.vars = c("SubjectID", "Activity","DataSet"))

keeponly <- c("SubjectID","Activity","DataSet","std\\(")
HAR_std <- HAR[,grep(paste(keeponly,collapse="|"),(names(HAR)))] # Data Subset (std)
HAR_std <-melt(HAR_std,id.vars = c("SubjectID", "Activity","DataSet"))

### Step 4 ################################################################################
# Major step, splitting the variable names to yield 3 variables
HAR_std <-mutate(HAR_std,x=substring(variable,1,1),y=substring(sub(variable, pattern="-std\\()" , replacement = ""),2),z="STD")
HAR_mean <-mutate(HAR_mean,x=substring(variable,1,1),y=substring(sub(variable, pattern="-mean\\()" , replacement = ""),2),z="Mean")

# Bookeeping, factorizing the new variables
HAR_std$x <- as.factor(HAR_std$x)
HAR_mean$x <- as.factor(HAR_mean$x)
HAR_std$y <- as.factor(HAR_std$y)
HAR_mean$y <- as.factor(HAR_mean$y)
HAR_std$z <- as.factor(HAR_std$z)
HAR_mean$z <- as.factor(HAR_mean$z)

# Major step, selecting and sorting 
HAR_std <- arrange(select(HAR_std,SubjectID,Activity,DataSet,x,y,z,value),SubjectID,Activity,x,y)
HAR_mean <- arrange(select(HAR_mean,SubjectID,Activity,DataSet,x,y,z,value),SubjectID,Activity,x,y)

### Step 5 ################################################################################
# Bookeeping, naming variables
names(HAR_std) <- c("SubjectID","Activity","DataSet","Domain","Feature","Measure","Value")
names(HAR_mean) <- c("SubjectID","Activity","DataSet","Domain","Feature","Measure","Value")

# Freeup some space
rm(train,test,X_train,y_train,X_test,y_test,subject_train,subject_test,features,keeponly,CurDir,pPkg,pPkgs,pFile,pFiles,activity_labels,x)  

# Converting to data.table for faster processing of dcast. merge function takes too long to process.
HAR <- data.table(rbind(HAR_std,HAR_mean), key=c("SubjectID","Activity","DataSet","Domain","Feature","Measure"))
rm(HAR_mean,HAR_std)
# Major step, aggregating the mean
HAR=suppressMessages(dcast(HAR, SubjectID+Activity+DataSet+Domain+Feature ~ Measure, fun.aggregate = mean, na.rm = TRUE))

### Step 6 ################################################################################
# Bookeeping, readable domain names.
levels(HAR$Domain) <- sub("t","Time",levels(HAR$Domain))
levels(HAR$Domain) <- sub("f","Frequency",levels(HAR$Domain))

# Finally ... writing to file.
write.table(HAR,"tidyDataSet.txt",row.names=FALSE)
message("File tidyDataSet.txt is created in current working directory.")
