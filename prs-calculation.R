library(data.table)

ref_snp<-fread('snpinfo_1kg_hm3.bim')
marker<-paste(ref_snp$V1,ref_snp$V4,'SNP',sep=':')
ref_snp<-ref_snp$V2
names(ref_snp)<-marker

sum_data_list<-c('2hGlu_AA.tt','2hGlu_EUR.tt','FG_EAS.tt','FG_HISP.tt','FI_EUR_test.gz','FI_SAS.tt','HbA1c_EUR_test.gz','HbA1c_SAS.tt','2hGlu_EAS.tt','2hGlu_HISP.tt','FG_EUR_test.gz','FG_SAS.tt','FI_EUR_train.gz','HbA1c_AA.tt','HbA1c_EUR_train.gz','2hGlu_EUR_test.gz','2hGlu_SAS.tt','FG_EUR_train.gz','FI_AA.tt','FI_EUR.tt','HbA1c_AFR.tt','HbA1c_EUR.tt','2hGlu_EUR_train.gz','FG_AA.tt','FG_EUR.tt','FI_EAS.tt','FI_HISP.tt','HbA1c_EAS.tt','HbA1c_HISP.tt')

for(sumi in sum_data_list){
sum_data<-fread(sumi)
sumi<-strsplit(sumi,"\\.")[[1]][1]
sum_N<-max(sum_data$TotalSampleSize,na.rm=T)
sum_data<-sum_data[sum_data$TotalSampleSize>sum_N*0.5&sum_data$Freq1>0.05&sum_data$Freq1<0.95,]

marker_out<-sum_data$MarkerName
sum_beta<-sum_data$Effect
sum_se<-sum_data$StdErr
sum_a1<-toupper(sum_data$Allele1)
sum_a2<-toupper(sum_data$Allele2)
sum_p<-sum_data$'P-value'
sum_N1<-sum_data$TotalSampleSize
names(sum_beta)<-names(sum_se)<-names(sum_a1)<-names(sum_a2)<-names(sum_p)<-names(sum_N1)<-marker_out

sum_out<-data.frame(SNP=ref_snp[marker_out],A1=sum_a1,A2=sum_a2,BETA=sum_beta,P=sum_p,SE=sum_se,N=sum_N1)
write.table(sum_out,paste0(sumi,'.sums'),col.names=T,row.names=F,quote=F)

cat(paste0('for i in {1..22};do bsub -G t35_magic -o ',sumi,'.$i.log -R\'select[mem>7000] rusage[mem=7000]\' -M7000 ../PRScs/PRScs.py --ref_dir=../LD_ref/ldblk_1kg_eur --bim_prefix=../MAGIC_1000G/snpinfo_1kg_hm3 --sst_file=',sumi,'.sums --n_gwas=',round(sum_N),' --chrom=$i --out_dir=',sumi,';done\n'))
}
