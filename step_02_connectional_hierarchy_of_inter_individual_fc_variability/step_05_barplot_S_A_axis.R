library(R.matlab)
library(ggplot2)
library(dplyr)
library(bruceR)
library(rmatio)

rm(list = ls())
working_dir <- 'F:/Cui_Lab/Projects/Connectional_Hierarchy/step_02_connectional_hierarchy_of_inter_individual_fc_variability/'
data_dir <- 'F:/Cui_Lab/Projects/Connectional_Hierarchy/data/fc_variability/'

S_S <- as.matrix(rio::import(paste0(data_dir,'hcpd_fc_variability_S_S.mat')))
A_A <- as.matrix(rio::import(paste0(data_dir,'hcpd_fc_variability_A_A.mat')))
S_A <- as.matrix(rio::import(paste0(data_dir,'hcpd_fc_variability_S_A.mat')))

data_var <- c(mean(A_A),mean(S_A),mean(S_S))
data_var_std <- c(sd(A_A,na.rm=TRUE),sd(S_A,na.rm=TRUE),sd(S_S,na.rm=TRUE))

myPalette <- c("#d0ccd0", "#d0ccd0", "#d0ccd0");
netOrder <- c("A_A","S_A","S_S");
netWidth <- c(0.7,0.7,0.7);

df <- data.frame(network=netOrder, variability=data_var, error=data_var_std);

p1 <- ggplot(data=df, aes(x=network, y=variability)) +
  geom_bar(stat="identity", width=netWidth, fill=myPalette) + 
  scale_x_discrete(limits=netOrder) +
  #geom_errorbar(aes(ymin=variability-error, ymax=variability+error), width=.2) +
  theme_classic()+labs(y = "",x = "") +
  theme(axis.text=element_text(size=12, color='black'), axis.title=element_text(size=12)) +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
  theme(axis.line=element_line(size=0.6)) +
  scale_y_continuous(expand = c(0, 0))+
  coord_cartesian(ylim=c(0,1))
p1
ggsave(paste0(working_dir,'barplot_S_A_hcpd.png'),plot=p1,width = 3,height = 4,units = "cm",dpi = 600)

############HCP-YA############
S_S <- as.matrix(rio::import(paste0(data_dir,'hcp_fc_variability_S_S.mat')))
A_A <- as.matrix(rio::import(paste0(data_dir,'hcp_fc_variability_A_A.mat')))
S_A <- as.matrix(rio::import(paste0(data_dir,'hcp_fc_variability_S_A.mat')))

data_var <- c(mean(A_A),mean(S_A),mean(S_S))
data_var_std <- c(sd(A_A,na.rm=TRUE),sd(S_A,na.rm=TRUE),sd(S_S,na.rm=TRUE))

myPalette <- c("#d0ccd0", "#d0ccd0", "#d0ccd0");
netOrder <- c("A_A","S_A","S_S");
netWidth <- c(0.7,0.7,0.7);

df <- data.frame(network=netOrder, variability=data_var, error=data_var_std);

p2 <- ggplot(data=df, aes(x=network, y=variability)) +
  geom_bar(stat="identity", width=netWidth, fill=myPalette) + 
  scale_x_discrete(limits=netOrder) +
  # geom_errorbar(aes(ymin=variability-error, ymax=variability+error), width=.2) +
  theme_classic()+labs(y = "",x = "") +
  theme(axis.text=element_text(size=12, color='black'), axis.title=element_text(size=12)) +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
  theme(axis.line=element_line(size=0.6)) +
  scale_y_continuous(expand = c(0, 0))+
  coord_cartesian(ylim=c(0,1))
p2
ggsave(paste0(working_dir,'barplot_S_A_hcp.png'),plot=p2,width = 3,height = 4,units = "cm",dpi = 600)
