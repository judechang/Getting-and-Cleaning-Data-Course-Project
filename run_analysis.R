#step1:Merges the training and the test sets to create one data set

#read data from local file
trainset<-read.table('./train/X_train.txt')
testset<-read.table('./test/X_test.txt')
trainlabel<-read.table('./train/Y_train.txt')
testlabel<-read.table('./test/Y_test.txt')
subject_train<-read.table('./train/subject_train.txt')
subject_test<-read.table('./test/subject_test.txt')

#combine the data as asked
set<-rbind(trainset,testset)
label<-rbind(trainlabel,testlabel)
subject<-rbind(subject_train,subject_test)

#step2:Extracts only the measurements on the mean and standard deviation for each measurement

#read feature data from file 
feature<-read.table('./features.txt')
#search mean and sd from feature file
mean_sd<- grep("-(mean|std)\\(\\)", feature[, 2])
#use feature as columns of data 'set' and rename it
set <- set[, mean_sd]
names(set) <- feature[mean_sd, 2]


#step3:Uses descriptive activity names to name the activities in the data set
#read data 
activity_labels<-read.table('./activity_labels.txt')
#use acitivity_labels to replace the number of data 'label' then rename it
label[,1]<-activity_labels[label[,1],2]
names(label)<-'activity_names'

#step4:Appropriately label the data set with descriptive variable names
names(subject)<-'subject'
#combine all the data
all<-cbind(set,label,subject)

#step5:From the data set in step 4, creates a second, independent tidy data 
#      set with the average of each variable for each activity and each subject
all_tidy <- ddply(all, .(subject, activity_names), function(x) colMeans(x[, 1:66]))

#step6:report data
write.table(all_tidy, "all_tidy.txt", row.name=FALSE)
