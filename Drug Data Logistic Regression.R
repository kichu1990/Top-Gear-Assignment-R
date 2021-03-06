#Develop a logistic regression based predictive model to predict the drug free 
#individual

#Reading Excel into R
install.packages("readxl")
install.packages("glmnet")
install.packages("caTools")

library(readxl)
drug=read_excel("C:/Users/abhic6/Documents/Drug_data.xlsx")
View(drug)

nrow(drug)                #575 Rows
str(drug)
summary(drug)

#The Variable Age is having NA,replace the NA with mean or median based on Dist
hist(drug$AGE)
drug$AGE[is.na(drug$AGE)]=median(drug$AGE,na.rm=T)

#Checking for outliers in the continuous variable  using Boxplot
boxplot(drug$BECK)
boxplot(drug$AGE)
boxplot(drug$NDRUGTX)

#Handling Outliers in Data

Q1_NDRUGTX=quantile(drug$NDRUGTX,0.25)
Q2_NDRUGTX=quantile(drug$NDRUGTX,0.50)
Q3_NDRUGTX=quantile(drug$NDRUGTX,0.75)
IQR_NDRUGTX=Q3_NDRUGTX-Q1_NDRUGTX
Q3_NDRUGTX+(1.5*IQR_NDRUGTX)

drug$NDRUGTX=sapply(drug$NDRUGTX,
                  function(x){ ifelse(x>13.5,13.5,x)})

drug$RACE =as.factor(drug$RACE)
drug$Sex =as.factor(drug$Sex)
drug$SITE =as.factor(drug$SITE)
drug$DFREE =as.factor(drug$DFREE)
drug$IVHX =as.factor(drug$IVHX)

#use the sample.split function to select the 70% of observations for the training set 
#(the dependent variable for sample.split is not.fully.paid). 

library(glmnet)
library(caTools)
set.seed(144)
spl= sample.split(drug$DFREE, SplitRatio=0.70)
train_Drug = subset(drug,spl==T)
test_Drug  = subset(drug,spl==F)

cor(train_Drug[,unlist(lapply(train_Drug, is.numeric))])

Model1=glm(DFREE~.,data=train_Drug,family="binomial")
summary(Model1)

#Build a Model using the Significant variable based on the P value
Model2=glm(DFREE~NDRUGTX+IVHX+AGE,data=train_Drug,family="binomial")
summary(Model2)

#stepwise Logistic Regression
Model3=glm(DFREE~.,data=train_Drug, family="binomial")
step(Model3)

#Below Model give the least AIC after the stepwise Logistic Regression
glm(formula = DFREE ~ AGE + IVHX + NDRUGTX, family = "binomial", 
    data = train_Drug)

#Using ROC Curve to Determine the Threshold
library(ROCR) 
library(Metrics)
predict = prediction(res,train_Drug$DFREE)
perf = performance(predict,measure = "tpr",x.measure = "fpr") 
plot(perf,colorize=T)
auc.temp=performance(predict,"auc")
AUC=as.numeric(auc.temp@y.values)

#Checking accuracy on Train Data
res =predict(Model2, train_Drug, type = "response" )
table(res)
result = ifelse(res > 0.4, 1, 0)
table(result)
table(ActualValue = train_Drug$DFREE, PredictedValue = res >0.4)
(276+12)/nrow(train_Drug)                                          #0.7146402

#Checking accuracy on Test Data
test_Drug$pred_test=predict(Model2,newdata=test_Drug,type="response")
table(test_Drug$DFREE,test_Drug$pred_test > 0.4)
(117+7)/nrow(test_Drug)                                            #0.7209302    


#3.Develop a Tree based model to address the same problem
# Install rpart library
library(rpart)
library(rpart.plot)

tree_drug=rpart(DFREE~.,data=train_Drug,method="class")
prp(tree_census)

# Make predictions
PredictCART = predict(tree_drug, newdata = test_Drug, type = "class")
table(test_Drug$DFREE, PredictCART)
(114+5)/nrow(test_Drug)                                          #0.6918605
