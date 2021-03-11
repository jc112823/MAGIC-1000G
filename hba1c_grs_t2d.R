library(data.table)

kinship_cut<-0.088
remove_kinship<-function(x){
        id1<-x$ID1
        id2<-x$ID2
        kinship<-as.numeric(x$Kinship)
        checks<-kinship>kinship_cut
        idsum<-table(c(id1[checks],id2[checks]))
        idmax<-max(idsum)
        removeid<-names(idsum)[idsum==idmax]
        remain<-(!id1%in%removeid)&(!id2%in%removeid)
        while(max(kinship[remain])>kinship_cut){
                idsum<-table(c(id1[checks&remain],id2[checks&remain]))
                idmax<-max(idsum)
                removeid<-c(removeid,names(idsum)[idsum==idmax])
                remain<-(!id1%in%removeid)&(!id2%in%removeid)
        }
        removeid
}

zscore2pv<-function(x){
        if(abs(x)<qnorm(1-0.005)){out<-signif(pnorm(-abs(x))*2,2)}else{
                log10pv<-(pnorm(-abs(x),log.p=T)+log(2))/log(10)
                pvlevel<-floor(log10pv)
                a<-format(10^(log10pv-pvlevel))
                #out<-paste(a,'E',pvlevel,sep='')
                out<-bquote(.(a)~'X10'^.(pvlevel))
        }
        out
}

bridge<-fread('/lustre/scratch114/projects/ukbiobank_cmc_hba1c/bridging/ukb6401.enc_ukb',header=T,sep=',')
id10205<-bridge$app10205
names(id10205)<-bridge$app3913
qcfail<-id10205[fread('/lustre/scratch114/projects/ukbiobank_cmc_hba1c/genotypes/Fullrelease/Genotype/QC/sampleQCfail',header=F,colClasses='character',stringsAsFactors=F)$V1]

pheno102<-fread('ukbb102_t2d.sample',header=F)
id_all<-pheno102$V1
ukbb_t2d<-pheno102$V2
ukbb_t2d[ukbb_t2d%in%c(1,2,3)]<-1
age<-pheno102$V3
gender<-pheno102$V4
bmi<-pheno102$V5
names(ukbb_t2d)<-names(age)<-names(gender)<-names(bmi)<-id_all
id_misspheno<-id_all[ukbb_t2d<0|is.na(age)|is.na(gender)]#|is.na(bmi)]

famids<-fread('/lustre/scratch114/projects/ukbiobank_cmc_hba1c/genotypes/Fullrelease/Genotype/Raw/ukb1020_cal_chr1_v2_s488374_fixCol6.fam',header=F,colClasses='character',stringsAsFactors=F)$V1
AS_inPC_PC5<-as.matrix(fread('/lustre/scratch114/projects/ukbiobank_cmc_hba1c/genotypes/Fullrelease/ukb_sqc_v2.txt',select=c(24:30),header=F))
rownames(AS_inPC_PC5)<-famids
id_nonEA<-famids[AS_inPC_PC5[,1]!=1]
id_notPC<-famids[AS_inPC_PC5[,2]!=1]

# lookup_t2d<-fread('../Diagram/HbA1c_T2D_ldpruned.rename',header=T)
lookup_t2d<-fread('../HbA1c_T2D_ldpruned.noNA',header=T)
signal_rs<-lookup_t2d$HbA1c_signal
effectallele<-lookup_t2d$A1
logOR<-lookup_t2d$T2D_logOR
HbA1c_class<-lookup_t2d$HbA1c_class
HbA1c_class1<-lookup_t2d$HbA1c_class1
names(effectallele)<-names(logOR)<-names(HbA1c_class)<-names(HbA1c_class1)<-signal_rs
softG<-signal_rs[sapply(HbA1c_class1,function(x){tt<-strsplit(x,'/')[[1]];'G'%in%tt})]

dosages<-fread('all.dosage',header=T)
dosage_id<-names(dosages)[-c(1:6)]
dosage_rs<-dosages$rsid
dosage_allele<-dosages$alleleB
dosages<-as.matrix(dosages[,-c(1:6)])
names(dosage_allele)<-rownames(dosages)<-dosage_rs
colnames(dosages)<-dosage_id

sample_id<-dosage_id;print(length(sample_id))
sample_id<-setdiff(sample_id,qcfail);print(length(sample_id))
sample_id<-setdiff(sample_id,id_nonEA);print(length(sample_id))
sample_id<-setdiff(sample_id,c(id_misspheno));print(length(sample_id))

samplekinship<-fread('/lustre/scratch114/projects/ukbiobank_cmc_hba1c/genotypes/Fullrelease/ukb1020_rel_s488374.dat',header=T,stringsAsFactors=F)

cases<-sample_id[ukbb_t2d[sample_id]==1]
controls<-sample_id[ukbb_t2d[sample_id]==0]

casett<-samplekinship$ID1%in%cases&samplekinship$ID2%in%cases
case_remove<-remove_kinship(samplekinship[casett,])
cases<-cases[!cases%in%case_remove]
while(max(samplekinship$Kinship[samplekinship$ID1%in%cases&samplekinship$ID2%in%cases])>kinship_cut){cat('Related cases are found!')}

control_remove<-samplekinship$ID2[samplekinship$ID1%in%cases&samplekinship$ID2%in%controls&samplekinship$Kinship>kinship_cut]
control_remove<-c(control_remove,samplekinship$ID1[samplekinship$ID2%in%cases&samplekinship$ID1%in%controls&samplekinship$Kinship>kinship_cut])
controls<-controls[!controls%in%control_remove]

controltt<-samplekinship$ID1%in%controls&samplekinship$ID2%in%controls
control_remove<-c(control_remove,remove_kinship(samplekinship[controltt,]))

controls<-controls[!controls%in%control_remove]
while(max(samplekinship$Kinship[samplekinship$ID1%in%c(cases,controls)&samplekinship$ID2%in%c(cases,controls)])>kinship_cut){cat('Related case-control sample are found!')}

sample_id<-sample_id[sample_id%in%c(cases,controls)];print(length(sample_id))

classes<-c('All','G','nonG','mR','mRandG','mRnotG','R','RandG','RnotG','I','IandG','InotG','U','UandG','UnotG')
phenos<-matrix(NA,length(sample_id),24,dimnames=list(sample_id,c('T2D','AGE','GENDER','BMI',paste('PC',1:5,sep=''),classes)))
phenos[sample_id,'T2D']<-as.numeric(ukbb_t2d[sample_id])
phenos[sample_id,'AGE']<-as.numeric(age[sample_id])
phenos[sample_id,'GENDER']<-as.numeric(gender[sample_id])
phenos[sample_id,'BMI']<-as.numeric(bmi[sample_id])
phenos[sample_id,paste('PC',1:5,sep='')]<-as.numeric(AS_inPC_PC5[sample_id,c(-1,-2)])

print(table(ukbb_t2d[sample_id]))

flips<-signal_rs[(dosage_allele[signal_rs])!=(effectallele[signal_rs])]
logOR[flips]<--logOR[flips]

for(classi in c('All','mR','R','I','U')){
        print(classi)
        if(classi=='All'){
                rsi<-signal_rs
                print(length(rsi))
                phenos[sample_id,classi]<-t(dosages[rsi,sample_id,drop=F])%*%logOR[rsi]
                rsi<-signal_rs[HbA1c_class=='G']
                print(length(rsi))
                phenos[sample_id,'G']<-t(dosages[rsi,sample_id,drop=F])%*%logOR[rsi]
                rsi<-signal_rs[HbA1c_class!='G']
                print(length(rsi))
                phenos[sample_id,'nonG']<-t(dosages[rsi,sample_id,drop=F])%*%logOR[rsi]
        }else{
                rsi<-signal_rs[HbA1c_class==classi]
                print(length(rsi))
                phenos[sample_id,classi]<-t(dosages[rsi,sample_id,drop=F])%*%logOR[rsi]
                rsi<-intersect(signal_rs[HbA1c_class==classi],softG)
                print(length(rsi))
                phenos[sample_id,paste(classi,'andG',sep='')]<-t(dosages[rsi,sample_id,drop=F])%*%logOR[rsi]
                rsi<-setdiff(signal_rs[HbA1c_class==classi],softG)
                print(length(rsi))
                phenos[sample_id,paste(classi,'notG',sep='')]<-t(dosages[rsi,sample_id,drop=F])%*%logOR[rsi]
        }
}
phenos<-as.data.frame(phenos)

outt<-matrix(NA,length(classes),4,dimnames=list(classes,c('OR','lower95','upper95','zscore')))
rr_all<-summary(glm(T2D~AGE+GENDER+PC1+PC2+PC3+PC4+PC5+All,family=binomial(link='logit'),data=phenos))
outt['All',]<-c(exp(rr_all$coefficients['All','Estimate']+c(0,-1.96,1.96)*rr_all$coefficients['All','Std. Error']),rr_all$coefficients['All','z value'])

rr_G<-summary(glm(T2D~AGE+GENDER+PC1+PC2+PC3+PC4+PC5+G,family=binomial(link='logit'),data=phenos))
outt['G',]<-c(exp(rr_G$coefficients['G','Estimate']+c(0,-1.96,1.96)*rr_G$coefficients['G','Std. Error']),rr_G$coefficients['G','z value'])

rr_nonG<-summary(glm(T2D~AGE+GENDER+PC1+PC2+PC3+PC4+PC5+nonG,family=binomial(link='logit'),data=phenos))
outt['nonG',]<-c(exp(rr_nonG$coefficients['nonG','Estimate']+c(0,-1.96,1.96)*rr_nonG$coefficients['nonG','Std. Error']),rr_nonG$coefficients['nonG','z value'])

rr_mR<-summary(glm(T2D~AGE+GENDER+PC1+PC2+PC3+PC4+PC5+mR,family=binomial(link='logit'),data=phenos))
outt['mR',]<-c(exp(rr_mR$coefficients['mR','Estimate']+c(0,-1.96,1.96)*rr_mR$coefficients['mR','Std. Error']),rr_mR$coefficients['mR','z value'])

rr_mRandG<-summary(glm(T2D~AGE+GENDER+PC1+PC2+PC3+PC4+PC5+mRandG,family=binomial(link='logit'),data=phenos))
outt['mRandG',]<-c(exp(rr_mRandG$coefficients['mRandG','Estimate']+c(0,-1.96,1.96)*rr_mRandG$coefficients['mRandG','Std. Error']),rr_mRandG$coefficients['mRandG','z value'])

rr_mRnotG<-summary(glm(T2D~AGE+GENDER+PC1+PC2+PC3+PC4+PC5+mRnotG,family=binomial(link='logit'),data=phenos))
outt['mRnotG',]<-c(exp(rr_mRnotG$coefficients['mRnotG','Estimate']+c(0,-1.96,1.96)*rr_mRnotG$coefficients['mRnotG','Std. Error']),rr_mRnotG$coefficients['mRnotG','z value'])

rr_R<-summary(glm(T2D~AGE+GENDER+PC1+PC2+PC3+PC4+PC5+R,family=binomial(link='logit'),data=phenos))
outt['R',]<-c(exp(rr_R$coefficients['R','Estimate']+c(0,-1.96,1.96)*rr_R$coefficients['R','Std. Error']),rr_R$coefficients['R','z value'])

rr_RandG<-summary(glm(T2D~AGE+GENDER+PC1+PC2+PC3+PC4+PC5+RandG,family=binomial(link='logit'),data=phenos))
outt['RandG',]<-c(exp(rr_RandG$coefficients['RandG','Estimate']+c(0,-1.96,1.96)*rr_RandG$coefficients['RandG','Std. Error']),rr_RandG$coefficients['RandG','z value'])

rr_RnotG<-summary(glm(T2D~AGE+GENDER+PC1+PC2+PC3+PC4+PC5+RnotG,family=binomial(link='logit'),data=phenos))
outt['RnotG',]<-c(exp(rr_RnotG$coefficients['RnotG','Estimate']+c(0,-1.96,1.96)*rr_RnotG$coefficients['RnotG','Std. Error']),rr_RnotG$coefficients['RnotG','z value'])

rr_I<-summary(glm(T2D~AGE+GENDER+PC1+PC2+PC3+PC4+PC5+I,family=binomial(link='logit'),data=phenos))
outt['I',]<-c(exp(rr_I$coefficients['I','Estimate']+c(0,-1.96,1.96)*rr_I$coefficients['I','Std. Error']),rr_I$coefficients['I','z value'])

rr_IandG<-summary(glm(T2D~AGE+GENDER+PC1+PC2+PC3+PC4+PC5+IandG,family=binomial(link='logit'),data=phenos))
outt['IandG',]<-c(exp(rr_IandG$coefficients['IandG','Estimate']+c(0,-1.96,1.96)*rr_IandG$coefficients['IandG','Std. Error']),rr_IandG$coefficients['IandG','z value'])

rr_InotG<-summary(glm(T2D~AGE+GENDER+PC1+PC2+PC3+PC4+PC5+InotG,family=binomial(link='logit'),data=phenos))
outt['InotG',]<-c(exp(rr_InotG$coefficients['InotG','Estimate']+c(0,-1.96,1.96)*rr_InotG$coefficients['InotG','Std. Error']),rr_InotG$coefficients['InotG','z value'])

rr_U<-summary(glm(T2D~AGE+GENDER+PC1+PC2+PC3+PC4+PC5+U,family=binomial(link='logit'),data=phenos))
outt['U',]<-c(exp(rr_U$coefficients['U','Estimate']+c(0,-1.96,1.96)*rr_U$coefficients['U','Std. Error']),rr_U$coefficients['U','z value'])

rr_UandG<-summary(glm(T2D~AGE+GENDER+PC1+PC2+PC3+PC4+PC5+UandG,family=binomial(link='logit'),data=phenos))
outt['UandG',]<-c(exp(rr_UandG$coefficients['UandG','Estimate']+c(0,-1.96,1.96)*rr_UandG$coefficients['UandG','Std. Error']),rr_UandG$coefficients['UandG','z value'])

rr_UnotG<-summary(glm(T2D~AGE+GENDER+PC1+PC2+PC3+PC4+PC5+UnotG,family=binomial(link='logit'),data=phenos))
outt['UnotG',]<-c(exp(rr_UnotG$coefficients['UnotG','Estimate']+c(0,-1.96,1.96)*rr_UnotG$coefficients['UnotG','Std. Error']),rr_UnotG$coefficients['UnotG','z value'])

print(outt)

classestt<-c('All','G','nonG','R','RandG','RnotG','mR','mRandG','mRnotG','I','U')
names(classestt)<-c('All','Glycaemic','Non-Glycaemic','Reticulocyte','Reticulocyte and Glycaemic','Reticulocyte not Glycaemic','Mature red blood cell','Mature red blood cell and Glycaemic','Mature red blood cell not Glycaemic','Iron','Unknown')
pdf('GRS_forestplot_noboots.pdf')
options(digits=2)
maxOR<-max(outt[classestt,'upper95'])
plot(c(-maxOR*5,maxOR*3),c(0,length(classestt)),type='n',xlab='Odds Ratio',ylab='',axes=F)
axis(1,at=0:ceiling(maxOR),label=0:ceiling(maxOR))
abline(v=1,col='gray')
cols<-c('black','orange','green',rgb(1,0,0),rgb(1,0.5,0),rgb(1,0.3,0),rgb(0.7,0.2,0.2),rgb(0.7,0.6,0.2),rgb(0.7,0.4,0.2),'blue','gray60')
ind<-c(2.5,2,2,1.5,1,1,1.5,1,1,1.5,1.5)/2
k<-length(classestt)
for(i in classestt){
        xrange<-outt[i,'upper95']-outt[i,'lower95']
        x<-c(outt[i,'lower95'],outt[i,'OR'],outt[i,'upper95'],outt[i,'OR'],outt[i,'lower95'])
        y<-c(k,k+0.2,k,k-0.2,k)
        polygon(x,y,col=cols[length(classestt)-k+1])
        text(-maxOR*3.6-maxOR*ind[classestt%in%i],k,names(classestt)[classestt%in%i],col=cols[length(classestt)-k+1],adj=0)
        text(maxOR*2.6-maxOR*ind[classestt%in%i],k,zscore2pv(outt[i,'zscore']),col=cols[length(classestt)-k+1],adj=0)
        k<-k-1
}
dev.off()
