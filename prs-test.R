library(gtx)
library(data.table)
library(ggplot2)

traits<-c('FG','FI','HbA1c','2hGlu')
ancestries<-c('EUR','EAS','HISP','AA','SAS','AFR')
R2out<-matrix(NA,length(traits),length(ancestries)+1,dimnames=list(traits,c('trait',ancestries)))
R2out[traits,'trait']<-traits

for(trait in traits){

        train_data_read_adj<-fread(cmd=paste0('cat ',trait,'_EUR_train_pst_eff_a1_b0.5_phiauto_chr*txt'),header=F)
        train_beta_adj<-train_data_read_adj$V6
        train_sd_adj<-train_data_read_adj$V7
        train_snp_adj<-paste(train_data_read_adj$V2,train_data_read_adj$V4,train_data_read_adj$V5,sep='_')
        names(train_beta_adj)<-names(train_sd_adj)<-train_snp_adj
        if(trait=='HbA1c'){ancestries<-c('EUR','EAS','HISP','AA','SAS','AFR')}
        if(trait=='FG'|trait=='FI'){ancestries<-c('EUR','EAS','HISP','AA','SAS')}
        if(trait=='2hGlu'){ancestries<-c('EUR','EAS','HISP','AA')}

        for(ancestry in ancestries){
                if(ancestry=='EUR'){
                        test_data_read<-fread(paste0(trait,'_',ancestry,'_test.sums'),header=T)
                        test_beta<-c(test_data_read$BETA,-1*test_data_read$BETA)
                        test_se<-c(test_data_read$SE,test_data_read$SE)
                        test_snp<-c(paste(test_data_read$SNP,test_data_read$A1,test_data_read$A2,sep='_'),paste(test_data_read$SNP,test_data_read$A2,test_data_read$A1,sep='_'))
                        test_N<-max(test_data_read$N)
                        names(test_beta)<-names(test_se)<-test_snp
                }else{
                test_data_read<-fread(paste0(trait,'_',ancestry,'.sums'),header=T)
                test_beta<-c(test_data_read$BETA,-1*test_data_read$BETA)
                test_se<-c(test_data_read$SE,test_data_read$SE)
                test_N<-max(test_data_read$N)
                test_snp<-c(paste(test_data_read$SNP,test_data_read$A1,test_data_read$A2,sep='_'),paste(test_data_read$SNP,test_data_read$A2,test_data_read$A1,sep='_'))
                names(test_beta)<-names(test_se)<-test_snp
                }
                shared_snp<-intersect(train_snp_adj,test_snp)
                outt<-grs.summary(w=train_beta_adj[shared_snp], b=test_beta[shared_snp], s=test_se[shared_snp], n=test_N)
                R2tt<-outt$R2rs
                R2out[trait,ancestry]<-1-(1-R2tt)*(test_N-1)/(test_N-2)
        }
}

write.table(R2out,'R2.out',col.names=T,row.names=F,quote=F,sep='\t')

R2out<-as.matrix(fread('R2.out'))
traits<-c('FG','FI','HbA1c')
ancestries<-c('EUR','EAS','HISP','AA','SAS','AFR')
plotdata<-data.frame('R2'=as.numeric(R2out[R2out[,'trait']%in%traits,ancestries]),
        'Ancestry'=factor(c(matrix(rep(ancestries,length(traits)),byrow=T,length(traits))),levels=c(ancestries)),
        'Trait'=c(rep(traits,length(ancestries))),stringsAsFactors=T)

p<-ggplot(data=plotdata, aes(x=Ancestry,y=R2,color=Ancestry,fill=Ancestry))+geom_bar(stat="identity")+facet_grid(rows=vars(Trait),scale='free_y')+theme_bw()
ggsave('Figure2A.jpg',plot=p,device="jpeg",path='./',width=8,height=8,units="in",dpi=300)
