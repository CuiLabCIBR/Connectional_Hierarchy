library(ReX)
library(R.matlab)

rm(list = ls())

working_dir <- 'F:/Cui_Lab/Projects/Connectional_Hierarchy/data/fc/'
out_dir <- 'F:/Cui_Lab/Projects/Connectional_Hierarchy/data/fc_variability/age_effects/'
info_dir <- 'F:/Cui_Lab/Projects/Connectional_Hierarchy/data/sub_info/'

subID <-  as.matrix(unlist(readMat(paste0(working_dir,'subID_hcpd.mat'))))
session <- as.matrix(unlist(readMat(paste0(working_dir,'session_hcpd.mat'))))

age_group <- readMat(paste0(info_dir,'hcpd_sublist_14groups.mat'))
age_group <- age_group$hcpd.age.group

hcpd_age_group <- list()
for (i in 1:14) {
  sub_now <- as.matrix(unlist(age_group[[i]]))
  hcpd_age_group[[i]] <- which(match(subID, sub_now, nomatch=0) > 0)
}

#################################################################################

for (i in 1:14)
{
  idx_now <- hcpd_age_group[[i]]
  data <- readMat(paste0(working_dir,'age_effects/fc_', as.character(i), '.mat'))
  data <- data$fc
  
  rm(df_lme_all)
  df_lme_all <- data.frame(lme_ICC_2wayM(data, subID[idx_now], session[idx_now]))
  
  writeMat(paste0(out_dir,'lme_',as.character(i),'.mat'),lme = df_lme_all)
}
