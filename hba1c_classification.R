library(NNLM)
library(corrplot)
library(ggplot2)
library(VennDiagram)

cluster_col<-function(membership){
  N<-ncol(membership)
  if(N>7){stop('Number of colors is not enough!')}
  col_ref<-matrix(c(0,0,0,
                    0,0,1,
                    0,1,0,
                    1,0,0,
                    1,0,1,
                    1,1,0,
                    0,1,1),ncol=3,byrow=T)
  apply(membership,1,function(x){rgb(sum(col_ref[1:N,1]*x),sum(col_ref[1:N,2]*x),sum(col_ref[1:N,3]*x))})
}

uefc<-function(membership,similarity){
  N<-ncol(similarity)
  wt<-sapply(1:N,function(i){similarity[-i,i]/sum(similarity[-i,i])})
  p<-sapply(1:N,function(i){membership[,-i,drop=F]%*%wt[,i,drop=F]})
  comp<-sum(abs(membership-p))/(ncol(membership)*nrow(membership))
  sep<-min(as.matrix(c(dist(t(membership),method='manhattan'))))
  comp/sep
}

minMD_first<-function(x){
  x_median<-apply(x,2,function(y){median(y,na.rm=T)})
  x_25p<-apply(x,2,function(y)(quantile(y,0.25,na.rm=T)))
  x_75p<-apply(x,2,function(y)(quantile(y,0.75,na.rm=T)))
  index<-numeric()
  index_start<-which((!is.na(x_median))&(!is.na(x_25p))&(x_median<Inf))[1]+1
  if(x_median[index_start+1]>x_25p[index_start]){index<-c(index,index_start)}
  for(i in (index_start+1):(ncol(x)-1)){
    if(x_median[i]<x_25p[i-1]&x_median[i+1]>=x_25p[i]){
      index<-c(index,i)
      }else if((x_75p[i]-x_25p[i])<=((x_75p[i-1]-x_25p[i-1])/2)&length(index)>0){
        if(index[length(index)]==i-1){
          index[length(index)]<-i
        }
    }
  }
  if(x_median[ncol(x)]<x_25p[ncol(x)-1]){index<-c(index,ncol(x))}
  index[1]
}

bootn<-5000

setwd('/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/jc34/Clean_signal/HbA1c/Lookup2')
trait_file<-list.files('/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/jc34/Clean_signal/HbA1c/Lookup1','HbA1c_signals_proxy_lookup_in_')
traits<-sapply(trait_file,function(x){strsplit(x,'_')[[1]][6]})
names(trait_file)<-traits
target_trait<-'HbA1c'
valid_trait<-'HbA1cadjFGlu'
target_trait1<-'InterActHbA1c'
valid_trait1<-c('InterActHbA1cadjIron','InterActHbA1cadjlogFerritin','InterActHbA1cadjTransferrin','InterActHbA1cadjTSAT','InterActHbA1cadj4Iron')
target_trait2<-'EPICHbA1c'
valid_trait2<-c('EPICHbA1cadjIron','EPICHbA1cadjlogFerritin','EPICHbA1cadjTransferrin','EPICHbA1cadjTSAT','EPICHbA1cadj4Iron')
glc_trait<-c('2hGlu','FG','FI')
iron_trait<-c("Iron","Ferritin","Transferrin","TSAT")
mature_rbc_trait<-c("HCT","HGB","MCH","MCHC","MCV","RBC","RDW")
immature_rbc_trait<-c("HLSRc","HLSRp","IRF","RETc","RETp")
rbc_trait<-c(immature_rbc_trait,mature_rbc_trait)
pop<-c('EA')#c('EA','AA','HA','EAA','IAA','UAA','TE','ALL')
stats<-c('EAF_ref','beta_ref','se_ref','p_value_ref','sample_size_ref')
traits<-c(glc_trait,rbc_trait,iron_trait,target_trait,valid_trait,'T2D',target_trait1,valid_trait1,target_trait2,valid_trait2)

signal_proxy<-read.table('HbA1c_signals_proxy',header=T,as.is=T)
signal_all<-paste(signal_proxy$Chr,signal_proxy$Pos,toupper(signal_proxy$Allele1),toupper(signal_proxy$Allele2),sep='_')
proxy_all<-paste(signal_proxy$Chr,signal_proxy$Pos_proxy,toupper(signal_proxy$Allele1_proxy),toupper(signal_proxy$Allele2_proxy),sep='_')

target_signal<-proxy_all

pvmatrix<-szmatrix<-sdmatrix<-ezmatrix<-afmatrix<-matrix(NA,length(target_signal),length(traits),dimnames=list(target_signal,traits))
for(traiti in c(target_trait,valid_trait,glc_trait,rbc_trait,iron_trait)){
  datai<-read.table(trait_file[traiti],header=T,as.is=T,na.strings='NA')
  rownames(datai)<-tt<-datai[,'Chr_Pos_EA_NEA']
  pvmatrix[tt,traiti]<-datai[tt,'p_value_ref']
  szmatrix[tt,traiti]<-datai[tt,'sample_size_ref']
  sdmatrix[tt,traiti]<-datai[tt,'se_ref']
  ezmatrix[tt,traiti]<-as.numeric(datai[tt,'beta_ref'])
  afmatrix[tt,traiti]<-as.numeric(datai[tt,'EAF_ref'])
}
for(traiti in traits[-which(traits%in%c(target_trait,valid_trait,glc_trait,rbc_trait,iron_trait))]){
  datai<-read.table(trait_file[traiti],header=T,as.is=T)
  rownames(datai)<-tt<-datai[,'Chr_Pos_EA_NEA']
  pvmatrix[tt,traiti]<-datai[tt,'p_value_ref']
  szmatrix[tt,traiti]<-datai[tt,'sample_size_ref']
  sdmatrix[tt,traiti]<-datai[tt,'se_ref']
  ezmatrix[tt,traiti]<-as.numeric(datai[tt,'beta_ref'])
  afmatrix[tt,traiti]<-afmatrix[tt,target_trait]
}

Wstats<-impmatrix<-ezmatrix*sqrt(2*afmatrix*(1-afmatrix))

cluster_trait<-c(glc_trait,rbc_trait,iron_trait)

cluster_signal_all<-signal_all[signal_all==proxy_all]
cluster_signal_direct<-cluster_signal_all[rowSums(is.na(Wstats[cluster_signal_all,cluster_trait]))==0]

missing_lookup_signal<-setdiff(cluster_signal_all,cluster_signal_direct)
proxy_in<-proxy_R2<-rep(NA,length(missing_lookup_signal))
for(i in 1:length(missing_lookup_signal)){
  proxies<-intersect(proxy_all[signal_all==missing_lookup_signal[i]],target_signal)
  if(length(proxies)==0){proxy_in[i]<-NA}else{
    proxies_in<-proxies[rowSums(is.na(Wstats[proxies,cluster_trait,drop=F]))==0]
    if(length(proxies_in)==0){proxy_in[i]<-NA}else{
      proxy_in[i]<-proxies_in[which.min(rowSums(is.na(Wstats[proxies_in,,drop=F])))]
      proxy_R2[i]<-as.character(round(signal_proxy$LD_R[signal_all==missing_lookup_signal[i]&proxy_all==proxy_in[i]]^2,2))
    }
  }
}
proxies_matrix<-cbind(Signal=missing_lookup_signal,Proxy=proxy_in,R2=proxy_R2)
write.table(proxies_matrix,'missing_lookup_signal',col.names=T,row.names=F,quote=F)
cluster_signal_proxy<-as.character(proxies_matrix[!is.na(proxies_matrix[,'Proxy']),'Signal'])
names(cluster_signal_proxy)<-as.character(proxies_matrix[!is.na(proxies_matrix[,'Proxy']),'Proxy'])

cluster_signal<-c(cluster_signal_direct,cluster_signal_proxy)
cat(sprintf('#Clustered signals# = %d of %d and %d replaced with proxy (R2>0.8)\n',length(cluster_signal),length(cluster_signal_all),length(cluster_signal_proxy)))
Wstats[cluster_signal_proxy,cluster_trait]<-impmatrix[cluster_signal_proxy,cluster_trait]<-Wstats[names(cluster_signal_proxy),cluster_trait]
ezmatrix[cluster_signal_proxy,cluster_trait]<-ezmatrix[names(cluster_signal_proxy),cluster_trait]
sdmatrix[cluster_signal_proxy,cluster_trait]<-sdmatrix[names(cluster_signal_proxy),cluster_trait]

Wstats<-impmatrix<-Wstats[cluster_signal,]
cluster_signal_o<-cluster_signal

cluster_signaltt<-matrix(unlist(strsplit(cluster_signal,'_')),ncol=4,byrow=T)
cluster_signaltt_lena1<-sapply(cluster_signaltt[,3],function(x){length(strsplit(x,'')[[1]])})
cluster_signaltt_lena2<-sapply(cluster_signaltt[,4],function(x){length(strsplit(x,'')[[1]])})
indel1<-cluster_signaltt_lena1>cluster_signaltt_lena2
indel2<-cluster_signaltt_lena1<cluster_signaltt_lena2
cluster_signaltt[indel1,3]<-'I'
cluster_signaltt[indel1,4]<-'D'
cluster_signaltt[indel2,3]<-'D'
cluster_signaltt[indel2,4]<-'I'
cluster_signal<-paste(cluster_signaltt[,1],cluster_signaltt[,2],cluster_signaltt[,3],cluster_signaltt[,4],sep='_')
cluster_signal1<-paste(cluster_signaltt[,1],cluster_signaltt[,2],cluster_signaltt[,4],cluster_signaltt[,3],sep='_')
names(cluster_signal)<-cluster_signal1

ldpair<-read.table('/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/jc34/Clean_signal/Finemap/LD_matrix/EA_LD/all_signal_ld',header=T,as.is=T)
tt<-ldpair$Mark1%in%cluster_signal1
ldpair$Mark1[tt]<-cluster_signal[ldpair$Mark1[tt]]
tt<-ldpair$Mark2%in%cluster_signal1
ldpair$Mark2[tt]<-cluster_signal[ldpair$Mark2[tt]]
ldpair$R[is.na(ldpair$R)]<-1
ldpair$R<-(ldpair$R)^2
# cluster_EAsignal<-cluster_signal[abs(ezmatrix/sdmatrix)[cluster_signal_o,target_trait]>=-qnorm(5E-6)]
cluster_EAsignal<-cluster_signal
cluster_signal_pvsort<-cluster_EAsignal[sort.list(-abs(ezmatrix/sdmatrix)[cluster_signal_o[cluster_signal%in%cluster_EAsignal],target_trait])]
cluster_signal_LDprune<-cluster_signal_pvsort[1]
for(i in 2:length(cluster_signal_pvsort)){
  tt<-(ldpair$Mark1%in%cluster_signal_LDprune&ldpair$Mark2%in%cluster_signal_pvsort[i])|(ldpair$Mark2%in%cluster_signal_LDprune&ldpair$Mark1%in%cluster_signal_pvsort[i])
  if(any(tt)){
      if(max(ldpair$R[tt])>=0.1){
        cluster_signal_LDprune<-cluster_signal_LDprune
      }else{
        cluster_signal_LDprune<-c(cluster_signal_LDprune,cluster_signal_pvsort[i])
      }
  }else{cluster_signal_LDprune<-c(cluster_signal_LDprune,cluster_signal_pvsort[i])}
}
cluster_signal_LDprune<-cluster_signal_o[cluster_signal%in%cluster_signal_LDprune]
cluster_signal<-cluster_signal_o

cat(sprintf('#Clustered signals# with LD(R2) < 0.1 = %d of %d\n',length(cluster_signal_LDprune),length(cluster_signal)))

trait_all_sim<-cor(Wstats[cluster_signal_LDprune,])^2
trait_sim<-trait_all_sim[cluster_trait,cluster_trait]

pdf('trait_all.pdf')
tt<-rowSums(is.na(trait_all_sim))<ncol(trait_all_sim)-1
plot(hclust(as.dist(1-trait_all_sim[tt,tt]),method='average'),hang=-1,xlab='dist=1-R2')
plot(hclust(as.dist(1-trait_sim),method='average'),hang=-1,xlab='dist=1-R2')
# corrplot(trait_all_sim[tt,tt], method='color',order='hclust',hclust.method='average',addrect=5)
dev.off()

repn<-50
nnmf_trait_cluster_membership<-list()
nnmf_cluster_uefc<-matrix(NA,repn,ncol(trait_sim)/2)

for(i in 2:(ncol(trait_sim)/2)){
  for(j in 1:repn){
    nnmf_cluster_temp<-nnmf(trait_sim,i,check.k=F,verbose=F)
    nnmf_cluster_membership_temp<-nnmf_cluster_temp$H%*%diag(1/colSums(nnmf_cluster_temp$H))
    nnmf_cluster_uefc[j,i]<-uefc(nnmf_cluster_membership_temp,trait_sim)
    if(j==which.min(nnmf_cluster_uefc[,i])){nnmf_trait_cluster_membership[[i]]<-nnmf_cluster_membership_temp}
  }
  colnames(nnmf_trait_cluster_membership[[i]])<-colnames(trait_sim)
}
nnmf_cluster_N<-minMD_first(nnmf_cluster_uefc)

pdf('trait_NMF_check.pdf')

nnmf_uefc_50p<-apply(nnmf_cluster_uefc,2,function(x) {quantile(x,c(0.25,0.5,0.75),na.rm=T)})
nnmf_uefc_start<-which(!is.na(nnmf_uefc_50p['50%',])&(nnmf_uefc_50p['50%',]<Inf))[1]
nnmf_uefc_50p<-nnmf_uefc_50p[,-c(1:(nnmf_uefc_start-1))]
rownames(nnmf_uefc_50p)<-c('q1','median','q3')
rank<-nnmf_uefc_start:(ncol(nnmf_uefc_50p)+nnmf_uefc_start-1)
nnmf_uefc_50p<-as.data.frame(cbind(rank,t(nnmf_uefc_50p)))

ggplot(nnmf_uefc_50p,aes(x=rank,y=median))+
geom_errorbar(aes(ymin=q1,ymax=q3),width=.1,colour=2)+
geom_line()+
geom_point()

corrplot(t(nnmf_trait_cluster_membership[[nnmf_cluster_N]]), is.corr = FALSE, method='number')

dev.off()

# Wstatstt<-scale(Wstats[cluster_signal,cluster_trait])
# PCWstats<-cbind(Wstatstt[cluster_signal,glc_trait]%*%prcomp(Wstats[cluster_signal_LDprune,glc_trait],scale=T)$rotation[,'PC1',drop=F],
#   Wstatstt[cluster_signal,immature_rbc_trait]%*%prcomp(Wstats[cluster_signal_LDprune,immature_rbc_trait],scale=T)$rotation[,'PC1',drop=F],
#   Wstatstt[cluster_signal,mature_rbc_trait]%*%prcomp(Wstats[cluster_signal_LDprune,mature_rbc_trait],scale=T)$rotation[,'PC1',drop=F],
#   Wstatstt[cluster_signal,iron_trait]%*%prcomp(Wstats[cluster_signal_LDprune,iron_trait],scale=T)$rotation[,'PC1',drop=F])
# signal_sim<-cor(t(PCWstats))^2

Wstatstt<-Wstats[cluster_signal,cluster_trait]
for(traiti in cluster_trait){
  modeltt<-lm(paste('`',traiti,'`',' ~ ','`',paste(cluster_trait[!cluster_trait%in%traiti],collapse='`+`'),'`',sep=''),data=as.data.frame(Wstatstt[cluster_signal_LDprune,cluster_trait]))
  Wstatstt[cluster_signal,traiti]<-Wstatstt[cluster_signal,traiti]-predict(modeltt,as.data.frame(Wstatstt[cluster_signal,!cluster_trait%in%traiti]))
}
signal_sim<-cor(t(Wstatstt))^2

repn<-50
nnmf_signal_cluster_membership<-list()
nnmf_cluster_uefc<-matrix(NA,repn,10)

for(i in 2:10){
  for(j in 1:repn){
    nnmf_cluster_temp<-nnmf(signal_sim,i,check.k=F,verbose=F,max.iter=100000)
    nnmf_cluster_membership_temp<-nnmf_cluster_temp$H%*%diag(1/colSums(nnmf_cluster_temp$H))
    nnmf_cluster_uefc[j,i]<-uefc(nnmf_cluster_membership_temp,signal_sim)
    if(j==which.min(nnmf_cluster_uefc[,i])){nnmf_signal_cluster_membership[[i]]<-nnmf_cluster_membership_temp}
  }
  colnames(nnmf_signal_cluster_membership[[i]])<-rownames(signal_sim)
}
nnmf_cluster_N<-minMD_first(nnmf_cluster_uefc)

pdf('signal_NMF_check.pdf')

nnmf_uefc_50p<-apply(nnmf_cluster_uefc,2,function(x) {quantile(x,c(0.25,0.5,0.75),na.rm=T)})
nnmf_uefc_start<-which(!is.na(nnmf_uefc_50p['50%',])&(nnmf_uefc_50p['50%',]<Inf))[1]+1
nnmf_uefc_50p<-nnmf_uefc_50p[,-c(1:(nnmf_uefc_start-1))]
rownames(nnmf_uefc_50p)<-c('q1','median','q3')
rank<-nnmf_uefc_start:(ncol(nnmf_uefc_50p)+nnmf_uefc_start-1)
nnmf_uefc_50p<-as.data.frame(cbind(rank,t(nnmf_uefc_50p)))

ggplot(nnmf_uefc_50p,aes(x=rank,y=median))+
geom_errorbar(aes(ymin=q1,ymax=q3),width=.1,colour=2)+
geom_line()+
geom_point()

corrplot(t(nnmf_signal_cluster_membership[[nnmf_cluster_N]]), is.corr = FALSE, method='color')

dev.off()

pdf('cluster_class.pdf')

# tt<-Wstatstt
# tt<-Wstats[cluster_signal,cluster_trait]
# tt[!cluster_signal%in%cluster_signal_LDprune,]<-0
# wtGRS<-nnmf_signal_cluster_membership[[nnmf_cluster_N]]%*%abs(tt)
# wtGRS_norm<-t(apply(wtGRS,2,function(x){(x-mean(x))/sd(x)}))
# corrplot(wtGRS_norm, is.corr = FALSE, method='color')
# tt<-Wstats[,c(target_trait,valid_trait,target_trait2,valid_trait2)]
# tt[!cluster_signal%in%cluster_signal_LDprune,]<-0
# corrplot(t(nnmf_signal_cluster_membership[[nnmf_cluster_N]]%*%abs(tt)), is.corr = FALSE, method='color')

tt<-Wstats[cluster_signal,cluster_trait]
tt[!cluster_signal%in%cluster_signal_LDprune,]<-0
wtGRS<-nnmf_signal_cluster_membership[[nnmf_cluster_N]]%*%abs(tt)
wtGRS_boots<-array(NA,dim=c(dim(wtGRS),bootn))
for(i in 1:bootn){
  boot_tt<-matrix(0,nnmf_cluster_N,length(cluster_signal))
  for(j in 1:length(cluster_signal)){
    for(k in 1:(nnmf_cluster_N)){
      all_p<-sum(boot_tt[,j])
      if(all_p<1){boot_tt[k,j]<-runif(1,0,1-all_p)}
    }
    boot_tt[nnmf_cluster_N,j]<-1-all_p
    boot_tt[,j]<-sample(boot_tt[,j],nnmf_cluster_N,replace=F)
  }
  wtGRS_boots[,,i]<-boot_tt%*%abs(tt)
}
# wtGRS_bootsmean<-apply(wtGRS_boots,1:2,mean)
wtGRS_bootsmean<-matrix(1/nnmf_cluster_N,nnmf_cluster_N,length(cluster_signal))%*%abs(tt)
wtGRS_bootssd<-apply(wtGRS_boots,1:2,sd)
wtGRS_norm<-pnorm(-t((wtGRS-wtGRS_bootsmean)/wtGRS_bootssd),log=T)/-log(10)
corrplot(wtGRS_norm, is.corr = FALSE, method='number')
tt<-Wstats[,c(target_trait,valid_trait,target_trait2,valid_trait2)]
tt[!cluster_signal%in%cluster_signal_LDprune,]<-0
corrplot(t(nnmf_signal_cluster_membership[[nnmf_cluster_N]]%*%abs(tt)), is.corr = FALSE, method='color')

dev.off()

sigimp<-qnorm(0.95)

# cluster_index<-apply(apply(wtGRS_norm,2,function(x){
#   c(mean(glc_trait%in%(rownames(wtGRS_norm)[x>sigimp])),
#     mean(immature_rbc_trait%in%(rownames(wtGRS_norm)[x>sigimp])),
#     mean(mature_rbc_trait%in%(rownames(wtGRS_norm)[x>sigimp])),
#     mean(iron_trait%in%(rownames(wtGRS_norm)[x>sigimp])))
#   }),2,function(x){
#   # i<-which(x>0)
#   i<-which.max(x)
#   # if(length(i)>0){clusteri<-paste(c('Glycaemic','immature_RBC','mature_RBC','Iron')[i],collapse='/')}else{clusteri<-'Unknown'}
#   if(x[i]>0){clusteri<-paste(c('Glycaemic','immature_RBC','mature_RBC','Iron')[i],collapse='/')}else{clusteri<-'Unknown'}
#   clusteri
#   })

cluster_index<-apply(wtGRS_norm,2,function(x){
  i<-which.max(x)
  if(x[i]>sigimp){
    if(rownames(wtGRS_norm)[i]%in%glc_trait){clusteri<-'G'}
    if(rownames(wtGRS_norm)[i]%in%mature_rbc_trait){clusteri<-'mR'}
    if(rownames(wtGRS_norm)[i]%in%immature_rbc_trait){clusteri<-'R'}
    if(rownames(wtGRS_norm)[i]%in%iron_trait){clusteri<-'I'}
    }else{clusteri<-'U'}
  clusteri
  })

cluster_result<-matrix(NA,length(cluster_signal),length(unique(cluster_index)),dimnames=list(cluster_signal,unique(cluster_index)))
for(i in cluster_index){
  cluster_result[,i]<-colSums(nnmf_signal_cluster_membership[[nnmf_cluster_N]][which(cluster_index==i),,drop=F])
}

Feature<-apply(cluster_result,1,function(x){
  feature<-x>1/nnmf_cluster_N
  paste(colnames(cluster_result)[feature][order(x[feature],decreasing=T)],collapse='/')
  })

Feature_hard<-colnames(cluster_result)[apply(cluster_result,1,which.max)]

cluster_result<-cbind(cluster_result,Feature,Feature_hard,-(pnorm(-abs(ezmatrix/sdmatrix)[cluster_signal,],log=T)+log(2))/log(10)*sign(ezmatrix[cluster_signal,]))
write.table(cluster_result,'NMF_cluster_result.txt',quote=F)

cluster_sum_soft<-cluster_sum_hard<-list()
for(i in unique(cluster_index)){cluster_sum_soft[[i]]<-cluster_sum_hard[[i]]<-c()}
for(i in cluster_signal){
  for(j in unlist(strsplit(cluster_result[i,'Feature'],'/'))){cluster_sum_soft[[j]]<-c(cluster_sum_soft[[j]],i)}
  cluster_sum_hard[[cluster_result[i,'Feature_hard']]]<-c(cluster_sum_hard[[cluster_result[i,'Feature_hard']]],i)
}

venn.diagram(cluster_sum_soft,'cluster_soft_summary.png',imagetype='png',cex=1.6)
venn.diagram(cluster_sum_hard,'cluster_hard_summary.png',imagetype='png',cex=1.6)

test_matrix<-matrix(NA,5,4,dimnames=list(c('G','mR','R','I','U'),c('isG','isI_InterAct','isI_EPIC','isT2D')))
for(i in c('G','mR','R','I','U')){
  test_signal<-cluster_signal_LDprune
  test_signali<-test_signal[test_signal%in%(cluster_sum_hard[[i]])]

  tt<-sign(Wstats[test_signali,target_trait])
  glc_test<-t.test(Wstats[test_signali,target_trait]*tt,Wstats[test_signali,valid_trait]*tt,alternative='greater',paired=T)
  test_matrix[i,'isG']<-glc_test$p.value

  tt<-sign(Wstats[test_signali,target_trait1])
  iron_test1<-t.test(Wstats[test_signali,target_trait1]*tt,Wstats[test_signali,valid_trait1[5]]*tt,alternative='greater',paired=T)
  test_matrix[i,'isI_InterAct']<-iron_test1$p.value

  tt<-sign(Wstats[test_signali,target_trait2])
  iron_test2<-t.test(Wstats[test_signali,target_trait2]*tt,Wstats[test_signali,valid_trait2[5]]*tt,alternative='greater',paired=T)
  test_matrix[i,'isI_EPIC']<-iron_test2$p.value

  logORt2d<-Wstats[,'T2D']*sign(Wstats[,target_trait])
  t2d_test<-t.test(logORt2d[test_signali],logORt2d[setdiff(test_signal,test_signali)],alternative='greater',paired=F)
  test_matrix[i,'isT2D']<-t2d_test$p.value
}

print(test_matrix)

# pdf('HbA1cvsT2D.pdf')

# compare_snp<-cluster_signal[!is.na(ezmatrix[cluster_signal,'T2D'])]

# exposure_beta<-abs(ezmatrix[compare_snp,target_trait])
# exposure_se<-sdmatrix[compare_snp,target_trait]
# outcome_beta<-ezmatrix[compare_snp,'T2D']*sign(ezmatrix[compare_snp,target_trait])
# outcome_se<-sdmatrix[compare_snp,'T2D']

# ci95<-1.96
# class_col<-compare_snp%in%(cluster_sum_hard[['G']])+1
# plot(exposure_beta,exp(outcome_beta),pch=19,col=class_col,xlab='HbA1c effect',ylab='T2D OR',main='HbA1c vs T2D',xlim=range(c(exposure_beta-ci95*exposure_se,exposure_beta+ci95*exposure_se)),ylim=range(c(exp(outcome_beta-ci95*outcome_se),exp(outcome_beta+ci95*outcome_se))))

# segments(exposure_beta-ci95*exposure_se,exp(outcome_beta),exposure_beta+ci95*exposure_se,exp(outcome_beta),col=class_col)
# segments(exposure_beta,exp(outcome_beta-ci95*outcome_se),exposure_beta,exp(outcome_beta+ci95*outcome_se),col=class_col)

# abline(h=1,col='gray')
# legend('topright',legend=c('Glycaemic','Non-glycaemic'),col=2:1,pch=19)
# dev.off()

save.image('all_signal_proxy.Rdata')
