#Steps to create a tidy dataset for only mean and standard deviation measures form all the variables.
#1. Extracts only the measurements on the mean and standard deviation for each measurement.
#2. Appropriately labels the data set with descriptive variable names.
#3. Merges the training and the test sets to create one data set.
#4. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Step #1
# Load: activity labels
activity_labels <- read.table("~/UCI HAR Dataset/activity_labels.txt")[,2]

# Load: data column names
features <- read.table("~/UCI HAR Dataset/features.txt")[,2]

# Extract only mean and standard deviation features
req_features <- grepl("mean|std", features)

#Step #2
#Loading the test files
X_test <- read.table("~/UCI HAR Dataset/test/X_test.txt", quote="\"")
y_test <- read.table("~/UCI HAR Dataset/test/y_test.txt", quote="\"")
subject_test <- read.table("~/UCI HAR Dataset/test/subject_test.txt", quote="\"")

#Naming X_test using features
names(X_test) <- features

#Extracting only req features of mean and std
X_test<- X_test[,req_features]

# Load activity labels
y_test[,2] <- activity_labels[y_test[,1]]
names(y_test) <- c("ID", "Label")
names(subject_test) <- "subject"

#Cloumn bind the three datasets subject_test, X_test, y_test
test_data <- cbind(subject_test, y_test, X_test)

#Loading the train files
X_train <- read.table("~/UCI HAR Dataset/train/X_train.txt", quote="\"")
y_train <- read.table("~/UCI HAR Dataset/train/y_train.txt", quote="\"")
subject_train <- read.table("~/UCI HAR Dataset/train/subject_train.txt", quote="\"")

#Naming X_train using features
names(X_train) <- features

#Extracting only req features of mean and std
X_train<- X_train[,req_features]

# Load activity labels
y_train[,2] <- activity_labels[y_train[,1]]
names(y_train) <- c("ID", "Label")
names(subject_train) <- "subject"

#Cloumn bind the three datasets subject_train, X_rain, y_rain
train_data <- cbind(subject_train, y_train, X_train)


#Step #3
#Merge test and train data
final_data <- rbind(test_data, train_data)

id_labels <- c("subject", "ID", "Label")
data_labels <- setdiff(colnames(final_data), id_labels)
install.packages("reshape")
library(reshape)
melt_data <- melt(final_data, id = id_labels, measure.vars = data_labels)

#Step #4
# Apply mean function to dataset using dcast function
tidy_data <- dcast(melt_data, subject + Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt", row.name=FALSE)
