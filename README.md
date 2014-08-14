![Logo](http://archive.timmmmyboy.com/wp-content/uploads/2012/08/coursera_logo_RGB1.jpg "Coursera Logo")

## Course Project for Coursera "Getting and Cleaning Data" (Course Code: getdata-006)

### Assumptions
1. This R script file (**run_analysis.R**) should be placed in the **UCI HAR Dataset** folder. All paths are relative to this folder.
2. All the data source *file names* and *file locations* are as provided by the instructor.
3. My GitHub location for this course's submissions is here: [https://github.com/amosang21/coursera-getdata-006](https://github.com/amosang21/coursera-getdata-006)

### Outline of Script Logic
#### Overview
This script has been written to follow the instructions as closely as possible. The script has been structured to correspond to each of the 5 steps, as follows:

#### Step 0: Preliminary steps, such as loading the supporting files
Here, the preliminary steps such as the loading of supporting files into data frames, are done. This facilitates easier access in subsequent steps.
	
#### Step 1: Merge the training and the test sets to create one data set
- First, the \*train\*.txt files are read, then the \*test\*.txt files are read.
As the order is important, care is taken to ensure that the *train* data always precedes the *test* data, when they are rbind() together.
The result is that 3 data frames are obtained:
-- **df_subject_merge** for the Subjects
-- **df_y_merge** for the ActivityCode
-- **df_X_merge** for the measurements of the variables.


#### Step 2: Extract only the measurements on the mean and standard deviation for each measurement
- grep() is used to obtain the names of all measurements pertaining to mean or standard deviation. The names are found in df_features, which was read in from features.txt.
- df_X_merge_small contains the dataset with the smaller number of columns.
- df_X_merge_final is then produced using cbind(). This is the final dataset, which includes the SubjectNo, ActivityCode, ActivityName, and the measured variables.

#### Step 3: Use descriptive activity names to name the activities in the data set
- df_X_merge_final is merged with the activity labels. 
- The activity code column is then deleted from the dataset, because it's not needed anymore.

#### Step 4: Appropriately label the data set with descriptive variable names
- The columns of df_X_merge_final are given more appropriate names, which are taken from the features.txt file. 
- Care is taken to ensure that the first 2 column names are not overwritten. These 2 column names are not variable measurements columns.

#### Step 5: Create a second, independent tidy data set with the average of each variable, for each activity, and each subject
- df_X_merge_final_out is produced using aggregate(), to "roll up" the dataset, by SubjectNo+ActivityName.
- The value in each cell is now the mean of each variable, per activity per subject.
