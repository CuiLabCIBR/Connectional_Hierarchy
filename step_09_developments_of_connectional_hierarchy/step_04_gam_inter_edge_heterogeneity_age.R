library('R.matlab');
library('mgcv');
library('ggplot2');
library('visreg');
library('utils')
library('ppcor')

rm(list = ls())
working_dir <- 'F:/Cui_Lab/Projects/Connectional_Hierarchy/step_09_developments_of_connectional_hierarchy/'

HCPD_Heterogeneity <- read.csv(paste0(working_dir,'gam_age_heterogeneity.csv'));

Gam_Analysis_Age_Heterogeneity <- gam(Heterogeneity ~ s(Age, k=4) + Gender + HeadMotion, method = "REML", data = HCPD_Heterogeneity);
summary(Gam_Analysis_Age_Heterogeneity)
Gam_P_Age_Heterogeneity <- summary(Gam_Analysis_Age_Heterogeneity)$s.table[4]
Gam_Z_Age_Heterogeneity <- qnorm(Gam_P_Age_Heterogeneity / 2, lower.tail = FALSE)

lm_Analysis_Heterogeneity <- lm(Heterogeneity ~ Age + Gender + HeadMotion, data = HCPD_Heterogeneity);
Age_T <- summary(lm_Analysis_Heterogeneity)$coefficients[2, 3];
if (Age_T < 0) {
  Gam_Z_Age_Heterogeneity <- -Gam_Z_Age_Heterogeneity;
}

v <- visreg(Gam_Analysis_Age_Heterogeneity, "Age", plot=FALSE)
heterogeneity_fitted <- as.matrix(v$res$visregRes)
write.csv(heterogeneity_fitted,file=paste0(working_dir,'inter_edge_heterogeneity_fitted.csv'))

Fig <- plot(v, xlab = "Age (years)", ylab = "Inter-edge heterogeneity",
     line.par = list(col = '#7499C2'), fill = list(fill = '#D9E2EC'), gg=TRUE,  rug=FALSE) + 
  theme_classic() +
  geom_point(data=v$res, aes(x=Age, y=visregRes, color=visregRes), size=3, alpha = 1, shape=19)+
  # scale_color_gradient(low="#2473B5", high="#CF1A1D")+
  scale_color_gradient2(low = "#2473B5", high = "#CF1A1D", mid = "#F6FBFF",
                       midpoint = 0.185, limit = c(0.16,0.21), space = "Lab",
                       name="")+
  theme(axis.text=element_text(size=16, color='black'), axis.title=element_text(size=16), aspect.ratio = 1) +
  scale_y_continuous(expand = c(0, 0), breaks = seq(0.16, 0.22, by = 0.02), limits = c(0.15, 0.23)) +
  scale_x_continuous(limits = c(8, 23), breaks = seq(8, 22, by = 2)) + theme(legend.position="none")
Fig
ggsave(paste0(working_dir,'gam_age_heterogeneity.png'),plot=Fig,width = 10,height = 10,units = "cm",dpi = 1200)

####################################################
# Calculate the partial correlation to represent effect size
Age_Heterogeneity_cor <- pcor(HCPD_Heterogeneity, method = "spearman")
r <- Age_Heterogeneity_cor$estimate[1,4]
