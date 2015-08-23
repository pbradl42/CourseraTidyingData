collectFiles <- function(directory = ".") {
  ## Read all the files in the directory and combine into one dataset
  filelist <- list.files(directory, pattern = "*.txt")
  myColNames <- read.table(paste(directory, "../features.txt", sep = ""))
  
  for (file in filelist) {
    if (length(grep("y", file))) {
        colname <- "ActivityID"
    } else if (length(grep("subject", file))) {
      colname <- "SubjectID"
    #} else {
      #colname <- myColNames[,2]
    }
    myFile <- paste(directory, file, sep = "")
   ## message(myFile)
    if(!exists("myData")) {
      myData <- read.table(myFile)
      if (ncol(myData) == 1) { colnames(myData) <- colname}
    } else {
      temp <- read.table(myFile)
      if (ncol(temp) == 1) { colnames(temp) <- colname
        myData <- cbind(temp, myData)
      } else {
       # colnames(temp) <- colname
        myData <- cbind(myData, temp)
      }
      rm(temp)
    }
  }
  tbl_df(myData)
}
run_analysis <- function() {

  library(dplyr)
  library(tidyr)
  ## First, combine the test and train data
  directory <- "."
  activity_labels <- read.table(paste(directory, "/activity_labels.txt", sep = ""), header = FALSE, sep = " ")
  myColNames <- read.table(paste(directory, "/features.txt", sep = ""), header = FALSE, sep = " ")
  #message(myColNames[,2])
  colnames(activity_labels) <- c("ActivityID", "Activity")
 #  activity_labels

  ### Testtable
  testTable <- collectFiles(paste(directory, "/test/", sep =""))
  tbl_df(testTable) -> testTable
 # message(colnames(testTable))
 # colnames(testTable)[3:563] <- myColNames[,2]
  message("Loaded testtable with ", nrow(testTable), " rows and ", ncol(testTable), " cols.")

  ## Add which set to the dataframe
  testTable$set <- "test"
  
  ### TrainTable
  trainTable <- collectFiles(paste(directory, "/train/", sep =""))
  tbl_df(trainTable) -> trainTable
 #colnames(trainTable)[3:563] <- myColNames[,2]
  message("Loaded traintable with ", nrow(trainTable), " rows and ", ncol(trainTable), " cols.")
  trainTable$set <- "train"  

  ### Combine the tables
  bind_rows(testTable, trainTable) -> har
  #### Assign the colnames from 'features.txt'
  colnames(har)[3:563] <- make.unique(make.names(myColNames$V2))
  #### Cleanup
  rm(testTable)
  rm(trainTable)
 # message(colnames(har))
  message("Loaded har with ", nrow(har), " rows and ", ncol(har), " cols.")
  
  ## Extract only the measurements on the mean and standard deviation for each measurement
##  head(har[,c(1:4, ncol(har))])
  #meanColIndex <- grep("*mean()", colnames(har))
  #sdColIndex <- grep("*std()", colnames(har))
  match <- c("mean\\.", "std\\.")
  ## Should exclude meanFreq
  colIndex <- grep(paste(match, collapse="|"), colnames(har))
  myMeans <- har[colIndex]
 # message(colnames(myMeans)[1])
#  myMeans
#  select(har, contains("mean")) %>% print
  ### WILL NOT work because of duplicate column names in features.txt.

  ## Uses descriptive activity names to name the activities in the data set
 har <- har %>% left_join(activity_labels)
 #activity_labels$ActivityID
 
  ## Appropriately labels the data set with descriptive variable names
  ### Did this before extracting mean and sd
  ## From the data set in step 4, creates a second, independent tidy data set 
  ## with the average of each variable for each activity and each subject 
 #newTable <- har %>% melt(id=c(Activity,SubjectID, set, ActivityID), measure.vars=myMeans) %>%
  newTable <- har %>% gather(variable, values, -c(Activity,SubjectID, set, ActivityID)) %>%
 group_by(variable, Activity, SubjectID) %>%
 #colnames(myMeans) -> test
 summarize(mean(values, na.rm = TRUE))
  colnames(newTable)[4] <- "mean"
  write.table(newTable, file = "tidyUCI.txt", row.name = FALSE)
  #unique(newTable$SubjectID)
  #summarise_each(byActSub, funs(mean, na.rm = TRUE), c(Activity, SubjectID, set, ActivityID))
  #  select()

  

}