#1. Load dplyr and read files
library(dplyr)
features <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
activity.labels <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
x.train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y.train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject.train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x.test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y.test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject.test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
print("step 1 done")

#2. Join activity labels with y.test/train to map names (i.e., WALKING) with numbers
# format activity labels to lower case, and remove underscores
# Combine data: bind by rows and columns all the datasets as needed
activity.labels$V2 <- tolower(activity.labels$V2)
activity.labels$V2 <- gsub("_", " ", activity.labels$V2, fixed = TRUE)
y.train <- left_join(y.train, activity.labels, by = "V1")
y.test <- left_join(y.test, activity.labels, by = "V1")
combine1 <- rbind(x.train, x.test)
combine2 <- rbind(subject.train, subject.test)
combine3 <- rbind(y.train, y.test)
all.data <- cbind(combine1, combine2, combine3)
print("step 2 done")

#3. Set column names by making them unique, as this will be needed later for "select"
# column names come from features.txt, but we will add names for the subject and activity
# convert data frame "all.data" to tbl_df, for dplyr operations
features <- rbind(features, data.frame("V1" = c(562:564), "V2" = c("subject", "activity", "activity.label")))
colnames(all.data) <- make.names(features$V2, unique = TRUE)
all.datatbl <- tbl_df(all.data)
print("step 3 done")

#4. Select columns that contain the string "mean" or "std" as column name, also 
# select subject and activity columns. Remove columns that contain "angle" as suggested
# in the discussion forums. https://class.coursera.org/getdata-010/forum/search?q=codebook#15-state-query=angle&15-state-page_num=1
filter.data <- select(all.datatbl, subject, activity.label, matches("mean|std"))
filter.data <- select(filter.data, -matches("angle"))

#5. Clean names, various text replacement operations, discuss in the README.
clean.names <- names(filter.data)
clean.names <- gsub("...", "*", clean.names, fixed = TRUE)
clean.names <- gsub("..", "*", clean.names, fixed = TRUE)
clean.names <- gsub("*X", ".x", clean.names, fixed = TRUE)
clean.names <- gsub("*Y", ".y", clean.names, fixed = TRUE)
clean.names <- gsub("*Z", ".z", clean.names, fixed = TRUE)
clean.names <- gsub("*", "", clean.names, fixed = TRUE)
clean.names <- tolower(clean.names)
colnames(filter.data) <- clean.names
print("step 4,5 done")

#6. Group, summarize, and write output
by.subject.activity <- group_by(filter.data, subject, activity.label)
tidy.data <- summarise_each(by.subject.activity, funs(mean), matches("mean|std"))
print (dim(tidy.data))
write.table(tidy.data, file = "tidy.data.txt", row.name = FALSE)
