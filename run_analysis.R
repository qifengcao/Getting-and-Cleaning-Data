X_train <- read.table("train/X_train.txt")
Y_train <- read.table("train/Y_train.txt")
X_test <- read.table("test/X_test.txt")
Y_test <- read.table("test/Y_test.txt")

X_data <- rbind(X_train,X_test)
Y_data <- rbind(Y_train,Y_test)

features <- read.table("features.txt")
features<-features[,2]
names(X_data) <- features
meansAndStdsVector <- grep("(mean)|(std)", features)
extracted_data <- X_data[meansAndStdsVector]


#add label to data set
activity_labels <- read.table("activity_labels.txt")

for(i in 1:6){
    bool <- Y_data==i
    Y_data[bool] = as.character(activity_labels[i,2])
}

subject_train <- read.table("train/subject_train.txt")
subject_test <- read.table("test/subject_test.txt")

subject_data<-rbind(subject_train,subject_test)

for (i in 1:length(subject_data[[1]])){
    subject_data[[1]][i]<- paste("subject",as.character(subject_data[[1]][i]),sep="")
}

new_columns<-cbind(subject_data,Y_data)
names(new_columns)<-c("subject","activity")
#this is the complete data set
final <- cbind(extracted_data,new_columns)
clean_data <- data.frame()
clean_data_sub_and_y <- data.frame() 
for (i in unique(subject_data)){
        sub_bool <- which(subject_data==i)
        new_row <- colMeans(extracted_data[sub_bool,])
        clean_data <- rbind(clean_data,new_row)
}
clean_data<-cbind(clean_data,clean_data_sub_and_y)
names(clean_data)<-names(final)
write.csv(clean_data,file="clean_data.csv")
