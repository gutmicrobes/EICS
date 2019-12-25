setwd("D:\\guoman\\cibersort\\�Ľ�\\lasso\\20")
#a <- read.table("CIBERSORT-lasso-Results-9.txt",header=T,sep="\t",row.names=1,check.names=F)
#a <- read.table("D:\\guoman\\cibersort\\data\\CIBERSORT-Results.txt",header=T,sep="\t",row.names=1,check.names=F)
#b <- read.csv("D:\\guoman\\cibersort\\�Ľ�\\lasso\\100\\����.csv",header=T,sep=",",row.names=1,check.names=F)
b <- read.table("D:\\guoman\\cibersort\\cibersort-�Ľ�\\ԭcibersort\\20��\\PBMCs-Fig3a-Flow-Cytometry.txt",header=T,sep="\t",row.names=1,check.names=F)
#a <- read.csv("D:\\guoman\\cibersort\\�Ľ�\\������\\keras\\20\\result_yuan.csv",header=T,sep=",",row.names=1,check.names=T)
#a <- read.csv("D:\\guoman\\cibersort\\�Ľ�\\��ع�\\20\\result_yuan.csv",header=T,sep=",",row.names=1,check.names=T)
a <- read.table("D:\\guoman\\cibersort\\�������\\CIBERSORT-lasso-Results.txt",header=T,sep="\t",row.names=1,check.names=F)
b <- read.table("D:\\guoman\\cibersort\\EPIC_SVR\\data\\PBMCs-Fig3a-Flow.txt",header=T,sep="\t",row.names=1,check.names=F)
b <- read.csv("D:\\guoman\\cibersort\\EPIC_SVR\\��ͼ\\mix100\\����2.csv",header=T,sep=",",row.names=1,check.names=F)
a <- read.table("D:\\guoman\\cibersort\\EPIC_SVR\\��ͼ\\mix100\\EPIC-SVR-65-mix-Results-1.txt",header=T,sep="\t",row.names=1,check.names=F)
b<-read.csv("D:\\guoman\\cibersort\\EPIC_SVR\\20ʵ������\\HIC-10.csv",header=T,sep=",",row.names=1,check.names=F)


a <- data.matrix(a) #�����ݿ�ת��Ϊ���־���
b <- data.matrix(b)

###################ȡ��������#######################
agns <- row.names(a) #����
bgns <- row.names(b)
binta <- bgns %in% bgns
b <- b[binta,]
aintb <- agns %in% row.names(b)
a <- a[aintb,]

######## a ��׼������Ϊ�ٷ�֮...��##################
a_stand <- NULL
num0 <- dim(a)[1] ##a������
tmpr <- rownames(a)  #a����
for(i in 1:num0)
{
  s <- a[i,]
  if(sum(s)==0)
  {a_stand<-rbind(a_stand,s)}
  else
    {
      s <- s / sum(s)
      a_stand <- rbind(a_stand,s)
    }
}
rownames(a_stand) <- tmpr 

b_stand <- NULL
num0 <- dim(b)[1] ##a������
tmpr <- rownames(b)  #a����
for(i in 1:num0)
{
  s <- b[i,]
  if(sum(s)==0)
  {b_stand<-rbind(b_stand,s)}
  else
  {
    s <- s / sum(s)
    b_stand <- rbind(b_stand,s)
  }
}
rownames(b_stand) <- tmpr 
###########��ʼ��##############################
num1 <- dim(a_stand)[2]###########����a������
num2 <- dim(b_stand)[2]###########����b������
result <- NULL
i <- 1
rmse <- rep(0,num1) ###��ʼ�����ظ�����,��һ�������ظ������ݣ��ڶ��������ظ��Ĵ���
corrv <- rep(0,num1)
corrv1 <- rep(0,num1)
###################ѭ����������������ϵ��
while(i <= num1){
  a_standi <- a_stand[,i]
  tmpr <- colnames(a_stand)[i]#######ȡ������colnames(b)b��ȫ��������rownames(b)[i]��i��b������
  #############��b��Ѱ�Һ�a[i,]��ͬid������
  for(j in 1:num2){
    if(tmpr==colnames(b_stand)[j])
    {
      k <- j 
    }
  }
  bk=b_stand[,k]
  rmse[i] <- sqrt((mean((a_standi - bk)^2)))
  corrv[i] <- cor(a_standi,bk,method="spearman")
  corrv1[i] <- cor(a_standi,bk,method="pearson")
  print(paste("id:",tmpr,", RMSE:", rmse[i],", SPEARMAN:", corrv[i],", PEARSON:",corrv1[i], sep=""))
  result <- rbind(result, c(tmpr, rmse[i], corrv[i],corrv1[i]))
  i <- i+1
}
colnames(result) <- c("id", "RMSE", "SPEARMAN","PEARSON")
result_df <- as.data.frame(result)
result_df
write.csv(result_df, paste("./","���ϵ��.csv",sep=""))

###############��ɢ��ͼ
library(ggplot2)
file<-read.csv("���ϵ��.csv")
ggplot(data = file,aes(x=X,y=PEARSON))+geom_point(colour="blue")+ylim(0,1)+ labs(x="Sample",y="Pearson Correlation Coefficient")


cor.test(a_standi,bk,method="spearman")
cor.test(a_standi,bk,method="pearson")
