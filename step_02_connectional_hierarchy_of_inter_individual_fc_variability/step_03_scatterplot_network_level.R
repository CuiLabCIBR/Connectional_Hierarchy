library(ggplot2)
library(bruceR)

rm(list=ls())
file_path <- 'F:/Cui_Lab/Projects/Connectional_Hierarchy/step_02_connectional_hierarchy_of_inter_individual_fc_variability/'
FC_Var_net <- import(paste0(file_path,'hcpd_hcp_fc_variability_schaefer400_net.csv'))

r <- cor(FC_Var_net$hcp,FC_Var_net$hcpd,method = "spearman")

p<-ggplot(data = FC_Var_net, aes(x = hcp, y = hcpd))+geom_point(size=2.5,color="#7CAED8",alpha=0.8)+
  geom_smooth(method = lm, se=FALSE, color = "#4682B4", size=2) +
  theme_classic()+labs(y = "HCP-D \n FC variability", x = "FC variability \n HCP-YA") +
  theme(axis.text=element_text(size=20, color='black'), axis.title=element_text(size=20), aspect.ratio = 1.3)+
  theme(legend.position="none") + scale_y_continuous(breaks = seq(0.2, 0.8, by = 0.2), limits = c(0.15, 0.85)) +
  scale_x_continuous(breaks = seq(0.2, 0.8, by = 0.2), limits = c(0.15, 0.85))
p
ggsave(paste0(file_path,'scatter_plot_hcpd_hcp_schaefer400_net.png'),plot=p,width = 12,height = 12,units = "cm",dpi = 600)
