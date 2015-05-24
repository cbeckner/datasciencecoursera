#Tidying the "Human Activity Recognition Using Smartphones" Dataset

##Raw Data
The underlying data for this project is provided by www.smartlab.ws. The data represents  experiments that were carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities wearing a smartphone on their waist.

Please reference the [Data Readme](https://github.com/cbeckner/datasciencecoursera/blob/master/Getting%20and%20Cleaning%20Data/DataReadme.md) for a descriptoin of the underlying data in its raw form.

##Tidy Data
###Overview
The data was put into a tidy format by doing the following:
- Data from the training and the test sets was merged to create a single large data set.
- Measurements on the mean and standard deviation were extracted from the large data set.
- Descriptive labels for each variable were applied.
- Descriptive activity names were added to the activities in the data set.
- The data was grouped by student and activity by generating the mean for each variable in each group.

_prior to running the package, please make sure that you have the "dplyr" package installed.  `install.packages("dplyr")`_

###Step 1
The raw data is divided into two folders/sets: Test and training.

Within each folder the data is further divided into 3 sets: the subject that it references, the measurements and the activites.

Each of the 3 sets is loaded into memory and combined by type (test/training).

Additionally in this step, the names of the activites (activity_labels.txt) as well as the names for the variables (features.txt) are loaded into their own sets.

###Step 2
Using grepl the colun indexes for the Mean and Standard Deviation columns are extracted from features.txt and stored into a vector.
That vector is then applied against each of the combined data sets from Step 1 and each are saved to a new data set.

_The mean frequency columns were included along with the Mean and Standard Deviation columns to ensure all averages were available for use when evaluating the final data_

###Step 3
The raw feature/variables names are run through ["make.names"](https://stat.ethz.ch/R-manual/R-devel/library/base/html/make.names.html) to generate values that are safe for use in R data frames.
After that, using regular expresssions, a series of substitutions are made to the new feature/variable names.

- ".mean" to "Mean"
- ".std" to "Std"
- "." to ""
- "tBody" to "timeBody"
- "tGravity" to "timeGravity"
- "fBody" to "freqBody"
- "freqBodyBody" to "freqBody"

###Step 4
The test and training data is combined into a single large dataset called "data"

###Step 5
Apply the generated variable names to the final data set.

_At this point we have a cleaned up raw dataset with only the mean and standard deviation related columns.  We need to go through and tidy things up by adding in more descriptive activity names, and summarizing the variables.  the DPLYR library will be utilized to do this._

###Step 6
The DPLYR library allows functions to be chained.  In one call the data will be:

- Grouped by student and activity
- Summarized using Mean()
- Joined with the activies vector
- Filtered to select only the desired columns
- Saved to a tidydata set

In R, this looks like:
    tidydata <- data %>%
        group_by(subjectId,activityId) %>%
        summarise_each(funs(mean)) %>%
        inner_join(activities, by="activityId") %>%
        select(subjectId, activity, timeBodyAccMeanX:freqBodyGyroJerkMagMeanFreq)

###Step 7
The last thing that needs to be done is to clean up everything that we no longer require.  All temporary sets will be removed from the environment.  The two remaining sets will be:

- "data" : The combined and labeled raw data
- "tidydata" : The tidy data set.

##Tidy Data
Please see the [codebook](https://github.com/cbeckner/datasciencecoursera/blob/master/Getting%20and%20Cleaning%20Data/codebook.md) for a breakdown the final tidy dataset.
