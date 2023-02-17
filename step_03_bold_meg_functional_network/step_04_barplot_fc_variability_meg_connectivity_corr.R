library(bruceR)
library(plotly)
library(ggplot2)

rm(list = ls())
file_path <- 'F:/Cui_Lab/Projects/Connectional_Hierarchy/step_03_bold_meg_functional_network/'
MEG <- import(paste0(file_path,'meg_corr_results.xlsx'))

Freq_Order <- MEG$Frequency[1:6]
p <- ggplot(data=MEG, aes(x=Frequency, y=Rho, fill=Dataset)) +
  geom_bar(stat="identity", color="black", width = 0.7, position=position_dodge())+
  theme_classic()+labs(y = "Spearman's rho", x = "") + geom_hline(yintercept=0)+
  theme(axis.text=element_text(size=17, color='black'), axis.title=element_text(size=18), aspect.ratio = 0.2) +
  scale_x_discrete(limits=Freq_Order) + scale_y_continuous(expand = c(0, 0), breaks = seq(0, 0.4, by = 0.1), limits = c(0, 0.4)) +
  theme(legend.position="none") + scale_fill_brewer(palette="Blues")
p
ggsave(paste0(file_path,'barplot_fc_variability_meg_corr.png'),plot=p,width = 26,height = 8,units = "cm",dpi = 2400)
