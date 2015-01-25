# getting_data
README file for Getting and Cleaning Data Course Project
Author: Juan Mier
The goal of this project is to download a dataset broken down in many different files. The dataset relates to human activity recognition using smartphones.These files must be formatted by R code according to the principles of tidy data.

Requirements:
1. Download dataset: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

2. Save dataset in your R working folder

3. Download dplyr package

Coding Style: 
I followed parts of the Google R Style Guide https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml
Variable names are all lower case separating words with dots (variable.name). Despite dots being discouraged by the instructor, to mean they greatly add to readability and less errors as compared to Camel Case, or others.

Steps in the Script:
Six sections compose the script.
1. Load dplyr library and download files. I use read.table to read text files, this is straightforward; however, for files that have text/character data we set stringsAsFactors = FALSE.

2. I format the activity.labels file, and use a join function as a form of "lookup" table to map the numerical indices in the y.train/test files with the corresponding activity description. This will be needed later as we want the final output to include the description rather than number, that is, "walking" instead of 1. Importantly, in this step we combine all the data components into one dataset (10299 rows and 564 columns -- 561 columns with smartphone data, and 3 to identify subject, activity and activity description).

3. I set column names to unique values (need for dplyr "select"). I convert the full dataset data frame to a tbl_df object, to manipulate with dplyr stuff.

4. I filter the columns to select only those whose name has "mean" or "std," I use a regular expression for this, also select subject and activity.label (dropping the activity number). I also drop the columns that have mean/std but also indicate "angle." As pointed out by colleagues with more physics/math chops here (the result is a 10299x81 tbldf object): https://class.coursera.org/getdata-010/forum/search?q=codebook#15-state-query=angle&15-state-page_num=1

5. I clean the names to make all column names lower case and encase "mean" and "std" with dots ("meanfreq" being the exception). The various gsub operations here accomplish this.

6. The last step uses group_by to group according to subject and activity. Then we summarize by computing means of each subject-activity combination. The result is a tidy data table, of 180 rows and 81 columns. I write the output to a text file.
