install.packages("ggplot2")
install.packages(c("tidyr", "dplyr", "readr"))
install.packages("ggpubr")
####数据读取####
library(ggplot2)
library(readr)
library(tidyr)
library(dplyr)
library(ggpubr)

name.list <- as.vector(as.matrix(read.table("./数据/i83.id")))
chr.list <- c(1:10)
#修正错误函数
fixgeno.func <- function(w.geno,fix.size=NULL)
{
  wind.geno.rle <- rle(w.geno)
  error.id <- which(wind.geno.rle$lengths < fix.size)
  for (i in error.id)
  {
    left.id <- sum(wind.geno.rle$lengths[1:i]) - wind.geno.rle$lengths[i]
    right.id <- sum(wind.geno.rle$lengths[1:i])
    if (i==1)
    { 
      w.geno[(left.id+1):right.id] <-  w.geno[right.id+1]
    }
    else
    {
      w.geno[(left.id+1):right.id] <- w.geno[left.id]
    }
  }
  return(w.geno)
  
}

for (chr in  chr.list)
{
  
  
  
  for (name in name.list)
  {
    file.name <- paste("./数据/",name,sep = "")
    
    df <- read.table(file.name, head = T)
    
    geno <- df[,c(1,2,6)]
    
    
    #### snp分布####
    a <- geno[,1] == chr
    
    geno1 <- geno[a,]
    
    p1 <- ggplot(geno1,aes(POS, genotype1))+ geom_point()+
      scale_x_continuous(labels = function(x) return(paste0(x/1000))) +
      xlab("position") + ylab("SNP type")+
      ggtitle("code") +
      theme(plot.title = element_text(hjust = 0.5))
    # 出图了 
    
    
    #### 滑窗统计####
    row.count <- length(df[,1])
    
    win_size <- ifelse(row.count<30000,15,ifelse(row.count<60000,25,ifelse(row.count<120000,49,ifelse(row.count<300000,99,ifelse(row.count>=300000,199)))))
    
    #水稻基因组
    # win_size <- ifelse(row.count<5000,15,ifelse(row.count<10000,25,ifelse(row.count<20000,49,ifelse(row.count<50000,99,ifelse(row.count>=50000,199)))))
    
    wind_sum <- geno1 %>% mutate(group = as.numeric(rownames(.)) %/% win_size + 1) %>%
      group_by(group) %>%
      summarise(start = min(POS), end=max(POS), code_sum = sum (genotype1)) %>%
      ungroup()
    
    p2 <- ggplot(wind_sum, aes(x=start, y = code_sum)) + geom_point() +
      xlab("Windows Id") + ylab("SNP code sum") +
      scale_x_continuous(labels = function(x) return(x/1000))+
      ggtitle("code_sum") +
      theme(plot.title = element_text(hjust = 0.5))
    
    
    
    #### sum转换基因型 ####
    up_sum <- win_size*2*0.2
    end_sum <- win_size*2*0.8
    wind_geno <- mutate(wind_sum, code =ifelse(code_sum < up_sum, 0, ifelse(code_sum > end_sum, 2, 1 )))
    p3 <- ggplot(wind_geno, aes(x=start, y = code)) + geom_point() +
      xlab("Windows Id") + ylab("SNP code sum") +
      scale_x_continuous(labels = function(x) return(x / 1000))+
      ggtitle("code_sum_code") +
      theme(plot.title = element_text(hjust = 0.5))
    
    
    #### 修正错误 ####
    
    
    
    wind_geno$fix <- fixgeno.func(wind_geno$code, fix.size = 10)
    p4 <- ggplot(wind_geno, aes(x=start, y = fix)) + geom_point() +
      xlab("Windows Id") + ylab("SNP code sum") +
      scale_x_continuous(labels = function(x) return(x / 1000))+
      ggtitle("fix") +
      theme(plot.title = element_text(hjust = 0.5))
    
    
    #### 合并图片 ####
    pic <- ggarrange(p1,p2,p3,p4, ncol=1,nrow=4,labels=c("code","code_sum","sum_code","fix"))
    
    #### 保存结果 ####
    outfilename <-  paste("./结果i83-41/83-s41-CHR",chr,"/", name, "-",chr,".pdf",sep = "")
    out.dir <- paste("./结果i83-41/83-s41-CHR", chr,sep = "")
    dir.create("结果i83-41")
    dir.create(out.dir)
    ggsave(pic, filename = outfilename)
    
    #### 断点统计 ####
    out.txt <- paste("./结果i83-41/83-s41-CHR", chr,"/83-s41-chr", chr,".txt",sep = "")
    count <- dim(wind_geno)[1]
    b <- c(1:count)
    for (i in c(1:count))
    { 
      if (i<count)
      {
        sta <- i
        
        en <- i+1
        if (wind_geno[,6][en,] != wind_geno[,6][sta,] && en <= count) 
        {
          up <- ifelse(wind_geno$fix[sta] == "0", "p1",ifelse(wind_geno$fix[sta]=="2", "p2", "H"))
          down <- ifelse(wind_geno$fix[en] == "0", "p1",ifelse(wind_geno$fix[en]=="2", "p2", "H"))
          lin <- data.frame(wind_geno[i,3], up, down, name)
          write.table(lin, file = out.txt, append = TRUE, row.names = F, col.names = F)
        }
      } 
    }
    
    
  }
  
  
}

