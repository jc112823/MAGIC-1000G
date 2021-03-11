#######################################################
#####  Run MANTRA
#######################################################

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/
mkdir MANTRA_FGluadjBMI_Raw
mkdir MANTRA_HbA1cadjFGlu_Raw
mkdir MANTRA_HbA1c_Raw
mkdir MANTRA_HbA1c_InvNorm
mkdir MANTRA_FInsadjBMI_InvNorm
mkdir MANTRA_2hrGluadjBMI_Raw
mkdir MANTRA_2hrGluadjBMI_InvNorm

# 1 - compile MANTRA in each folder
gfortran dmatcal.f95 -o dmatcal
gfortran mantra.v2.f95 -o mantra.v2

# 2a - download MANTRA inputs from sftp
get /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_MANTRA_Inputs/*FGluadjBMI.Raw*     /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/
get /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_MANTRA_Inputs/*FInsadjBMI.InvNorm* /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FInsadjBMI_InvNorm/
get /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_MANTRA_Inputs/*HbA1cadjFGlu.Raw*   /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1cadjFGlu_Raw/
get /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_MANTRA_Inputs/*HbA1c.Raw*          /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_Raw/
get /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_MANTRA_Inputs/*HbA1c.InvNorm*      /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_InvNorm/
get /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_MANTRA_Inputs/*2hrGluadjBMI.Raw*      /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_Raw/
get /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_MANTRA_Inputs/*2hrGluadjBMI.InvNorm*      /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_InvNorm/


get /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_MANTRA_Inputs/MAGIC.map.gz /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/
cp /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/MAGIC.map.gz /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1cadjFGlu_Raw/MAGIC.map.gz

# 2b - unzip MANTRA inputs in each folder
gunzip *.gz


# 2c - copied the needed files to each MANTRA folder and compile them again
cp /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/MAGIC.map     /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FInsadjBMI_InvNorm/
cp /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/dmatcal.f95   /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FInsadjBMI_InvNorm/
cp /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/mantra.v2.f95 /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FInsadjBMI_InvNorm/

cp /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/MAGIC.map     /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1cadjFGlu_Raw/
cp /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/dmatcal.f95   /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1cadjFGlu_Raw/
cp /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/mantra.v2.f95 /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1cadjFGlu_Raw/

cp /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/MAGIC.map     /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_Raw/
cp /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/dmatcal.f95   /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_Raw/
cp /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/mantra.v2.f95 /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_Raw/

cp /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/MAGIC.map     /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_InvNorm/
cp /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/dmatcal.f95   /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_InvNorm/
cp /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/mantra.v2.f95 /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_InvNorm/

cp /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/MAGIC.map     /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_Raw/
cp /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/dmatcal.f95   /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_Raw/
cp /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/mantra.v2.f95 /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_Raw/

cp /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/MAGIC.map     /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_InvNorm/
cp /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/dmatcal.f95   /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_InvNorm/
cp /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/mantra.v2.f95 /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_InvNorm/

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FInsadjBMI_InvNorm/
gfortran dmatcal.f95 -o dmatcal
gfortran mantra.v2.f95 -o mantra.v2
gunzip *.gz

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1cadjFGlu_Raw/
gfortran dmatcal.f95 -o dmatcal
gfortran mantra.v2.f95 -o mantra.v2
gunzip *.gz

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_Raw/
gfortran dmatcal.f95 -o dmatcal
gfortran mantra.v2.f95 -o mantra.v2
gunzip *.gz

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_InvNorm/
gfortran dmatcal.f95 -o dmatcal
gfortran mantra.v2.f95 -o mantra.v2
gunzip *.gz

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_Raw/
gfortran dmatcal.f95 -o dmatcal
gfortran mantra.v2.f95 -o mantra.v2
gunzip *.gz

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_InvNorm/
gfortran dmatcal.f95 -o dmatcal
gfortran mantra.v2.f95 -o mantra.v2
gunzip *.gz

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/


# 3a - Create mantra.in file
vi MANTRA_FGluadjBMI_Raw/mantra.in
mantra.FGluadjBMI.Raw.AA.dat AA
mantra.FGluadjBMI.Raw.HA.dat HA
mantra.FGluadjBMI.Raw.EA.dat EA
mantra.FGluadjBMI.Raw.EAA.dat EAA
mantra.FGluadjBMI.Raw.IAA.dat IAA

vi MANTRA_HbA1cadjFGlu_Raw/mantra.in
mantra.HbA1cadjFGlu.Raw.AA.dat AA
mantra.HbA1cadjFGlu.Raw.HA.dat HA
mantra.HbA1cadjFGlu.Raw.EA.dat EA
mantra.HbA1cadjFGlu.Raw.EAA.dat EAA
mantra.HbA1cadjFGlu.Raw.IAA.dat IAA

vi MANTRA_HbA1c_Raw/mantra.in
mantra.HbA1c.Raw.AA.dat AA
mantra.HbA1c.Raw.HA.dat HA
mantra.HbA1c.Raw.EA.dat EA
mantra.HbA1c.Raw.EAA.dat EAA
mantra.HbA1c.Raw.IAA.dat IAA
mantra.HbA1c.Raw.UA.dat UA

vi MANTRA_HbA1c_InvNorm/mantra.in
mantra.HbA1c.InvNorm.AA.dat AA
mantra.HbA1c.InvNorm.HA.dat HA
mantra.HbA1c.InvNorm.EA.dat EA
mantra.HbA1c.InvNorm.EAA.dat EAA
mantra.HbA1c.InvNorm.IAA.dat IAA
mantra.HbA1c.InvNorm.UA.dat UA

vi MANTRA_FInsadjBMI_InvNorm/mantra.in
mantra.FInsadjBMI.InvNorm.AA.dat AA
mantra.FInsadjBMI.InvNorm.HA.dat HA
mantra.FInsadjBMI.InvNorm.EA.dat EA
mantra.FInsadjBMI.InvNorm.EAA.dat EAA
mantra.FInsadjBMI.InvNorm.IAA.dat IAA

vi MANTRA_2hrGluadjBMI_Raw/mantra.in
mantra.2hrGluadjBMI.Raw.AA.dat AA
mantra.2hrGluadjBMI.Raw.HA.dat HA
mantra.2hrGluadjBMI.Raw.EA.dat EA
mantra.2hrGluadjBMI.Raw.EAA.dat EAA

vi MANTRA_2hrGluadjBMI_InvNorm/mantra.in
mantra.2hrGluadjBMI.InvNorm.AA.dat AA
mantra.2hrGluadjBMI.InvNorm.HA.dat HA
mantra.2hrGluadjBMI.InvNorm.EA.dat EA
mantra.2hrGluadjBMI.InvNorm.EAA.dat EAA


ls -lh MANTRA_*

cat  MANTRA_*/mantra.in


# 3b - Generate the relatedness matrix

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/
bsub -q normal -G t35_magic -o /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/bsub_dmatcal_FGluadjBMI_Raw.out -e /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/bsub_dmatcal_FGluadjBMI_Raw.err -R"select[mem>100] rusage[mem=100]" -M100 "./dmatcal"

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FInsadjBMI_InvNorm/
bsub -q normal -G t35_magic -o /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FInsadjBMI_InvNorm/bsub_dmatcal_FInsadjBMI_InvNorm.out -e /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FInsadjBMI_InvNorm/bsub_dmatcal_FInsadjBMI_InvNorm.err -R"select[mem>100] rusage[mem=100]" -M100 "./dmatcal"

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1cadjFGlu_Raw/
bsub -q normal -G t35_magic -o /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1cadjFGlu_Raw/bsub_dmatcal_HbA1cadjFGlu_Raw.out -e /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1cadjFGlu_Raw/bsub_dmatcal_HbA1cadjFGlu_Raw.err -R"select[mem>100] rusage[mem=100]" -M100 "./dmatcal"

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_Raw/
bsub -q normal -G t35_magic -o /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_Raw/bsub_dmatcal_HbA1c_Raw.out -e /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_Raw/bsub_dmatcal_HbA1c_Raw.err -R"select[mem>100] rusage[mem=100]" -M100 "./dmatcal"

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_InvNorm/
bsub -q normal -G t35_magic -o /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_InvNorm/bsub_dmatcal_HbA1c_InvNorm.out -e /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_InvNorm/bsub_dmatcal_HbA1c_InvNorm.err -R"select[mem>100] rusage[mem=100]" -M100 "./dmatcal"

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_Raw/
bsub -q normal -G t35_magic -o /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_Raw/bsub_dmatcal_2hrGluadjBMI_Raw.out -e /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_Raw/bsub_dmatcal_2hrGluadjBMI_Raw.err -R"select[mem>100] rusage[mem=100]" -M100 "./dmatcal"

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_InvNorm/
bsub -q normal -G t35_magic -o /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_InvNorm/bsub_dmatcal_2hrGluadjBMI_InvNorm.out -e /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_InvNorm/bsub_dmatcal_2hrGluadjBMI_InvNorm.err -R"select[mem>100] rusage[mem=100]" -M100 "./dmatcal"

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/


# 4 - Set up files to run MANTRA in parallel - by chunk of 50,000

wc MANTRA_FGluadjBMI_Raw/MAGIC.map # 44,964,714 variants

44964714/20000

chunk=20000
tt = NULL
dda = c("MANTRA_FGluadjBMI_Raw","MANTRA_FInsadjBMI_InvNorm","MANTRA_HbA1cadjFGlu_Raw","MANTRA_HbA1c_Raw","MANTRA_HbA1c_InvNorm","MANTRA_2hrGluadjBMI_Raw","MANTRA_2hrGluadjBMI_InvNorm")
for ( dd in dda[7] )
{
 cat(dd,".. ")
 for ( i in 1:2249 )
 {
  if (i%%100==0) {cat(i,".. ")}
  n_var_skip = (i-1)*chunk
  n_file = as.character(i) ; if(nchar(n_file)<4) { n_file=paste(c(rep("0",4-nchar(n_file)),n_file),collapse="") }
  seed = (797-which(dda==dd))*(i+10000)*i ; while(seed>2000000000){ seed=seed-1000000000 }
  write.table( cbind(c( "MAGIC.map" , as.integer(n_var_skip) , chunk , paste("mantra",n_file,"out",sep=".") , paste("mantra",n_file,"bet",sep=".") , seed )) ,
               paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/",dd,"/mantra.",n_file,".parm",sep="") , quote=F , row.names=F , col.names=F )
  tt = rbind(tt,c(dd,n_file,seed))
  rm(n_var_skip,n_file,seed)
 } ; rm(i) ; cat("Done.\n")
} ; rm(dd)

tt=data.frame(tt,stringsAsFactors=F)
tt$X4=as.numeric(tt$X2)
tt$Success = NA
tt$Success[ which(tt$X1 %in% c("MANTRA_FGluadjBMI_Raw","MANTRA_HbA1c_Raw") & tt$X4<=262) ]=1
tt$Success[ which(tt$X1 %in% c("MANTRA_FGluadjBMI_Raw","MANTRA_HbA1c_Raw") & tt$X4>262) ]=0
tt$Success[ which(tt$X1 %in% c("MANTRA_FInsadjBMI_InvNorm","MANTRA_HbA1cadjFGlu_Raw") & tt$X4<=264) ]=1
tt$Success[ which(tt$X1 %in% c("MANTRA_FInsadjBMI_InvNorm","MANTRA_HbA1cadjFGlu_Raw") & tt$X4>264) ]=0
tt$Success[ which(tt$X1 %in% c("MANTRA_HbA1c_InvNorm") & tt$X4<=263) ]=1
tt$Success[ which(tt$X1 %in% c("MANTRA_HbA1c_InvNorm") & tt$X4>263) ]=0

summary(as.numeric(tt$X3)) ; min(as.numeric(tt$X3)) ; max(as.numeric(tt$X3))
summary(as.numeric(tt$X3[which(tt$Success==1)])) ; min(as.numeric(tt$X3[which(tt$Success==1)])) ; max(as.numeric(tt$X3[which(tt$Success==1)]))
summary(as.numeric(tt$X3[which(tt$Success==0)])) ; min(as.numeric(tt$X3[which(tt$Success==0)])) ; max(as.numeric(tt$X3[which(tt$Success==0)]))




ls -1 MANTRA_FGluadjBMI_Raw/mantra.*.parm | wc
ls -1 MANTRA_FInsadjBMI_InvNorm/mantra.*.parm | wc
ls -1 MANTRA_HbA1cadjFGlu_Raw/mantra.*.parm | wc
ls -1 MANTRA_HbA1c_Raw/mantra.*.parm | wc
ls -1 MANTRA_HbA1c_InvNorm/mantra.*.parm | wc
ls -1 MANTRA_2hrGluadjBMI_Raw/mantra.*.parm | wc
ls -1 MANTRA_2hrGluadjBMI_InvNorm/mantra.*.parm | wc



grep "+" MANTRA_FGluadjBMI_Raw/mantra.*.parm
grep "+" MANTRA_FInsadjBMI_InvNorm/mantra.*.parm
grep "+" MANTRA_HbA1cadjFGlu_Raw/mantra.*.parm
grep "+" MANTRA_HbA1c_Raw/mantra.*.parm
grep "+" MANTRA_HbA1c_InvNorm/mantra.*.parm
grep "+" MANTRA_2hrGluadjBMI_Raw/mantra.*.parm
grep "+" MANTRA_2hrGluadjBMI_InvNorm/mantra.*.parm


# 5 - runMANTRA


cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/
for i in `ls -1 *parm | grep -vF ".00" | grep -vF ".01" | grep -vF ".020" | grep -vF ".021" | grep -vF ".022" | grep -vF ".023" | grep -vF ".024" | grep -vF ".025"`; do bsub -q normal -G t35_magic -o bsub.$i.out -e bsub.$i.err -R"select[mem>15] rusage[mem=15]" -M15 "./mantra.v2 < $i"; done

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FInsadjBMI_InvNorm/
for i in `ls -1 *parm | grep -vF ".00" | grep -vF ".01" | grep -vF ".020" | grep -vF ".021" | grep -vF ".022" | grep -vF ".023" | grep -vF ".024" | grep -vF ".025"`; do bsub -q normal -G t35_magic -o bsub.$i.out -e bsub.$i.err -R"select[mem>15] rusage[mem=15]" -M15 "./mantra.v2 < $i"; done

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1cadjFGlu_Raw/
for i in `ls -1 *parm | grep -vF ".00" | grep -vF ".01" | grep -vF ".020" | grep -vF ".021" | grep -vF ".022" | grep -vF ".023" | grep -vF ".024" | grep -vF ".025"`; do bsub -q normal -G t35_magic -o bsub.$i.out -e bsub.$i.err -R"select[mem>15] rusage[mem=15]" -M15 "./mantra.v2 < $i"; done

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_Raw/
for i in mantra.0220.parm; do bsub -q normal -G t35_magic -o bsub.$i.out -e bsub.$i.err -R"select[mem>15] rusage[mem=15]" -M15 "./mantra.v2 < $i"; done
for i in `ls -1 *parm | grep -vF ".00" | grep -vF ".01" | grep -vF ".020" | grep -vF ".021" | grep -vF ".022" | grep -vF ".023" | grep -vF ".024" | grep -vF ".025"`; do bsub -q normal -G t35_magic -o bsub.$i.out -e bsub.$i.err -R"select[mem>15] rusage[mem=15]" -M15 "./mantra.v2 < $i"; done

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_InvNorm/
for i in `ls -1 *parm | grep -vF ".00" | grep -vF ".01" | grep -vF ".020" | grep -vF ".021" | grep -vF ".022" | grep -vF ".023" | grep -vF ".024" | grep -vF ".025"`; do bsub -q normal -G t35_magic -o bsub.$i.out -e bsub.$i.err -R"select[mem>15] rusage[mem=15]" -M15 "./mantra.v2 < $i"; done

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_Raw/
for i in `ls -1 *parm`; do bsub -q normal -G t35_magic -o bsub.$i.out -e bsub.$i.err -R"select[mem>15] rusage[mem=15]" -M15 "./mantra.v2 < $i"; done

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_InvNorm/
for i in `ls -1 *parm`; do bsub -q normal -G t35_magic -o bsub.$i.out -e bsub.$i.err -R"select[mem>15] rusage[mem=15]" -M15 "./mantra.v2 < $i"; done

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/

grep Success MANTRA_*/bsub.mantra.*.out | wc

bjobs | grep parm | wc
bjobs | grep parm | grep RUN | wc

grep Success MANTRA_FGluadjBMI_Raw/bsub.mantra.*.out  | wc
grep Success MANTRA_FInsadjBMI_InvNorm/bsub.mantra.*.out  | wc
grep Success MANTRA_HbA1cadjFGlu_Raw/bsub.mantra.*.out  | wc
grep Success MANTRA_HbA1c_Raw/bsub.mantra.*.out  | wc
grep Success MANTRA_HbA1c_InvNorm/bsub.mantra.*.out  | wc
grep Success MANTRA_2hrGluadjBMI_Raw/bsub.mantra.*.out  | wc
grep Success MANTRA_2hrGluadjBMI_InvNorm/bsub.mantra.*.out  | wc

grep overflow MANTRA_FGluadjBMI_Raw/*.err | wc
grep overflow MANTRA_FInsadjBMI_InvNorm/*.err | wc
grep overflow MANTRA_HbA1cadjFGlu_Raw/*.err | wc
grep overflow MANTRA_HbA1c_Raw/*.err | wc
grep overflow MANTRA_HbA1c_InvNorm/*.err | wc
grep overflow MANTRA_2hrGluadjBMI_Raw/*.err | wc
grep overflow MANTRA_2hrGluadjBMI_InvNorm/*.err | wc

grep "Bad integer" MANTRA_FGluadjBMI_Raw/*.err
grep "Bad integer" MANTRA_FInsadjBMI_InvNorm/*.err
grep "Bad integer" MANTRA_HbA1cadjFGlu_Raw/*.err
grep "Bad integer" MANTRA_HbA1c_Raw/*.err
grep "Bad integer" MANTRA_HbA1c_InvNorm/*.err
grep "Bad integer" MANTRA_2hrGluadjBMI_Raw/*.err
grep "Bad integer" MANTRA_2hrGluadjBMI_InvNorm/*.err

grep exit MANTRA_FGluadjBMI_Raw/bsub.mantra.*.out  | wc
grep exit MANTRA_FInsadjBMI_InvNorm/bsub.mantra.*.out  | wc
grep exit MANTRA_HbA1cadjFGlu_Raw/bsub.mantra.*.out  | wc
grep exit MANTRA_HbA1c_Raw/bsub.mantra.*.out  | wc
grep exit MANTRA_HbA1c_InvNorm/bsub.mantra.*.out  | wc
grep exit MANTRA_2hrGluadjBMI_Raw/bsub.mantra.*.out  | wc
grep exit MANTRA_2hrGluadjBMI_InvNorm/bsub.mantra.*.out  | wc

grep "Cannot open your job file" MANTRA_HbA1c_Raw/bsub.mantra.*.out | wc
grep exit MANTRA_HbA1c_Raw/bsub.mantra.*.out  | wc
grep "Cannot open your job file" MANTRA_HbA1c_InvNorm/bsub.mantra.*.out | wc


cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_Raw/
for i in 1572 1784 1804 1860 1861 1866 1867 1868 1892 1893 1894 1895 1896 2111 2241; do rm bsub.mantra.$i.*; rm mantra.$i.out ; rm mantra.$i.bet ; bsub -q normal -G t35_magic -o bsub.$i.out -e bsub.$i.err -R"select[mem>15] rusage[mem=15]" -M15 "./mantra.v2 < mantra.$i.parm" ; done
cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_InvNorm/
for i in 1261 1395 1396 1649 1668; do rm bsub.mantra.$i.*; rm mantra.$i.out ; rm mantra.$i.bet ; bsub -q normal -G t35_magic -o bsub.$i.out -e bsub.$i.err -R"select[mem>15] rusage[mem=15]" -M15 "./mantra.v2 <  mantra.$i.parm" ; done
for i in 0300  0328  0506  0507  0632  0689  0690  0691  0692  0693  0694  0884; do rm bsub.mantra.$i.*; rm mantra.$i.out ; rm mantra.$i.bet ; bsub -q normal -G t35_magic -o bsub.mantra.$i.parm.out -e bsub.mantra.$i.parm.err -R"select[mem>15] rusage[mem=15]" -M15 "./mantra.v2 <  mantra.$i.parm" ; done


grep Success MANTRA_HbA1c_Raw/bsub.*.out  | wc
grep Success MANTRA_HbA1c_InvNorm/bsub.*.out  | wc


cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_InvNorm/
for i in 0957 0959 0960 0995 0996 1622 1624; do rm bsub.mantra.$i.*; rm mantra.$i.out ; rm mantra.$i.bet; done
for i in 0957 0959 0960 0995 0996 1622 1624; do bsub -q long -G t35_magic -o bsub.mantra.$i.parm.out -e bsub.mantra.$i.parm.err -R"select[mem>15] rusage[mem=15]" -M15 "./mantra.v2 < mantra.$i.parm" ; done

grep Success MANTRA_2hrGluadjBMI_InvNorm/bsub.mantra.*.out  | wc








ls -1 MANTRA_FGluadjBMI_Raw/mantra.*.out | wc
ls -1 MANTRA_FInsadjBMI_InvNorm/mantra.*.out | wc
ls -1 MANTRA_HbA1cadjFGlu_Raw/mantra.*.out | wc
ls -1 MANTRA_HbA1c_Raw/mantra.*.out | wc
ls -1 MANTRA_HbA1c_InvNorm/mantra.*.out | wc
ls -1 MANTRA_2hrGluadjBMI_Raw/mantra.*.out | wc
ls -1 MANTRA_2hrGluadjBMI_InvNorm/mantra.*.out | wc


# 6a - Concatenate and compress output files

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/
bsub -q normal -G t35_magic -o bsub_concat.out -e bsub_concat.err -R"select[mem>100] rusage[mem=100]" -M100 "cat mantra.*.out | bgzip -c > mantra.FGluadjBMI.Raw.GM.out.gz"
bsub -q normal -G t35_magic -o bsub_betconcat.out -e bsub_betconcat.err -R"select[mem>100] rusage[mem=100]" -M100 "cat mantra.*.bet | bgzip -c > mantra.FGluadjBMI.Raw.GM.bet.gz"

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FInsadjBMI_InvNorm/
bsub -q normal -G t35_magic -o bsub_concat.out -e bsub_concat.err -R"select[mem>100] rusage[mem=100]" -M100 "cat mantra.*.out | bgzip -c > mantra.FInsadjBMI.InvNorm.GM.out.gz"
bsub -q normal -G t35_magic -o bsub_betconcat.out -e bsub_betconcat.err -R"select[mem>100] rusage[mem=100]" -M100 "cat mantra.*.bet | bgzip -c > mantra.FInsadjBMI.InvNorm.GM.bet.gz"

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1cadjFGlu_Raw/
bsub -q normal -G t35_magic -o bsub_concat.out -e bsub_concat.err -R"select[mem>100] rusage[mem=100]" -M100 "cat mantra.*.out | bgzip -c > mantra.HbA1cadjFGlu.Raw.GM.out.gz"
bsub -q normal -G t35_magic -o bsub_betconcat.out -e bsub_betconcat.err -R"select[mem>100] rusage[mem=100]" -M100 "cat mantra.*.bet | bgzip -c > mantra.HbA1cadjFGlu.Raw.GM.bet.gz"

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_Raw/
bsub -q normal -G t35_magic -o bsub_concat.out -e bsub_concat.err -R"select[mem>100] rusage[mem=100]" -M100 "cat mantra.*.out | bgzip -c > mantra.HbA1c.Raw.GM.out.gz"
bsub -q normal -G t35_magic -o bsub_betconcat.out -e bsub_betconcat.err -R"select[mem>100] rusage[mem=100]" -M100 "cat mantra.*.bet | bgzip -c > mantra.HbA1c.Raw.GM.bet.gz"

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_InvNorm/
bsub -q normal -G t35_magic -o bsub_concat.out -e bsub_concat.err -R"select[mem>100] rusage[mem=100]" -M100 "cat mantra.*.out | bgzip -c > mantra.HbA1c.InvNorm.GM.out.gz"
bsub -q normal -G t35_magic -o bsub_betconcat.out -e bsub_betconcat.err -R"select[mem>100] rusage[mem=100]" -M100 "cat mantra.*.bet | bgzip -c > mantra.HbA1c.InvNorm.GM.bet.gz"

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_Raw/
bsub -q normal -G t35_magic -o bsub_concat.out -e bsub_concat.err -R"select[mem>100] rusage[mem=100]" -M100 "cat mantra.*.out | bgzip -c > mantra.2hrGluadjBMI.Raw.GM.out.gz"
bsub -q normal -G t35_magic -o bsub_betconcat.out -e bsub_betconcat.err -R"select[mem>100] rusage[mem=100]" -M100 "cat mantra.*.bet | bgzip -c > mantra.2hrGluadjBMI.Raw.GM.bet.gz"

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_InvNorm/
bsub -q normal -G t35_magic -o bsub_concat.out -e bsub_concat.err -R"select[mem>100] rusage[mem=100]" -M100 "cat mantra.*.out | bgzip -c > mantra.2hrGluadjBMI.InvNorm.GM.out.gz"
bsub -q normal -G t35_magic -o bsub_betconcat.out -e bsub_betconcat.err -R"select[mem>100] rusage[mem=100]" -M100 "cat mantra.*.bet | bgzip -c > mantra.2hrGluadjBMI.InvNorm.GM.bet.gz"

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/

# 6a - Remove mantra files

wc MANTRA_FGluadjBMI_Raw/mantra.*.out     > wc_out_FG_r.txt
wc MANTRA_FInsadjBMI_InvNorm/mantra.*.out > wc_out_FI_i.txt
wc MANTRA_HbA1cadjFGlu_Raw/mantra.*.out   > wc_out_HA_r.txt
wc MANTRA_HbA1c_Raw/mantra.*.out          > wc_out_HU_r.txt
wc MANTRA_HbA1c_InvNorm/mantra.*.out      > wc_out_HU_i.txt

wc MANTRA_FGluadjBMI_Raw/mantra.*.bet     > wc_bet_FG_r.txt
wc MANTRA_FInsadjBMI_InvNorm/mantra.*.bet > wc_bet_FI_i.txt
wc MANTRA_HbA1cadjFGlu_Raw/mantra.*.bet   > wc_bet_HA_r.txt
wc MANTRA_HbA1c_Raw/mantra.*.bet          > wc_bet_HU_r.txt
wc MANTRA_HbA1c_InvNorm/mantra.*.bet      > wc_bet_HU_i.txt

wc MANTRA_2hrGluadjBMI_Raw/mantra.*.out      > wc_out_H2_r.txt
wc MANTRA_2hrGluadjBMI_Raw/mantra.*.bet      > wc_bet_H2_r.txt

wc MANTRA_2hrGluadjBMI_InvNorm/mantra.*.out      > wc_out_H2_i.txt
wc MANTRA_2hrGluadjBMI_InvNorm/mantra.*.bet      > wc_bet_H2_i.txt


tail -n1 wc*
#==> wc_bet_FG_r.txt <==
#  42,680,861  508966346 8424605640 total
#==> wc_bet_FI_i.txt <==
#  41,471,551  489848164 8084914017 total
#==> wc_bet_HA_r.txt <==
#  40,590,207  480876764 7944028213 total
#==> wc_bet_HU_i.txt <==
#  43,540,445  551622406 9290995474 total
#==> wc_bet_HU_r.txt <==
#  43,552,315  552028108 9299017737 total
#==> wc_out_FG_r.txt <==
#  42,680,861  597532054 6914299482 total
#==> wc_out_FI_i.txt <==
#  41,471,551  580601714 6718391262 total
#==> wc_out_HA_r.txt <==
#  40,590,207  568262898 6575613534 total
#==> wc_out_HU_i.txt <==
#  43,540,445  609566230 7097092535 total
#==> wc_out_HU_r.txt <==
#  43,552,315  609732410 7099027345 total
#==> wc_bet_H2_r.txt <==
#  38,653,555  405883776 6445941439 total
#==> wc_out_H2_r.txt <==
#  38,653,555  541149770 6223222355 total
#==> wc_bet_H2_i.txt <==
#  38,654,119  405837822 6444920152 total
#==> wc_out_H2_i.txt <==
#  38,654,119  541157666 6223313159 total

for ff in `ls -1 MANTRA*/*.GM.*.gz` ; do echo $ff; zcat $ff | wc; done
#MANTRA_FGluadjBMI_Raw/mantra.FGluadjBMI.Raw.GM.bet.gz
#42,680,861 508966346 8424605640  --> OK
#MANTRA_FGluadjBMI_Raw/mantra.FGluadjBMI.Raw.GM.out.gz
#42,680,861 597532054 6914299482  --> OK
#MANTRA_FInsadjBMI_InvNorm/mantra.FGluadjBMI.Raw.GM.bet.gz
#41,471,551 489848164 8084914017  --> OK
#MANTRA_FInsadjBMI_InvNorm/mantra.FInsadjBMI.InvNorm.GM.out.gz
#41,471,551 580601714 6718391262  --> OK
#MANTRA_HbA1cadjFGlu_Raw/mantra.FGluadjBMI.Raw.GM.bet.gz
#40,590,207 480876764 7944028213  --> OK
#MANTRA_HbA1cadjFGlu_Raw/mantra.HbA1cadjFGlu.Raw.GM.out.gz
#40,590,207 568262898 6575613534  --> OK
#MANTRA_HbA1c_InvNorm/mantra.FGluadjBMI.Raw.GM.bet.gz
#43,540,445 551622406 9290995474  --> OK
#MANTRA_HbA1c_InvNorm/mantra.HbA1c.InvNorm.GM.out.gz
#43,540,445 609566230 7097092535  --> OK
#MANTRA_HbA1c_Raw/mantra.FGluadjBMI.Raw.GM.bet.gz
#43,552,315 552028108 9299017737  --> OK
#MANTRA_HbA1c_Raw/mantra.HbA1c.Raw.GM.out.gz
#43,552,315 609732410 7099027345  --> OK
for ff in `ls -1 MANTRA_2hrGluadjBMI_Raw/*.GM.bet.gz` ; do echo $ff; zcat $ff | wc; done
#MANTRA_2hrGluadjBMI_Raw/mantra.2hrGluadjBMI.Raw.GM.out.gz
#38,653,555 541149770 6223222355  --> OK
#MANTRA_2hrGluadjBMI_Raw/mantra.2hrGluadjBMI.Raw.GM.bet.gz
#38,653,555 405883776 6445941439  --> OK
for ff in `ls -1 MANTRA_2hrGluadjBMI_InvNorm/*.GM.*.gz` ; do echo $ff; zcat $ff | wc; done
#MANTRA_2hrGluadjBMI_InvNorm/mantra.2hrGluadjBMI.InvNorm.GM.bet.gz
#38,654,119 405837822 6444920152
#MANTRA_2hrGluadjBMI_InvNorm/mantra.2hrGluadjBMI.InvNorm.GM.out.gz
#38,654,119 541157666 6223313159



du -h MANTRA*

for ff in `ls -1d MANTRA*` ; do echo $ff; ls -1 $ff/mantra.*.out | wc; done
for ff in `ls -1d MANTRA*` ; do echo $ff; ls -1 $ff/mantra.*.bet | wc; done

 rm MANTRA*/mantra.*.out
 rm MANTRA*/mantra.*.bet


for ff in `ls -1d MANTRA_2hrGluadjBMI_InvNorm` ; do echo $ff; ls -1 $ff/mantra.*.out | wc; done
for ff in `ls -1d MANTRA_2hrGluadjBMI_InvNorm` ; do echo $ff; ls -1 $ff/mantra.*.bet | wc; done

 rm MANTRA_2hrGluadjBMI_InvNorm/mantra.*.out
 rm MANTRA_2hrGluadjBMI_InvNorm/mantra.*.bet


# 7 - upload results on sftp
put /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/mantra.FGluadjBMI.Raw.GM.out.gz         /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_MANTRA_Results/
put /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FInsadjBMI_InvNorm/mantra.FInsadjBMI.InvNorm.GM.out.gz /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_MANTRA_Results/
put /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1cadjFGlu_Raw/mantra.HbA1cadjFGlu.Raw.GM.out.gz     /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_MANTRA_Results/
put /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_Raw/mantra.HbA1c.Raw.GM.out.gz                   /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_MANTRA_Results/
put /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_InvNorm/mantra.HbA1c.InvNorm.GM.out.gz           /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_MANTRA_Results/
put /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_Raw/mantra.2hrGluadjBMI.Raw.GM.out.gz     /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_MANTRA_Results/
put /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_InvNorm/mantra.2hrGluadjBMI.InvNorm.GM.out.gz /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_MANTRA_Results/



#######################################################
#####  Cleaning!!
#######################################################

## compressed the .dat files

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_InvNorm/
bgzip *.dat
rm MAGIC.map

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_Raw/
for ff in `ls *.dat`; do bgzip $ff; done
rm MAGIC.map

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FGluadjBMI_Raw/
for ff in `ls *.dat`; do echo $ff; bgzip $ff; done
bgzip MAGIC.map

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FInsadjBMI_InvNorm/
for ff in `ls *.dat`; do echo $ff; bgzip $ff; done
rm MAGIC.map
du -h

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1cadjFGlu_Raw/
for ff in `ls *.dat`; do echo $ff; bgzip $ff; done
rm MAGIC.map
du -h

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_InvNorm/
for ff in `ls *.dat`; do echo $ff; bgzip $ff; done
rm MAGIC.map
du -h

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_Raw/
for ff in `ls *.dat`; do echo $ff; bgzip $ff; done
rm MAGIC.map
du -h



cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/

for j in MANTRA_2hrGluadjBMI_InvNorm MANTRA_2hrGluadjBMI_Raw MANTRA_FGluadjBMI_Raw MANTRA_FInsadjBMI_InvNorm MANTRA_HbA1cadjFGlu_Raw MANTRA_HbA1c_InvNorm MANTRA_HbA1c_Raw; do for i in `ls $j/*.dat*`; do echo $i; done; done



## compresse MAGIC.map and keep only one version in MANTRA_FGluadjBMI_Raw







#######################################################
#####  QQ , Manhattan & Distance-clumping
#######################################################

y="HbA1c"
z="Raw"
clump=1

#------------------------------------ R code for Interpretation
param = commandArgs(trailingOnly=T)

y=param[1]
z=param[2]
clump=as.numeric(param[3])


summ = c(Trait=y,Transf=z)

# loading results
nR = 5800
nS = 500000
ff1 = NULL
for ( i in 39:87 )
{
 #cat(i,": from",((i-1)*nS+1),"to",((i-1)*nS+nR),"\n")
 cat(i,".. ")
 ff0 = read.table( gzfile(paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_",y,"_",z,"/mantra.",y,".",z,".GM.out.gz",sep="")) ,
                   h=T , as.is=T , nrows=nR , skip=((i-1)*nS) ,
                   col.names=c("MarkerName","Chr","Pos","Effect_Allele","Other_Allele","N_Ethnicity","Effect_AC","Minor_AC","Effect_Allele_Freq","Log10BF_MANTRA","Log10BF_FE","Log10BF_Heterogeneity","Sample_Size","Direction") )
 ff1 = rbind(ff1,ff0) ; rm(ff0)
} ; rm(i) ; cat("Done.\n")

save( ff1 , file=paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_",y,"_",z,"/mantra.",y,".",z,".GM.PART.RData",sep=""))


# common and non-heterogenous and good sample size variants
wwCOMM = which( ff1$Effect_Allele_Freq>0.05 & ff1$Effect_Allele_Freq<0.95 )
sampsize=max(ff1$Sample_Size)
goodsampsize=(sampsize/3)
wwCOMMgoodsampsize = which( ff1$Effect_Allele_Freq>0.05 & ff1$Effect_Allele_Freq<0.95 & ff1$Sample_Size>=goodsampsize )
summ = c( summ ,
          Nvariants=nrow(ff1) ,
          N_signif6=sum(ff1$Log10BF_MANTRA>6) ,
          N_signif6_goodsampsize=sum(ff1$Log10BF_MANTRA>6 & ff1$Sample_Size>=goodsampsize ) ,
          Ncommon_homogenous=length(wwCOMM),
          MaxSampleSize=sampsize,
          ThresholdSampSize=goodsampsize,
          Ncommon_homogenous_goodsampsize=length(wwCOMMgoodsampsize)
        )


# known loci for HbA1c
ff1$Known=0
if (y %in% c("HbA1c","HbA1cadjFGlu"))
{
 known=read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/ReferenceFiles/known_SNPs_B37_HbA1c.txt",as.is=T,h=T,sep="\t")
 known$MarkerName = paste( ifelse(known$CHR==23,yes="X",no=known$CHR) ,known$POS_37,"SNP",sep=":")
 #known$EA_signif  = ifelse( known$EA_PVAL<5e-08  , yes=2  , no=ifelse(known$EA_PVAL<0.05 ,yes=1,no=0) )
 #known$AA_signif  = ifelse( known$AA_PVAL<5e-08  , yes=2  , no=ifelse(known$AA_PVAL<0.05 ,yes=1,no=0) )
 #known$EAA_signif = ifelse( known$EAA_PVAL<5e-08 , yes=2  , no=ifelse(known$EAA_PVAL<0.05,yes=1,no=0) )
 #known$SAA_signif = ifelse( known$SAA_PVAL<5e-08 , yes=2  , no=ifelse(known$SAA_PVAL<0.05,yes=1,no=0) )

 summ = c( summ ,
           NknownLociForTrait = nrow(known),
           NknownLociForTraitInFile = sum(ff1$MarkerName %in% known$MarkerName) ,
           NknownLociForTraitInFile6 = sum(ff1$MarkerName %in% known$MarkerName & ff1$Log10BF_MANTRA>6)
        )

 if( sum(ff1$MarkerName %in% known$MarkerName)>0 )
 {
  known1 = merge( ff1 , known , by="MarkerName" )
  write.table(known1,paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/KnownLoci_",y,"_",z,".txt",sep=""),quote=F,row.names=F,sep="\t")
  rm(known1)
  ff1$Known[which(ff1$MarkerName %in% known$MarkerName)]=1
  for ( i in which(ff1$Known==1) )
  {
   ff1$Known[which(ff1$Chr==ff1$Chr[i] & ff1$Pos>=(ff1$Pos[i]-500000) & ff1$Pos<=(ff1$Pos[i]+500000))]=2
   ff1$Known[i]=1
  } ; rm(i)
 }

 rm(known)
} else {
         known=read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/ReferenceFiles/known_SNPs_B37_OtherTraits.txt",as.is=T,h=T,sep="\t")
         if( y=="FGluadjBMI"   ) { known=known[which(known$phenotype=="fg"),] }
         if( y=="FInsadjBMI"   ) { known=known[which(substr(known$phenotype,1,2)=="fi"),] }
         if( y=="2hrGluadjBMI" ) { known=known[which(known$phenotype=="2hglu"),] }
         known$MarkerName = paste(known$chr,known$pos,"SNP",sep=":")
         summ = c( summ ,
                   NknownLociForTrait = nrow(known),
                   NknownLociForTraitInFile = sum(ff1$MarkerName %in% known$MarkerName) ,
                   NknownLociForTraitInFile6 = sum(ff1$MarkerName %in% known$MarkerName & ff1$Log10BF_MANTRA>6)
        )
        if( sum(ff1$MarkerName %in% known$MarkerName)>0 )
        {
         known1 = merge( ff1 , known , by="MarkerName" )
         write.table(known1,paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/KnownLoci_",y,"_",z,".txt",sep=""),quote=F,row.names=F,sep="\t")
         rm(known1)
         ff1$Known[which(ff1$MarkerName %in% known$MarkerName)]=1
         for ( i in which(ff1$Known==1) )
         {
          ff1$Known[which(ff1$Chr==ff1$Chr[i] & ff1$Pos>=(ff1$Pos[i]-500000) & ff1$Pos<=(ff1$Pos[i]+500000))]=2
          ff1$Known[i]=1
         } ; rm(i)
        }
        rm(known)
       }


# Manhattan
ff1s = ff1[order(ff1$Chr,ff1$Pos),]
rm(ff1) ; gc()

mm = max(ff1s$Log10BF_MANTRA)
obslogbfmax <- trunc(mm)+5
#obslogbfmax <- 80

print(mm)
print(obslogbfmax)

x1 <- 1:25
x2<- 1:2

for (i in 1:25)
{
         curchr=which(ff1s$Chr==i)
         x1[i] <- trunc((max(ff1s$Pos[curchr]))/100) +100000
         x2[i] <- trunc((min(ff1s$Pos[curchr]))/100) -100000
}

x1[1]=x1[1]-x2[1]
x2[1]=0-x2[1]

for (i in 2:26)
{
        x1[i] <- x1[i-1]-x2[i]+x1[i]
        x2[i] <- x1[i-1]-x2[i]

}
ff1s$locX = trunc(ff1s$Pos/100) + x2[ff1s$Chr]


col1=rgb(0,0,108,maxColorValue=255)
col2=rgb(100,149,237,maxColorValue=255)
col3=rgb(0,205,102,maxColorValue=255)
col4 <- ifelse(ff1s$Chr%%2==0, col1, col2)

png(paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/Manhattan_",y,"_",z,".png",sep=""),height=600,width=800)
plot(ff1s$locX,ff1s$Log10BF_MANTRA,pch=20,col=col4,xaxt="n",ylab="log10(MANTRA BF)",xlab="",bty="n",ylim=c(0,obslogbfmax),cex=0.8)
abline(h=6,lty=2,col="grey")
wwK = which(ff1s$Known > 0) ; if(length(wwK)>0) { points(ff1s$locX[wwK],ff1s$Log10BF_MANTRA[wwK],pch=20,col="black",cex=0.8) } ; rm(wwK)
wwS = which(ff1s$Log10BF_MANTRA > 6 & ff1s$Known==0) ; if(length(wwS)>0) { points(ff1s$locX[wwS],ff1s$Log10BF_MANTRA[wwS],pch=20,col="red",cex=0.8) } ; rm(wwS)
dev.off()


# ---> clump
ff1s$nClump=0
ff1s$GeneForSignals=NA

 nClump=0
if (clump==1)
{
 genes = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/ReferenceFiles/hg19_genes.txt", col.names=c("chr","start","end","gene"), header=F,as.is=T)
 genes=unique(genes)
 ff2 = ff1s
 ClumpSignals = NULL
 # identify most significant variant sequentially
 while( max(ff2$Log10BF_MANTRA)>6 )
 {
  nClump=nClump+1
  cat("--> region no",nClump,": ")
  wwS = which(ff2$Log10BF_MANTRA==max(ff2$Log10BF_MANTRA))
  if( length(wwS)>1 )
  {
   cat("More than one signal. ")
   wwS = wwS[ which(ff2$TotalSampleSize[wwS]==max(ff2$TotalSampleSize[wwS])) ]
   if(length(wwS)>1){cat("STILL More than one signal: ",paste(ff2$MarkerName[wwS],collapse=","),". ");wwS=wwS[1]}
  }
  chrS=ff2$Chr[wwS] ; posS=ff2$Pos[wwS]

  region = ff2[ which(ff2$Chr==chrS & ff2$Pos>=(posS-500000) & ff2$Pos<=(posS+500000)) ,]
  region$Signal=ifelse( region$MarkerName==ff2$MarkerName[wwS] , yes=1 , no=0 )
  region$ClosestGenes=NA
  region$nClump=nClump
  cat(nrow(region),"variants found. ")

  cat("updating .. ")
  ff2 = ff2[ which(!(ff2$MarkerName %in% region$MarkerName)) ,]
  ff1s$nClump[which(ff1s$MarkerName %in% region$MarkerName)]=nClump
  rm(wwS)

  cat("annotating genes .. ")
  genes.region <- subset(genes, chr==chrS & start<=(posS+500000) & end>=(posS-500000) )
  ngenes <- nrow(genes.region)

  if(ngenes>0)
  {
   for(j in 1:ngenes)
   {
    if( posS<genes.region$start[j] )
    {
     genes.region$dist2snp[j] = genes.region$start[j]-posS
    } else { if( posS>genes.region$end[j] )
             {
              genes.region$dist2snp[j] = posS-genes.region$end[j]
             } else {
                     if( (posS>=genes.region$start[j]) & (posS<=genes.region$end[j]) ) {genes.region$dist2snp[j]=0}
                    }
           }
   } ; rm(j) #for j in 1:ngenes
   closestgenes <- subset( genes.region , dist2snp==min(genes.region$dist2snp))[,c("gene","dist2snp")]
   closestgenes = unique(closestgenes)
   closestgenesToWrite = paste(paste(closestgenes$gene,closestgenes$dist2snp,sep=":"),collapse=";")
   region$ClosestGenes[which(region$Signal==1)]=closestgenesToWrite
   ff1s$GeneForSignals[ which(ff1s$MarkerName==region$MarkerName[which(region$Signal==1)])] = closestgenesToWrite
   rm(closestgenes,closestgenesToWrite)
  } #if(ngenes>0)

  cat("binding .. ")
  ClumpSignals = rbind( ClumpSignals , region )
  rm(region,genes.region,ngenes,chrS,posS)

  cat("Save .. ")
  save(ClumpSignals,file=paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/Dist_Clump_500kb_",y,"_",z,".RData",sep=""))

  cat("Done.\n ")
 } #while >6
 rm(genes,ff2,ClumpSignals)
}

 summ = c( summ ,
           nClump=nClump)
rm(nClump)
save( summ , file=paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/summary_",y,"_",z,".RData",sep=""))



#-----------------------------------------------------------------------



for y in HbA1c; do for z in InvNorm Raw; do bsub -q long -G t35_magic -o /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/bsub.$y.$z.out -e /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/bsub.$y.$z.err -R"select[mem>40000]  rusage[mem=40000]"  -M40000  "/software/R-3.0.0/bin/R --no-save --args $y $z 1 < /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/MANTRA_Interpretation.R"; done; done
for y in HbA1c; do for z in InvNorm; do bsub -q normal -G t35_magic -o /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/bsub2.$y.$z.out -e /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/bsub2.$y.$z.err -R"select[mem>40000]  rusage[mem=40000]"  -M40000  "/software/R-3.0.0/bin/R --no-save --args $y $z 1 < /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/MANTRA_Interpretation_2.R"; done; done


for y in FG; do for z in InvNorm; do bsub -q hugemem -G t35_magic -o /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/bsub.$y.$z.out -e /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/bsub.$y.$z.err -R"select[mem>50000]  rusage[mem=50000]"  -M50000  "/software/R-3.0.0/bin/R --no-save < /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/MANTRA_Interpretation_FG_InvNorm.R"; done; done
for y in FGluadjBMI; do for z in InvNorm; do bsub -q normal -G t35_magic -o /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/bsub2.$y.$z.out -e /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/bsub2.$y.$z.err -R"select[mem>40000]  rusage[mem=40000]"  -M40000  "/software/R-3.0.0/bin/R --no-save --args $y $z 1 < /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/MANTRA_Interpretation_2.R"; done; done


for y in FInsadjBMI 2hrGluadjBMI; do for z in InvNorm Raw; do bsub -q long -G t35_magic -o /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/bsub.$y.$z.out -e /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/bsub.$y.$z.err -R"select[mem>50000]  rusage[mem=50000]"  -M50000  "/software/R-3.0.0/bin/R --no-save --args $y $z 1 < /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/MANTRA_Interpretation_3.R"; done; done



ls -lh /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_ResFromVolunteers/mantra_FGluadjBMI_InvNorm_JH.out.gz
ls -lh /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FInsadjBMI_InvNorm/mantra.FInsadjBMI.InvNorm.GM.out.gz
ls -lh /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_2hrGluadjBMI_InvNorm/mantra.2hrGluadjBMI.InvNorm.GM.out.gz
ls -lh /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_InvNorm/mantra.HbA1c.InvNorm.GM.out.gz


#######################################################
#####  Clumping
#######################################################

load("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/Dist_Clump_500kb_HbA1c_InvNorm.RData")
load("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/summary_HbA1c_InvNorm.RData")
load("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/Start_End_Markers_HbA1c_InvNorm.RData")
known = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/KnownLoci_HbA1c_InvNorm.txt",h=T,as.is=T,sep="\t")

table(ClumpSignals$nClump,ClumpSignals$Log10BF_MANTRA>=6)

table(ClumpSignals$nClump,ClumpSignals$Known)

table(ClumpSignals$Signal,ClumpSignals$Known)


ClumpSignals[which(ClumpSignals$Sample_Size==0),]
mSS_A = max(ClumpSignals$Sample_Size)
mSS_X = max(ClumpSignals$Sample_Size[which(ClumpSignals$Chr==23)])

#--------
cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016
zcat METAL_ResFromVolunteers/Ying/METAANALYSIS_1_EAA_HbA1c_InvNorm.tbl.gz | grep X:152771449:SNP
zcat METAL_ResFromVolunteers/Ying/METAANALYSIS_1_EAA_HbA1c_InvNorm.tbl.gz | grep X:152838835:SNP
zcat METAL_ResFromVolunteers/Ying/METAANALYSIS_1_EAA_HbA1c_InvNorm.tbl.gz | grep X:152844173:SNP
zcat METAL_ResFromVolunteers/Ying/METAANALYSIS_1_EAA_HbA1c_InvNorm.tbl.gz | grep X:151606960:SNP
zcat METAL_ResFromVolunteers/Ying/METAANALYSIS_1_EAA_HbA1c_InvNorm.tbl.gz | grep X:151797578:SNP
zcat METAL_ResFromVolunteers/Ying/METAANALYSIS_1_EAA_HbA1c_InvNorm.tbl.gz | grep X:151992404:SNP
zcat METAL_ResFromVolunteers/Ying/METAANALYSIS_1_EAA_HbA1c_InvNorm.tbl.gz | grep X:152002655:SNP
zcat METAL_ResFromVolunteers/Ying/METAANALYSIS_1_EAA_HbA1c_InvNorm.tbl.gz | grep X:152091531:SNP
zcat METAL_ResFromVolunteers/Ying/METAANALYSIS_1_EAA_HbA1c_InvNorm.tbl.gz | grep X:152104664:SNP
cat METAL_ResFromVolunteers/Ying/METAANALYSIS_1_EAA_HbA1c_InvNorm.tbl.info
# --> Input File 16 : ../input/EAA_GWAS_AX_HbA1c_InvNorm_KARE_MACH2QTL_31102014_YJK.txt.gz
cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/
zcat  FilesForMA_feb2016_WithoutTRIALLELIC/files_uploaded/EAA_GWAS_AX_HbA1c_InvNorm_KARE_MACH2QTL_31102014_YJK.txt.gz | head
zcat  FilesForMA_feb2016_WithoutTRIALLELIC/files_uploaded/EAA_GWAS_AX_HbA1c_InvNorm_KARE_MACH2QTL_31102014_YJK.txt.gz | grep X:152771449:SNP
zcat  FilesForMA_feb2016_WithoutTRIALLELIC/files_uploaded/EAA_GWAS_AX_HbA1c_InvNorm_KARE_MACH2QTL_31102014_YJK.txt.gz | grep X:152838835:SNP
zcat  FilesForMA_feb2016_WithoutTRIALLELIC/files_uploaded/EAA_GWAS_AX_HbA1c_InvNorm_KARE_MACH2QTL_31102014_YJK.txt.gz | grep X:152844173:SNP
zcat  FilesForMA_feb2016_WithoutTRIALLELIC/files_uploaded/EAA_GWAS_AX_HbA1c_InvNorm_KARE_MACH2QTL_31102014_YJK.txt.gz | grep X:151606960:SNP
zcat  FilesForMA_feb2016_WithoutTRIALLELIC/files_uploaded/EAA_GWAS_AX_HbA1c_InvNorm_KARE_MACH2QTL_31102014_YJK.txt.gz | grep X:151797578:SNP
zcat  FilesForMA_feb2016_WithoutTRIALLELIC/files_uploaded/EAA_GWAS_AX_HbA1c_InvNorm_KARE_MACH2QTL_31102014_YJK.txt.gz | grep X:151992404:SNP
zcat  FilesForMA_feb2016_WithoutTRIALLELIC/files_uploaded/EAA_GWAS_AX_HbA1c_InvNorm_KARE_MACH2QTL_31102014_YJK.txt.gz | grep X:152002655:SNP
zcat  FilesForMA_feb2016_WithoutTRIALLELIC/files_uploaded/EAA_GWAS_AX_HbA1c_InvNorm_KARE_MACH2QTL_31102014_YJK.txt.gz | grep X:152091531:SNP
zcat  FilesForMA_feb2016_WithoutTRIALLELIC/files_uploaded/EAA_GWAS_AX_HbA1c_InvNorm_KARE_MACH2QTL_31102014_YJK.txt.gz | grep X:152104664:SNP

#--------




ClumpSignals$FlagRare = ifelse( ClumpSignals$Effect_Allele_Freq<0.01 | ClumpSignals$Effect_Allele_Freq>0.99 , yes=1 , no=0 )
ClumpSignals$FlagSmallSampleSize = ifelse( ClumpSignals$Chr==23 , yes=ifelse(ClumpSignals$Sample_Size<(mSS_X/3),yes=1,no=0) , no=ifelse(ClumpSignals$Sample_Size<(mSS_A/3),yes=1,no=0) )

table(ClumpSignals$FlagRare)
table(ClumpSignals$FlagSmallSampleSize)
table(ClumpSignals$FlagRare,ClumpSignals$FlagSmallSampleSize)


table(ClumpSignals$nClump,ClumpSignals$FlagRare)
table(ClumpSignals$nClump,ClumpSignals$FlagSmallSampleSize)


ClumpSignals.s = ClumpSignals[order(ClumpSignals$Chr,ClumpSignals$Pos),]
rm(ClumpSignals)
dim(ClumpSignals.s)
head(ClumpSignals.s)
tail(ClumpSignals.s)

ClumpSignals.s = ClumpSignals.s[which(ClumpSignals.s$Sample_Size>0),]


summaryReg = NULL
curr_reg=0 ; p=0
for ( i in 1:nrow(ClumpSignals.s) )
{
 if( i/nrow(ClumpSignals.s)>(p/100) ) {cat(p,"% .. ",sep="") ; p=p+1 }
 if (ClumpSignals.s$nClump[i]!=curr_reg) # start new reg
 {
  if( curr_reg!=0 ) { summaryReg=rbind(summaryReg,tp) ; rm(tp) } # save previous region summary
  curr_reg=ClumpSignals.s$nClump[i]                                # update current region number
  tp=c(  reg=ClumpSignals.s$nClump[i]                              # start new region summary
       , chr=ClumpSignals.s$Chr[i]
       , start_pos=ClumpSignals.s$Pos[i]
       , last_pos=ClumpSignals.s$Pos[i]
       , topsignal_pos=NA
       , topsignal_logBF=NA
       , topsignal_known=NA
       , topsignal_ClosestGene=NA
       , topsignal_direction=NA
       , topsignal_Flag=NA
       , nSignal=0
       , nKnown_variant=0
       , nKnown_region=0
       , nKnown_variant_signal=0
       , nFlagRare=0
       , nFlagSmallSampleSize=0
       , nFlagRare_SmallSampleSize=0
      )
 }
 tp["last_pos"]=ClumpSignals.s$Pos[i] # always update last position
 if (ClumpSignals.s$Signal[i]==1) { tp["topsignal_pos"]=ClumpSignals.s$Pos[i]
                                    tp["topsignal_logBF"]=ClumpSignals.s$Log10BF_MANTRA[i]
                                    tp["topsignal_known"]=ClumpSignals.s$Known[i]
                                    tp["topsignal_ClosestGene"]=ClumpSignals.s$ClosestGenes[i]
                                    tp["topsignal_direction"]=ClumpSignals.s$Direction[i]
                                    tp["topsignal_Flag"]=ifelse(ClumpSignals.s$FlagRare[i]==1 & ClumpSignals.s$FlagSmallSampleSize[i]==1 , yes="Rare;Small_N" , no=ifelse(ClumpSignals.s$FlagRare[i]==1,yes="Rare",no=ifelse(ClumpSignals.s$FlagSmallSampleSize[i]==1,yes="Small_N",no="")))
                                  }                                              # update top signal position & logBF if signal
 if (ClumpSignals.s$Log10BF_MANTRA[i]>6) { tp["nSignal"]=as.numeric(tp["nSignal"])+1 }       # update number of signals
 if (ClumpSignals.s$Known[i]==1) { tp["nKnown_variant"]=as.numeric(tp["nKnown_variant"])+1 } # update number of known variants
 if (ClumpSignals.s$Known[i]>0 ) { tp["nKnown_region"]=as.numeric(tp["nKnown_region"])+1 }   # update number of variants around known variants
 if (ClumpSignals.s$Known[i]==1 & ClumpSignals.s$Log10BF_MANTRA[i]>6) { tp["nKnown_variant_signal"]=as.numeric(tp["nKnown_variant_signal"])+1 } # update number of known variants
 if (ClumpSignals.s$FlagRare[i]==1 ) { tp["nFlagRare"]=as.numeric(tp["nFlagRare"])+1 }   # update number
 if (ClumpSignals.s$FlagSmallSampleSize[i]==1 ) { tp["nFlagSmallSampleSize"]=as.numeric(tp["nFlagSmallSampleSize"])+1 }   # update number
 if (ClumpSignals.s$FlagRare[i]==1 & ClumpSignals.s$FlagSmallSampleSize[i]==1) { tp["nFlagRare_SmallSampleSize"]=as.numeric(tp["nFlagRare_SmallSampleSize"])+1 }   # update number

} ; rm(i,curr_reg,p) ; summaryReg=rbind(summaryReg,tp) ; rm(tp) ; cat("100%\n")


summaryReg = data.frame(summaryReg,stringsAsFactors=F)
for ( i in c(1:7,11:17) ) { summaryReg[,i]=as.numeric(summaryReg[,i]) } ; rm(i)

summaryReg$kb_down = summaryReg$topsignal_pos-summaryReg$start_pos
summaryReg$kb_up   = summaryReg$last_pos-summaryReg$topsignal_pos
summaryReg$Dist_from_previous = NA

for ( i in 2:nrow(summaryReg) )
{
 if( summaryReg$chr[i]==summaryReg$chr[i-1] ) {summaryReg$Dist_from_previous[i]=summaryReg$start_pos[i]-summaryReg$last_pos[i-1]}
} ; rm(i)


table(summaryReg$nKnown_variant==0 & summaryReg$nKnown_region==0)



load("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/Start_End_Markers_HbA1c_InvNorm.RData")

table( summaryReg$reg == start_end_markers[,1] )
summaryReg$NinbetweenPREV = start_end_markers[,3]


summaryReg$regConcat = NA ; reg_TP=NULL ; topsignal_logBF_TP=NULL
for ( i in nrow(summaryReg):1 )
{
 if( summaryReg$NinbetweenPREV[i]==0 & !is.na(summaryReg$NinbetweenPREV[i]) )
 {
  reg_TP = c(reg_TP,summaryReg$reg[i])
  topsignal_logBF_TP = c(topsignal_logBF_TP,summaryReg$topsignal_logBF[i])
  if( summaryReg$NinbetweenPREV[i-1]>0 | is.na(summaryReg$NinbetweenPREV[i-1]) )
  {
   reg_TP = c(reg_TP,summaryReg$reg[i-1])
   topsignal_logBF_TP = c(topsignal_logBF_TP,summaryReg$topsignal_logBF[i-1])
   summaryReg$regConcat[which(summaryReg$reg %in% reg_TP)] = reg_TP[which(topsignal_logBF_TP==max(topsignal_logBF_TP))]
   reg_TP=NULL ; topsignal_logBF_TP=NULL
  }
 } else { if( is.na(summaryReg$regConcat[i]) ) {summaryReg$regConcat[i]=summaryReg$reg[i]} }
} ; rm(i)


save( summaryReg , file="/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/Dist_Clump_500kb_HbA1c_InvNorm_Summary.RData" )


summaryRegConcat = NULL
for ( i in unique(summaryReg$regConcat) )
{
 if( sum(summaryReg$regConcat==i)==1 )
 {
  summaryRegConcat = rbind( summaryRegConcat , summaryReg[which(summaryReg$regConcat==i),-which(colnames(summaryReg) %in% c("reg","kb_down","kb_up","Dist_from_previous","NinbetweenPREV"))] )
 } else {
         tp = summaryReg[which(summaryReg$regConcat==i),-which(colnames(summaryReg) %in% c("reg","kb_down","kb_up","Dist_from_previous","NinbetweenPREV"))]
         tp$start_pos = min(tp$start_pos)
         tp$last_pos = max(tp$last_pos)
         wwTOP = which(tp$topsignal_logBF==max(tp$topsignal_logBF))
         tp$topsignal_pos         = tp$topsignal_pos[wwTOP]
         tp$topsignal_logBF       = tp$topsignal_logBF[wwTOP]
         tp$topsignal_known       = tp$topsignal_known[wwTOP]
         tp$topsignal_ClosestGene = tp$topsignal_ClosestGene[wwTOP]
         tp$topsignal_direction   = tp$topsignal_direction[wwTOP]
         tp$topsignal_Flag        = tp$topsignal_Flag[wwTOP]
         rm(wwTOP)
         tp$nSignal = sum(tp$nSignal)
         tp$nKnown_variant = sum(tp$nKnown_variant)
         tp$nKnown_region = sum(tp$nKnown_region)
         tp$nKnown_variant_signal = sum(tp$nKnown_variant_signal)
         tp$nFlagRare = sum(tp$nFlagRare)
         tp$nFlagSmallSampleSize = sum(tp$nFlagSmallSampleSize)
         tp$nFlagRare_SmallSampleSize = sum(tp$nFlagRare_SmallSampleSize)
         summaryRegConcat = rbind( summaryRegConcat , unique(tp) )
        }

} ; rm(i)


save( summaryRegConcat , file="/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/Dist_Clump_500kb_HbA1c_InvNorm_SummaryConcat.RData" )



load("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/Dist_Clump_500kb_HbA1c_InvNorm.RData") #ClumpSignals
ClumpSignals$MarkerName = sub("X:","23:",ClumpSignals$MarkerName)

load( "/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/Dist_Clump_500kb_HbA1c_InvNorm_Summary.RData" ) #summaryReg


ClumpSignals$regConcat=ClumpSignals$nClump
ClumpSignals$SignalConcat=ClumpSignals$Signal
table(ClumpSignals$regConcat==ClumpSignals$nClump)
for ( rr in summaryReg$reg[which(summaryReg$reg!=summaryReg$regConcat)] )
{
 ClumpSignals$regConcat[which(ClumpSignals$nClump==rr)] = summaryReg$regConcat[which(summaryReg$reg==rr)]
 ClumpSignals$SignalConcat[which(ClumpSignals$nClump==rr)] = 0
} ; rm(rr)

table(ClumpSignals$regConcat==ClumpSignals$nClump)

save(ClumpSignals , file="/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/Dist_Clump_500kb_HbA1c_InvNorm_Concat.RData") #ClumpSignals



# Plot regions


rr = which(ClumpSignals$nClump==46 & ClumpSignals$Pos>45100000 & ClumpSignals$Pos<45300000) ; plot( ClumpSignals$Pos[rr] , ClumpSignals$Log10BF_MANTRA[rr] , xlab="Position on chr 2" , ylab="Log10BF from MANTRA",type="l") ; abline(h=6,col="green4")

system("zcat /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_reformatForGCTA/metal.HbA1c.InvNorm.AA.ma.gz  | grep 2:45 | bgzip -c > /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/PLOTS/TEMP_46_AA.txt.gz")
system("zcat /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_reformatForGCTA/metal.HbA1c.InvNorm.EA.ma.gz  | grep 2:45 | bgzip -c > /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/PLOTS/TEMP_46_EA.txt.gz")
system("zcat /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_reformatForGCTA/metal.HbA1c.InvNorm.EAA.ma.gz | grep 2:45 | bgzip -c > /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/PLOTS/TEMP_46_EAA.txt.gz")
system("zcat /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_reformatForGCTA/metal.HbA1c.InvNorm.IAA.ma.gz | grep 2:45 | bgzip -c > /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/PLOTS/TEMP_46_IAA.txt.gz")
system("zcat /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_reformatForGCTA/metal.HbA1c.InvNorm.HA.ma.gz  | grep 2:45 | bgzip -c > /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/PLOTS/TEMP_46_HA.txt.gz")
system("zcat /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_reformatForGCTA/metal.HbA1c.InvNorm.UAA.ma.gz | grep 2:45 | bgzip -c > /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/PLOTS/TEMP_46_UAA.txt.gz")

for ( a in c("AA","EA","EAA","IAA","HA","UAA") )
{
 cat(a,".. ")
 tp = read.table(gzfile(paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/PLOTS/TEMP_46_",a,".txt.gz",sep="")),as.is=T,col.names=c("MarkerName","ALLELE1","ALLELE2","Freq1","Effect","StdErr","P-value","TotalSampleSize"))
 tp2 = sapply( tp$MarkerName , FUN=function(x){x1=strsplit(x,":")[[1]] ; return(c(chr=x1[1],pos=x1[2])) } )
 tp$CHR= tp2["chr",]
 tp$POS= as.numeric(tp2["pos",])
 tp = tp[ which(tp$CHR==2 & tp$POS>45100000 & tp$POS<45300000) , ]
 tp = tp[order(tp$POS),]
 assign( paste("temp_46_",a,sep="") , tp )
 rm(tp,tp2)
} ; rm(a) ; cat("Done.\n")


rr = which(ClumpSignals$nClump==46 & ClumpSignals$Pos>45100000 & ClumpSignals$Pos<45300000)
plot( ClumpSignals$Pos[rr] , ClumpSignals$Log10BF_MANTRA[rr] , xlab="Position on chr 2" , ylab="Log10BF from MANTRA" , col="grey" , xlim=c(45170000,45210000))
abline(h=6,col="grey")
abline(h=-log10(5e-8),col="black")
points( temp_46_AA$POS  , -log10(temp_46_AA$P.value)  , col="red" )
points( temp_46_EAA$POS , -log10(temp_46_EAA$P.value) , col="yellow" )
points( temp_46_IAA$POS , -log10(temp_46_IAA$P.value) , col="green" )
points( temp_46_HA$POS  , -log10(temp_46_HA$P.value)  , col="purple" )
points( temp_46_UAA$POS , -log10(temp_46_UAA$P.value) , col="orange" )
points( temp_46_EA$POS  , -log10(temp_46_EA$P.value)  , col="blue" )




## effect vs freq for new and known signals (new signals from Invnorm but effect from raw!!)

load("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/Dist_Clump_500kb_HbA1c_InvNorm_Concat.RData") #ClumpSignals
signals = ClumpSignals.s[which(ClumpSignals.s$Signal==1),]
rm(ClumpSignals.s) ; gc()



######################
# Other traits
######################


known_h=read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/ReferenceFiles/known_SNPs_B37_HbA1c.txt",as.is=T,h=T,sep="\t")
known_h$MarkerName = paste( ifelse(known_h$CHR==23,yes="X",no=known_h$CHR) ,known_h$POS_37,"SNP",sep=":")

known_a=read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/ReferenceFiles/known_SNPs_B37_OtherTraits.txt",as.is=T,h=T,sep="\t")
known_a$MarkerName = paste(known_a$chr,known_a$pos,"SNP",sep=":")

known_all = rbind( data.frame(phenotype="hb",chr=known_h$CHR,pos=known_h$POS_37,MarkerName=known_h$MarkerName,stringsAsFactors=F) , known_a[,c("phenotype","chr","pos","MarkerName")] )
rm(known_a,known_h)

dd = known_all[which(known_all$MarkerName %in% known_all$MarkerName[which(duplicated(known_all$MarkerName))]),]
dd[order(dd$chr,dd$pos),]

for ( x in c("FInsadjBMI","2hrGluadjBMI","FGluadjBMI") )  #"HbA1c",
{
 cat("---->",x,"\n  Load clumping results ..\n")
 load(paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/Dist_Clump_500kb_",x,"_InvNorm.RData",sep=""))

 cat("  Re-do known regions .. ")
 known_here = known_all
 if (x=="HbA1c"       ) { known_here$trait=ifelse( known_here$phenotype=="hb"             , yes=1 , no=0 ) }
 if (x=="FInsadjBMI"  ) { known_here$trait=ifelse( substr(known_here$phenotype,1,2)=="fi" , yes=1 , no=0 ) }
 if (x=="2hrGluadjBMI") { known_here$trait=ifelse( known_here$phenotype=="2hglu"          , yes=1 , no=0 ) }
 if (x=="FGluadjBMI"  ) { known_here$trait=ifelse( known_here$phenotype=="fg"             , yes=1 , no=0 ) }
 ClumpSignals$Known_this_trait = 0
 ClumpSignals$Known_any_trait  = 0
 cat("(",nrow(known_here),") .. ",sep="")
 for ( i in 1:nrow(known_here) )
 {
  if (i%%10==0) { cat(i,".. ") }
  ww = which( ClumpSignals$Chr==known_here$chr[i] & ClumpSignals$Pos>=known_here$pos[i]-500000 & ClumpSignals$Pos<=known_here$pos[i]+500000 )
  if ( length(ww)>0 )
  {
    ClumpSignals$Known_any_trait[ ww ]=2
    if( known_here$trait[i]==1 ) { ClumpSignals$Known_this_trait[ ww ]=2 }
  } ; rm(ww)
  if ( sum( ClumpSignals$Chr==known_here$chr[i] & ClumpSignals$Pos==known_here$pos[i] & ClumpSignals$MarkerName!=known_here$MarkerName[i] )>0 )
  {
   cat( known_here$MarkerName[i] , "not there but chr:pos is .. " )
  }
 } ; rm(i) ; cat("Flagging known signals .. ")
 ClumpSignals$Known_this_trait[ which( ClumpSignals$MarkerName %in% known_here$MarkerName[which(known_here$trait==1)] ) ] = 1
 ClumpSignals$Known_any_trait[ which( ClumpSignals$MarkerName %in% known_here$MarkerName ) ] = 1
 rm(known_here)
 cat("Done.\n")

 mSS_A = max(ClumpSignals$Sample_Size)
 mSS_X = max(ClumpSignals$Sample_Size[which(ClumpSignals$Chr==23)])
 ClumpSignals$FlagRare = ifelse( ClumpSignals$Effect_Allele_Freq<0.01 | ClumpSignals$Effect_Allele_Freq>0.99 , yes=1 , no=0 )
 ClumpSignals$FlagSmallSampleSize = ifelse( ClumpSignals$Chr==23 , yes=ifelse(ClumpSignals$Sample_Size<(mSS_X/3),yes=1,no=0) , no=ifelse(ClumpSignals$Sample_Size<(mSS_A/3),yes=1,no=0) )
 ClumpSignals.s = ClumpSignals[order(ClumpSignals$Chr,ClumpSignals$Pos),]
 rm(ClumpSignals,mSS_A,mSS_X)
 ClumpSignals.s = ClumpSignals.s[which(ClumpSignals.s$Sample_Size>0),]

 cat("  Summarise clumping regions .. ")
 summaryReg = NULL
 curr_reg=0 ; p=0
 for ( i in 1:nrow(ClumpSignals.s) )
 {
  if( i/nrow(ClumpSignals.s)>(p/100) ) { if(p%%5==0) {cat(p,"% .. ",sep="") } ; p=p+1 }
  if (ClumpSignals.s$nClump[i]!=curr_reg) # start new reg
  {
   if( curr_reg!=0 ) { summaryReg=rbind(summaryReg,tp) ; rm(tp) } # save previous region summary
   curr_reg=ClumpSignals.s$nClump[i]                                # update current region number
   tp=c(  reg=ClumpSignals.s$nClump[i]                              # start new region summary
        , chr=ClumpSignals.s$Chr[i]
        , start_pos=ClumpSignals.s$Pos[i]
        , last_pos=ClumpSignals.s$Pos[i]
        , topsignal_pos=NA
        , topsignal_logBF=NA
        , topsignal_known_this_trait=NA
        , topsignal_known_any_trait=NA
        , topsignal_ClosestGene=NA
        , topsignal_direction=NA
        , topsignal_Flag=NA
        , nSignal=0
        , nKnown_variant_this_trait=0
        , nKnown_region_this_trait=0
        , nKnown_variant_signal_this_trait=0
        , nKnown_variant_any_trait=0
        , nKnown_region_any_trait=0
        , nKnown_variant_signal_any_trait=0
        , nFlagRare=0
        , nFlagSmallSampleSize=0
        , nFlagRare_SmallSampleSize=0
       )
  }
  tp["last_pos"]=ClumpSignals.s$Pos[i] # always update last position
  if (ClumpSignals.s$Signal[i]==1) { tp["topsignal_pos"]=ClumpSignals.s$Pos[i]
                                     tp["topsignal_logBF"]=ClumpSignals.s$Log10BF_MANTRA[i]
                                     tp["topsignal_known_this_trait"]=ClumpSignals.s$Known_this_trait[i]
                                     tp["topsignal_known_any_trait"]=ClumpSignals.s$Known_any_trait[i]
                                     tp["topsignal_ClosestGene"]=ClumpSignals.s$ClosestGenes[i]
                                     tp["topsignal_direction"]=ClumpSignals.s$Direction[i]
                                     tp["topsignal_Flag"]=ifelse(ClumpSignals.s$FlagRare[i]==1 & ClumpSignals.s$FlagSmallSampleSize[i]==1 , yes="Rare;Small_N" , no=ifelse(ClumpSignals.s$FlagRare[i]==1,yes="Rare",no=ifelse(ClumpSignals.s$FlagSmallSampleSize[i]==1,yes="Small_N",no="")))
                                  }                                              # update top signal position & logBF if signal
  if (ClumpSignals.s$Log10BF_MANTRA[i]>6) { tp["nSignal"]=as.numeric(tp["nSignal"])+1 }       # update number of signals
  if (ClumpSignals.s$Known_this_trait[i]==1) { tp["nKnown_variant_this_trait"]=as.numeric(tp["nKnown_variant_this_trait"])+1 } # update number of known variants
  if (ClumpSignals.s$Known_this_trait[i]>0 ) { tp["nKnown_region_this_trait"]=as.numeric(tp["nKnown_region_this_trait"])+1 }   # update number of variants around known variants
  if (ClumpSignals.s$Known_this_trait[i]==1 & ClumpSignals.s$Log10BF_MANTRA[i]>6) { tp["nKnown_variant_signal_this_trait"]=as.numeric(tp["nKnown_variant_signal_this_trait"])+1 } # update number of known variants
  if (ClumpSignals.s$Known_any_trait[i]==1) { tp["nKnown_variant_any_trait"]=as.numeric(tp["nKnown_variant_any_trait"])+1 } # update number of known variants
  if (ClumpSignals.s$Known_any_trait[i]>0 ) { tp["nKnown_region_any_trait"]=as.numeric(tp["nKnown_region_any_trait"])+1 }   # update number of variants around known variants
  if (ClumpSignals.s$Known_any_trait[i]==1 & ClumpSignals.s$Log10BF_MANTRA[i]>6) { tp["nKnown_variant_signal_any_trait"]=as.numeric(tp["nKnown_variant_signal_any_trait"])+1 } # update number of known variants
  if (ClumpSignals.s$FlagRare[i]==1 ) { tp["nFlagRare"]=as.numeric(tp["nFlagRare"])+1 }   # update number
  if (ClumpSignals.s$FlagSmallSampleSize[i]==1 ) { tp["nFlagSmallSampleSize"]=as.numeric(tp["nFlagSmallSampleSize"])+1 }   # update number
  if (ClumpSignals.s$FlagRare[i]==1 & ClumpSignals.s$FlagSmallSampleSize[i]==1) { tp["nFlagRare_SmallSampleSize"]=as.numeric(tp["nFlagRare_SmallSampleSize"])+1 }   # update number
 } ; rm(i,curr_reg,p) ; summaryReg=rbind(summaryReg,tp) ; rm(tp) ; cat("100%\n")
 summaryReg = data.frame(summaryReg,stringsAsFactors=F)
 for ( i in c(1:8,12:21) ) { summaryReg[,i]=as.numeric(summaryReg[,i]) } ; rm(i)

 cat("  Fusion consecutive clumping regions .. ")
 load(paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/Start_End_Markers_",x,"_InvNorm.RData",sep=""))
 if( sum( summaryReg$reg != start_end_markers[,1] )==0 )
 {
   summaryReg$NinbetweenPREV = start_end_markers[,3]
   summaryReg$regConcat = NA ; reg_TP=NULL ; topsignal_logBF_TP=NULL
   for ( i in nrow(summaryReg):1 )
   {
    if( summaryReg$NinbetweenPREV[i]==0 & !is.na(summaryReg$NinbetweenPREV[i]) )
    {
     reg_TP = c(reg_TP,summaryReg$reg[i])
     topsignal_logBF_TP = c(topsignal_logBF_TP,summaryReg$topsignal_logBF[i])
     if( summaryReg$NinbetweenPREV[i-1]>0 | is.na(summaryReg$NinbetweenPREV[i-1]) )
     {
      reg_TP = c(reg_TP,summaryReg$reg[i-1])
      topsignal_logBF_TP = c(topsignal_logBF_TP,summaryReg$topsignal_logBF[i-1])
      summaryReg$regConcat[which(summaryReg$reg %in% reg_TP)] = reg_TP[which(topsignal_logBF_TP==max(topsignal_logBF_TP))]
      reg_TP=NULL ; topsignal_logBF_TP=NULL
     }
    } else { if( is.na(summaryReg$regConcat[i]) ) {summaryReg$regConcat[i]=summaryReg$reg[i]} }
   } ; rm(i,reg_TP,topsignal_logBF_TP,start_end_markers)
   save( summaryReg , file=paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/Dist_Clump_500kb_",x,"_InvNorm_Summary.RData",sep=""))
   cat("Done.\n")

   cat("  Update the summary .. ")
   summaryRegConcat = NULL
   for ( i in unique(summaryReg$regConcat) )
   {
    if( sum(summaryReg$regConcat==i)==1 )
    {
     summaryRegConcat = rbind( summaryRegConcat , summaryReg[which(summaryReg$regConcat==i),-which(colnames(summaryReg) %in% c("reg","NinbetweenPREV"))] )
    } else {
            tp = summaryReg[which(summaryReg$regConcat==i),-which(colnames(summaryReg) %in% c("reg","NinbetweenPREV"))]
            tp$start_pos = min(tp$start_pos)
            tp$last_pos = max(tp$last_pos)
            wwTOP = which(tp$topsignal_logBF==max(tp$topsignal_logBF))
            tp$topsignal_pos         = tp$topsignal_pos[wwTOP]
            tp$topsignal_logBF       = tp$topsignal_logBF[wwTOP]
            tp$topsignal_known_this_trait = tp$topsignal_known_this_trait[wwTOP]
            tp$topsignal_known_any_trait  = tp$topsignal_known_any_trait[wwTOP]
            tp$topsignal_ClosestGene = tp$topsignal_ClosestGene[wwTOP]
            tp$topsignal_direction   = tp$topsignal_direction[wwTOP]
            tp$topsignal_Flag        = tp$topsignal_Flag[wwTOP]
            rm(wwTOP)
            tp$nSignal = sum(tp$nSignal)
            tp$nKnown_variant_this_trait = sum(tp$nKnown_variant_this_trait)
            tp$nKnown_region_this_trait = sum(tp$nKnown_region_this_trait)
            tp$nKnown_variant_signal_this_trait = sum(tp$nKnown_variant_signal_this_trait)
            tp$nKnown_variant_any_trait = sum(tp$nKnown_variant_any_trait)
            tp$nKnown_region_any_trait = sum(tp$nKnown_region_any_trait)
            tp$nKnown_variant_signal_any_trait = sum(tp$nKnown_variant_signal_any_trait)
            tp$nFlagRare = sum(tp$nFlagRare)
            tp$nFlagSmallSampleSize = sum(tp$nFlagSmallSampleSize)
            tp$nFlagRare_SmallSampleSize = sum(tp$nFlagRare_SmallSampleSize)
            summaryRegConcat = rbind( summaryRegConcat , unique(tp) )
            rm(tp)
           }

   } ; rm(i)
   save( summaryRegConcat , file=paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/Dist_Clump_500kb_",x,"_InvNorm_SummaryConcat.RData",sep="") )
   cat("Done.\n")

   cat("  Update clumping results .. ")
   ClumpSignals.s$MarkerName = sub("X:","23:",ClumpSignals.s$MarkerName)
   ClumpSignals.s$regConcat=ClumpSignals.s$nClump
   ClumpSignals.s$SignalConcat=ClumpSignals.s$Signal
   for ( rr in summaryReg$reg[which(summaryReg$reg!=summaryReg$regConcat)] )
   {
    ClumpSignals.s$regConcat[which(ClumpSignals.s$nClump==rr)] = summaryReg$regConcat[which(summaryReg$reg==rr)]
    ClumpSignals.s$SignalConcat[which(ClumpSignals.s$nClump==rr)] = 0
   } ; rm(rr)
   save(ClumpSignals.s , file=paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/Dist_Clump_500kb_",x,"_InvNorm_Concat.RData",sep=""))
   cat("Done.\n")

 } else { cat("Impossible, the regions are not in the same order.\n") }

 rm(ClumpSignals.s,summaryReg,summaryRegConcat) ; gc()

} ; rm(x)



x =  "FGluadjBMI"#  "HbA1c"  #    "2hrGluadjBMI" #  "FInsadjBMI"#

load(paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/Dist_Clump_500kb_",x,"_InvNorm_SummaryConcat.RData",sep=""))
summaryRegConcat=summaryRegConcat[order(summaryRegConcat$topsignal_logBF,decreasing=T),]
dim(summaryRegConcat)
table(summaryRegConcat$nKnown_region_this_trait==0)
table(summaryRegConcat$nKnown_region_this_trait==0 , grepl("Rare",summaryRegConcat$topsignal_Flag) )
table(summaryRegConcat$nKnown_region_any_trait==0)
head(summaryRegConcat[ which(summaryRegConcat$nSignal>3 & summaryRegConcat$nKnown_region_any_trait==0) ,c(5:11,13,16)])


load(paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/Dist_Clump_500kb_",x,"_InvNorm_Summary.RData",sep=""))
summaryReg=summaryReg[order(summaryReg$topsignal_logBF,decreasing=T),]
dim(summaryReg)
table(summaryReg$nKnown_region_this_trait==0)
table(summaryReg$nKnown_region_any_trait==0)
head(summaryReg[ which(summaryReg$nSignal>3 & summaryReg$nKnown_region_any_trait==0) ,c(2,5:12,14,17)])


for ( x in c("FGluadjBMI","HbA1c","2hrGluadjBMI","FInsadjBMI") )
{
 cat("---> ",x,"\n")
 load(paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/Dist_Clump_500kb_",x,"_InvNorm_SummaryConcat.RData",sep=""))
 print(table(grepl("Rare",summaryRegConcat$topsignal_Flag) , grepl("Small",summaryRegConcat$topsignal_Flag)))
 #cat("novel all trait\n")
 #print(table(summaryRegConcat$nKnown_region_any_trait==0))
 #cat("novel this trait\n")
 #print(table(summaryRegConcat$nKnown_region_this_trait==0))
 #cat("novel this trait * Rare\n")
 #print(table(summaryRegConcat$nKnown_region_this_trait==0 , grepl("Rare",summaryRegConcat$topsignal_Flag) ))
 cat("\n\n")
 rm(summaryRegConcat)
} ; rm(x)



zcat /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_ResFromVolunteers/mantra_FGluadjBMI_InvNorm_JH.out.gz | awk '{if ($1=="1:67390468:SNP" || $1=="3:141134818:SNP" || $1=="5:14751305:SNP" || $1=="6:43806609:SNP" || $1=="6:153431125:SNP" || $1=="7:89861832:SNP" || $1=="10:26505496:SNP" || $1=="10:95381773:SNP" || $1=="14:90066451:SNP" || $1=="X:19398315:SNP") {print $0}}'
zcat /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_ResFromVolunteers/mantra.FInsadjBMI.InvNorm.ALL.JH.out.gz | awk '{if ($1=="2:220421417:SNP" || $1=="12:48143315:SNP") {print $0}}'
zcat /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_InvNorm/mantra.HbA1c.InvNorm.GM.out.gz | awk '{if ($1=="5:75594743:SNP" || $1=="7:73012042:SNP" || $1=="9:34107505:SNP" || $1=="11:5248029:SNP" || $1=="11:9769562:SNP" || $1=="11:10508903:SNP" || $1=="11:118967758:SNP" || $1=="14:65263300:SNP" || $1=="15:66051345:SNP" || $1=="19:33167837:SNP" || $1=="16:30666367:SNP") {print $0}}'

zcat /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_HbA1c_InvNorm/mantra.HbA1c.InvNorm.GM.out.gz | awk '{if ($1=="11:4209250:SNP" || $1=="11:5248232:SNP") {print $0}}'



x =  "FInsadjBMI"#"FGluadjBMI"#  "HbA1c"  #    "2hrGluadjBMI" #

 load(paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/Dist_Clump_500kb_",x,"_InvNorm.RData",sep=""))




leo_fg = c("1:67390468:SNP","3:141134818:SNP","5:14751305:SNP","6:43806609:SNP","6:153431125:SNP",
           "7:89861832:SNP","10:26505496:SNP","10:95381773:SNP","14:90066451:SNP","X:19398315:SNP")
leo_fi = c("2:220421417:SNP","12:48143315:SNP")
leo_hb = c("5:75594743:SNP","7:73012042:SNP","9:34107505:SNP","11:5248029:SNP","11:9769562:SNP","11:10508903:SNP",
           "11:118967758:SNP","14:65263300:SNP","15:66051345:SNP","19:33167837:SNP","16:30666367:SNP")

table(leo_fi %in% ClumpSignals$MarkerName)
ClumpSignals[ which(ClumpSignals$MarkerName %in% leo_fi) , ]


###############################################################
### Data for circular plot for Sara
###############################################################
#  For all variants in MANTRA clumping
#   - results form METAL (p-value, direction of effect, whether the strongest in the MANTRA clump)
#   - results fom GCTA (whether a signal, GCTA p-value)


y = "HbA1c" #  "FGluadjBMI"  "HbA1c"     "2hrGluadjBMI"   "FInsadjBMI"

# MANTRA clump
for ( y in c("FGluadjBMI","2hrGluadjBMI","FInsadjBMI") )
{
 cat(y,".. ")
 load(paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/Dist_Clump_500kb_",y,"_InvNorm.RData",sep=""))
 write.table( ClumpSignals[,c("MarkerName","nClump")] , file=paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/CIRCULAR_PLOT_data/MarkerName_in_MANTRA_clump_",y,"_InvNorm.txt",sep="") , quote=F , row.names=F , col.names=F , sep="\t" )
 rm(ClumpSignals) ; gc()
} ; cat("Done\n") ; rm(y)

# METAL results for all the variant in MANTRA clump - to be run in bsub by trait & ancestry
z="InvNorm"

ancestries = c("AA","EA","HA","EAA")
if( y!="2hrGluadjBMI" ) { ancestries=c(ancestries,"IAA") }
if( y=="HbA1c"        ) { ancestries=c(ancestries,"UAA") }

varFile = paste("MarkerName_in_MANTRA_clump_",y,"_InvNorm.txt",sep="")

load("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/ListFiles.RData")

for ( x in ancestries )
{
 cat("--->",x,": ")

 ww2 = which(ListFiles$Ancestry==x & ListFiles$Trait==y & ListFiles$Transf==z & ListFiles$Run==2)
 if( length(ww2)>1){ ww2=ww2[1] }

 if( !is.na(ListFiles$Path1[ww2]) & !is.na(ListFiles$Path2[ww2]) )
 {
  set.seed(7787*ww2*ww2) ; PathVol = sample(c("Path1","Path2"),1)
 } else { if( !is.na(ListFiles$Path1[ww2]) ) {PathVol="Path1"} else {PathVol="Path2"} }

 cat("grep on METAL 2 .. ")
 command2 = paste("zcat ",ListFiles[ww2,PathVol]," | awk -F\"\t\" 'BEGIN {while ((getline < \"/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/CIRCULAR_PLOT_data/",varFile,"\") > 0) { a[$1]=$2 }} { if(NR==1) {print $1\"\t\"$2\"\t\"$3\"\t\"$6\"\t\"$7\"\t\"$9\"\tMANTRA_clump\"} ; if(a[$1]>0) {print $1\"\t\"$2\"\t\"$3\"\t\"$6\"\t\"$7\"\t\"$9\"\t\"a[$1]} }' | bgzip -c > /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/CIRCULAR_PLOT_data/METAL_",y,"_InvNorm_",x,".txt.gz" , sep="" )
 system(command2)
 rm(ww2,PathVol,command2)
 cat("Done.\n")
} ; rm(x,varFile,ancestries,ListFiles)

metal = read.table( gzfile(paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/CIRCULAR_PLOT_data/METAL_",y,"_InvNorm_",x,".txt.gz",sep="")) , h=T , as.is=T , sep="\t" )

LowestPbyMANTRAclump = by( metal[,c("MarkerName","P.value")] , INDICES=as.factor(metal$MANTRA_clump) , FUN=function(x){return(x[which.min(x[,"P.value"]),"MarkerName"])} )

metal$Lowest_P_in_MANTRA_clump = ifelse( metal$MarkerName %in% LowestPbyMANTRAclump , yes=1 , no=0 )

system(paste("rm /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/CIRCULAR_PLOT_data/METAL_",y,"_InvNorm_",x,".txt.gz",sep=""))
write.table( metal , file=paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/CIRCULAR_PLOT_data/METAL_",y,"_InvNorm_",x,".txt",sep="") , quote=F , row.names=F , sep="\t" )
system(paste("bgzip /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/CIRCULAR_PLOT_data/METAL_",y,"_InvNorm_",x,".txt",sep=""))




for x in EA AA HA EAA; do for y in HbA1c FGluadjBMI FInsadjBMI 2hrGluadjBMI ; do bsub -q normal -G t35_magic -P t35_magic -o /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/CIRCULAR_PLOT_data/bsub.$y.$x.out -e /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/CIRCULAR_PLOT_data/bsub.$y.$x.err -R"select[mem>5000]  rusage[mem=5000]"  -M5000  "/software/R-3.0.0/bin/R --no-save --args $x $y < /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/CIRCULAR_PLOT_data/Extract_MANTRA_clump_Markers_From_METAL_results.R"; done; done
for x in IAA; do for y in HbA1c FGluadjBMI FInsadjBMI                       ; do bsub -q normal -G t35_magic -P t35_magic -o /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/CIRCULAR_PLOT_data/bsub.$y.$x.out -e /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/CIRCULAR_PLOT_data/bsub.$y.$x.err -R"select[mem>5000]  rusage[mem=5000]"  -M5000  "/software/R-3.0.0/bin/R --no-save --args $x $y < /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/CIRCULAR_PLOT_data/Extract_MANTRA_clump_Markers_From_METAL_results.R"; done; done
for x in UAA; do for y in HbA1c                                             ; do bsub -q normal -G t35_magic -P t35_magic -o /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/CIRCULAR_PLOT_data/bsub.$y.$x.out -e /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/CIRCULAR_PLOT_data/bsub.$y.$x.err -R"select[mem>5000]  rusage[mem=5000]"  -M5000  "/software/R-3.0.0/bin/R --no-save --args $x $y < /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/CIRCULAR_PLOT_data/Extract_MANTRA_clump_Markers_From_METAL_results.R"; done; done



# load all needed on the sftp

put /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/CIRCULAR_PLOT_data/METAL_* /cleaned_gluinsrelatedtraits/Data_For_Circular_Plots/
put /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/Dist_Clump_500kb_*_InvNorm.RData /cleaned_gluinsrelatedtraits/Data_For_Circular_Plots/
put /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/GCTA/Results_2hrGluadjBMI_oneGCTA_plusMETALX_plusMANTRA_withResults_rsID_VEP_sorted.txt /cleaned_gluinsrelatedtraits/Data_For_Circular_Plots/
put /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/GCTA/Results_FGluadjBMI_oneGCTA_plusMETALX_plusMANTRA_withResults_rsID_VEP_sorted.txt /cleaned_gluinsrelatedtraits/Data_For_Circular_Plots/
put /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/GCTA/Results_FInsadjBMI_oneGCTA_plusMETALX_plusMANTRA_withResults_rsID_VEP_sorted.txt /cleaned_gluinsrelatedtraits/Data_For_Circular_Plots/
put /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/GCTA/Results_oneGCTA_plus_MANTRA_rsID_VEP_sorted.txt /cleaned_gluinsrelatedtraits/Data_For_Circular_Plots/

# VEP for MANTRA signals (already done, but redo anyway) and lowest p variants in each MANTRA clump for the ancestry=specific METAL results

vep0 = NULL
for ( y in c("FGluadjBMI","2hrGluadjBMI","FInsadjBMI","HbA1c") ) # 
{
 cat(y,": MANTRA signals .. ")
 load(paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_interpretation/Dist_Clump_500kb_",y,"_InvNorm.RData",sep=""))
 MANTRA = ClumpSignals[which(ClumpSignals$Signal==1),c("MarkerName","nClump")]
 rm(ClumpSignals) ; gc()

 METAL=NULL
 ancestries = c("AA","EA","HA","EAA")
 if( y!="2hrGluadjBMI" ) { ancestries=c(ancestries,"IAA") }
 if( y=="HbA1c"        ) { ancestries=c(ancestries,"UAA") }
 for ( x in ancestries)
 {
  cat(x,".. ")
  metal = read.table( gzfile(paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/CIRCULAR_PLOT_data/METAL_",y,"_InvNorm_",x,".txt.gz",sep="")) , as.is=T , h=T )
  metal2 = metal[which(metal$Lowest_P_in_MANTRA_clump==1 | metal$MarkerName %in% MANTRA$MarkerName),]
  metal2$Trait=y
  metal2$Ancestry=x
  metal2$For = ifelse(metal2$Lowest_P_in_MANTRA_clump==1 & metal2$MarkerName %in% MANTRA$MarkerName , yes=paste("MANTRA",x,sep=",") , no=ifelse(metal2$Lowest_P_in_MANTRA_clump==1,yes=x,no="MANTRA"))
  METAL = rbind( METAL , metal2[,c("MarkerName","Allele1","Allele2","Trait","MANTRA_clump","Ancestry","For")] )
  rm(metal,metal2) ; gc()
 } ; rm(x,ancestries)
 if ( sum(!(MANTRA$MarkerName %in% METAL$MarkerName))>0 ) { cat("WARNING: not all MANTRA signals in there!\n") } else { cat("All right!\n") }

 vep0 = rbind( vep0 , METAL )
 rm(MANTRA,METAL)
} ; rm(y)


dim(vep0)
head(vep0)

table(duplicated(vep0$MarkerName))

dd = unique(vep0$MarkerName[which(duplicated(vep0$MarkerName))])

table(vep0$For)


vep0$Marker_Trait = paste(vep0$MarkerName,vep0$Trait,sep="_")

FUN1=function(x)
{
 x1 = unique(unlist(strsplit(sub("MANTRA","0MANTRA",x),",")))
 x1=sub("0MANTRA","MANTRA",x1[order(x1)])
 return(paste(x1,collapse=","))
}
byMarkerTrait0 = tapply( vep0[,"For"] , INDEX=as.factor(vep0$Marker_Trait) , FUN=FUN1 )
byMarkerTrait1 = data.frame( Marker_Trait=names(byMarkerTrait0) , For_byTrait=byMarkerTrait0 , stringsAsFactors=F )
vep0 = merge(vep0,byMarkerTrait1,by="Marker_Trait")
rm(FUN1,byMarkerTrait0,byMarkerTrait1)

vep0_Marker_Trait = unique( vep0[,c("MarkerName","Allele1","Allele2","Trait","For_byTrait")])
vep0_Marker_Trait$Trait_For = paste(vep0_Marker_Trait$Trait,vep0_Marker_Trait$For_byTrait,sep=":")

byMarker0 = tapply( vep0_Marker_Trait[,"Trait_For"] , INDEX=as.factor(vep0_Marker_Trait$MarkerName) , FUN=function(x) { return(paste(x,collapse=";")) } )
byMarker1 = data.frame( MarkerName=names(byMarker0) , For_byMarker=byMarker0 , stringsAsFactors=F )
vep0 = merge(vep0,byMarker1,by="MarkerName")
rm(byMarker0,byMarker1)

save(vep0 , file="/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/VEP/VEP_ForSara_CircularPlots_detailedinput.RData" )


load( "/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/VEP/VEP_ForSara_CircularPlots_detailedinput.RData" )


vep0_Marker = unique( vep0[,c("MarkerName","Allele1","Allele2","For_byMarker")])
tp = sapply( vep0_Marker$MarkerName , FUN=function(x){x1=strsplit(x,":")[[1]] ; return(c(chr=x1[1],pos=x1[2]))} )
vep0_Marker$Chr = tp["chr",]
vep0_Marker$Pos = as.numeric(tp["pos",])
rm(tp)

table(vep0_Marker$Allele1,grepl("DEL",vep0_Marker$MarkerName))

write.table( cbind(vep0_Marker$MarkerName) ,"/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/rsID_1000G/markers_ForSara_CircularPlots.txt" , quote=F , col.names=F , row.names=F , sep="\t" )


 #-----------
 chr = commandArgs(trailingOnly=T)

 tp1 = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/rsID_1000G/markers_ForSara_CircularPlots.txt" , h=F , as.is=T )
 tp0 = sapply( tp1$V1 , FUN=function(x){x1=strsplit(x,":")[[1]] ; return(c(chr=x1[1],pos=x1[2])) } )
 dim(tp0)

 write.table( cbind(tp0["pos",which(tp0["chr",]==chr)]) , paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/rsID_1000G/markers_ForSara_CircularPlots.",chr,".txt",sep="") , quote=F , col.names=F , row.names=F , sep="\t" )
 command = paste("zcat /lustre/scratch115/resources/1000g/release/20110521-v3/ALL.chr",chr,".phase1_release_v3.20101123.snps_indels_svs.genotypes.vcf.gz | awk -F\"\t\" 'BEGIN {while ((getline < \"/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/rsID_1000G/markers_ForSara_CircularPlots.",chr,".txt\") > 0) { a[$1]=1 }} { if(a[$2]==1) {print $0} }' | cut -f1-7 > /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/rsID_1000G/markers_ForSara_CircularPlots_in_1000G.",chr,".txt" , sep="" )
 system(command)
 system(paste("rm /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/rsID_1000G/markers_ForSara_CircularPlots.",chr,".txt",sep=""))
 #-----------


for i in {1..22} X; do bsub -G t35_magic -P t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/rsID_1000G/bsub.ForSara_CircularPlots.$i.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/rsID_1000G/bsub.ForSara_CircularPlots.$i.err -R"select[mem>5000] rusage[mem=5000]" -M5000 "/software/R-3.0.0/bin/R --no-save --args $i < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/rsID_1000G/ForSara_CircularPlots_Markers_1000G_script.R"; done



load( "/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/VEP/VEP_ForSara_CircularPlots_detailedinput.RData" )
vep0_Marker = unique( vep0[,c("MarkerName","Allele1","Allele2","For_byMarker")])
tp = sapply( vep0_Marker$MarkerName , FUN=function(x){x1=strsplit(x,":")[[1]] ; return(c(chr=x1[1],pos=x1[2]))} )
vep0_Marker$Chr = tp["chr",]
vep0_Marker$Pos = as.numeric(tp["pos",])
rm(tp)

table(vep0_Marker$Allele1,grepl("DEL",vep0_Marker$MarkerName))

G1000 = NULL
for ( i in c(1:22,"X") )
{
 tp = read.table(paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/rsID_1000G/markers_ForSara_CircularPlots_in_1000G.",i,".txt",sep=""),col.names=c("CHR","POS","rsID","REF","ALT","QUAL","FILTER"),as.is=T)
 G1000 = rbind( G1000 , tp )
 rm(tp)
} ; rm(i)

table( paste(vep0_Marker$Chr,vep0_Marker$Pos,sep=":") %in% paste(G1000$CHR,G1000$POS,sep=":") , grepl("DEL",vep0_Marker$MarkerName) )

mm = merge( vep0_Marker , G1000 , by.x=c("Chr","Pos") , by.y=c("CHR","POS") , all=T )
table(mm$FILTER,exclude=c())

table(mm$Allele1==tolower(mm$ALT),mm$Allele1==tolower(mm$REF))
table(mm$Allele1==tolower(mm$ALT) & mm$Allele2==tolower(mm$REF),mm$Allele1==tolower(mm$REF) & mm$Allele2==tolower(mm$ALT) )

table(mm$Allele1==tolower(mm$ALT),mm$Allele1==tolower(mm$REF) , grepl("DEL",mm$MarkerName) )

mm[which(mm$Allele1!=tolower(mm$ALT) & mm$Allele1!=tolower(mm$REF) & !grepl("DEL",mm$MarkerName) ),]

mm$AlleleMatch = ifelse( mm$Allele1==tolower(mm$ALT) & mm$Allele2==tolower(mm$REF) | mm$Allele1==tolower(mm$REF) & mm$Allele2==tolower(mm$ALT) , yes=1 , no=0 )
table( mm$AlleleMatch , grepl("DEL",mm$MarkerName) )
mm[which(mm$AlleleMatch==0 & !grepl("DEL",mm$MarkerName)),]


mm[which(mm$Pos %in% names(table(mm$Pos)[table(mm$Pos)>1])),]

mm = mm[ -which(mm$Pos %in% names(table(mm$Pos)[table(mm$Pos)>1]) & mm$AlleleMatch==0 & !grepl("DEL",mm$MarkerName)) ,]
table( mm$AlleleMatch , grepl("DEL",mm$MarkerName) )

ww = which( grepl("DEL",mm$MarkerName) & mm$AlleleMatch==0 )
for ( i in ww )
{
 if(nchar(mm[i,"REF"])>nchar(mm[i,"ALT"])) { mm[i,"Allele1"]=tolower(mm[i,"ALT"]) ; mm[i,"Allele2"]=tolower(mm[i,"REF"]) }
 if(nchar(mm[i,"REF"])<nchar(mm[i,"ALT"])) { mm[i,"Allele2"]=tolower(mm[i,"ALT"]) ; mm[i,"Allele1"]=tolower(mm[i,"REF"]) }
 if(nchar(mm[i,"REF"])==nchar(mm[i,"ALT"])) { cat(mm[i,"MarkerName"],"not indel in 1000G...\n") }
} ; rm(i)

mm[which(mm$Pos %in% names(table(mm$Pos)[table(mm$Pos)>1])),]

table( mm$Allele1=="d" , mm$AlleleMatch , exclude=c() )

mm2 = mm[which(mm$Allele1!="d" & !is.na(mm$AlleleMatch)),]


vep0_Marker2 = merge( vep0_Marker , mm2[,c("MarkerName","Allele1","Allele2")] , all.x=T , by="MarkerName" )
table(vep0_Marker2$Allele1.x==vep0_Marker2$Allele1.y)
table(vep0_Marker2$Allele2.x==vep0_Marker2$Allele2.y)
ww = which(vep0_Marker2$Allele1.x!=vep0_Marker2$Allele1.y)
vep0_Marker2$Allele1.x[ww]=vep0_Marker2$Allele1.y[ww]
vep0_Marker2$Allele2.x[ww]=vep0_Marker2$Allele2.y[ww]
colnames(vep0_Marker2)[which(colnames(vep0_Marker2)=="Allele1.x")] = "Allele1"
colnames(vep0_Marker2)[which(colnames(vep0_Marker2)=="Allele2.x")] = "Allele2"
vep0_Marker2$Allele1.y=NULL
vep0_Marker2$Allele2.y=NULL
rm(ww)


vep1 = vep0_Marker2[order(as.numeric(vep0_Marker2$Chr),vep0_Marker2$Pos),]
vep1 = vep1[which(vep1$Allele1!="d"),]
vep1$Allele1 = toupper(vep1$Allele1)
vep1$Allele2 = toupper(vep1$Allele2)
colnames(vep1)[5] = "#CHROM"
colnames(vep1)[6] = "POS"
colnames(vep1)[2] = "ALT"
colnames(vep1)[3] = "REF"
vep1$ID="."
vep1$QUAL=100
vep1$FILTER="PASS"

write.table( vep1[,c("#CHROM","POS","ID","REF","ALT","QUAL","FILTER")] , "/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/VEP/VEP_ForSara_CircularPlots.in" , quote=F , row.names=F , col.names=T , sep="\t" )
rm(list=ls()) ; gc()

# perl /software/team35/ensembl-tools-release-79/scripts/variant_effect_predictor/variant_effect_predictor.pl --help
# perl /software/team35/ensembl-tools-release-84/scripts/variant_effect_predictor/variant_effect_predictor.pl --help

bsub -o /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/VEP/bsub_vep79_ForSara_CircularPlots.out -e /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/VEP/bsub_vep79_ForSara_CircularPlots.err -G t35_magic -P t35_magic -R"select[mem>5000] rusage[mem=5000]" -M5000 "perl /software/team35/ensembl-tools-release-79/scripts/variant_effect_predictor/variant_effect_predictor.pl  --cache --dir /software/team35/ensembl-tools-release-79/scripts/variant_effect_predictor/ --port 3337 --format vcf -i /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/VEP/VEP_ForSara_CircularPlots.in -o /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/VEP/VEP_ForSara_CircularPlots.out --symbol --protein --uniprot --hgvs --canonical --biotype"


vep1 = read.table( "/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/VEP/VEP_ForSara_CircularPlots.in" , col.names=c("CHROM","POS","ID","FROM","TO","QUAL","FILTER") , as.is=T )
vep1$upl = paste( vep1$CHROM , vep1$POS ,   paste(vep1$FROM,vep1$TO,sep="/") , sep="_" )

vep2 = read.table( "/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/VEP/VEP_ForSara_CircularPlots.out" ,  as.is=T , fill=T ,
                   col.names=c("Uploaded_variation","Location","Allele","Gene","Feature","Feature_type","Consequence","cDNA_position","CDS_position","Protein_position","Amino_acids","Codons","Existing_variation","Extra") )

length(unique(vep1$upl))
length(unique(vep2$Uploaded_variation))
sum( unique(vep1$upl) %in% unique(vep2$Uploaded_variation) )
vep1$Upload_Exact = ifelse( vep1$upl %in% vep2$Uploaded_variation , yes=1 , no=0 )
table(vep1$Upload_Exact)
table(vep1$Upload_Exact, nchar(vep1$FROM))
vep1$Uploaded_variation = apply( vep1[,c("CHROM","POS","FROM","TO","Upload_Exact")] , MARGIN=1 ,
                                   FUN=function(x){
                                                    if ( as.numeric(x[5])==0 )
                                                    {
                                                     ref = ifelse(nchar(x[3])>1,yes=substr(x[3],2,nchar(x[3])),no="-")
                                                     alt = ifelse(nchar(x[4])>1,yes=substr(x[4],2,nchar(x[4])),no="-")
                                                     return( paste( x[1] , as.integer(x[2])+1 ,   paste(ref,alt,sep="/") , sep="_" ) )
                                                    } else { return( paste( x[1] , as.integer(x[2]) ,   paste(x[3],x[4],sep="/") , sep="_" ) ) }
                                                  } )

sum( unique(vep1$Uploaded_variation) %in% unique(vep2$Uploaded_variation) )

vep3 = merge( vep1[,c("CHROM","POS","FROM","TO","Uploaded_variation")] , vep2 , by="Uploaded_variation" )
rm(vep1,vep2)
vep3$ProteinCoding = grepl("protein_coding",vep3$Extra)
vep3$Canonical = grepl("CANONICAL",vep3$Extra)
vep3$CHROM_POS = paste( vep3$CHROM , vep3$POS , sep=":" )
ee = sapply( vep3$Extra ,
             FUN=function(v){
                              y=strsplit(v,";")[[1]]
                              #fields = paste(sapply(y,FUN=function(v2){y2=strsplit(v2,"=")[[1]][1]}),collapse=";")
                              ww0=grep("IMPACT=",y)    ; if (length(ww0)>0) { impact=sub("IMPACT=","",y[ww0])       } else {impact=NA   }
                              ww1=grep("SYMBOL=",y)    ; if (length(ww1)>0) { symbol=sub("SYMBOL=","",y[ww1])       } else {symbol=NA   }
                              ww2=grep("ENSP=",y)      ; if (length(ww2)>0) { ensp=sub("ENSP=","",y[ww2])           } else {ensp=NA     }
                              return( c( #fields=fields ,
                                         impact=impact ,
                                         symbol=symbol ,
                                         ensp=ensp
                                         ) )
                            } )
vep3$SYMBOL     = ee["symbol",]
vep3$ENSP       = ee["ensp",]
vep3$IMPACT     = ee["impact",]
rm(ee) ; gc()


table( vep3$Feature_type , vep3$Consequence=="intergenic_variant")
table( vep3$ProteinCoding , vep3$Consequence=="intergenic_variant")


oo = data.frame( oo=1:12,
                 csq=c("splice_acceptor_variant","splice_donor_variant","stop_gained","missense_variant","splice_region_variant",
                       "synonymous_variant","coding_sequence_variant","5_prime_UTR_variant","3_prime_UTR_variant",
                       "intron_variant","upstream_gene_variant","downstream_gene_variant"
                      ),
                stringsAsFactors=F
               )


byVariant0 = by( vep3[,c("Consequence","ProteinCoding","Feature","Protein_position","Amino_acids","Codons","SYMBOL","Canonical")] ,
                 INDICES = as.factor( vep3$CHROM_POS ) ,
                 FUN = function(x){
                                   x1 = x[which(x$ProteinCoding),]
                                   if(nrow(x1)>0)
                                   {
                                    oo_here = oo[which(oo$csq %in% unique(unlist(strsplit(x1$Consequence,",")))),]
                                    worse_csq  = oo_here[which.min(oo_here$oo),"csq"]
                                    ww = grep(worse_csq,x1$Consequence)
                                    symbol  = paste(unique(x1$SYMBOL[ww]),collapse=",")
                                    details = paste( paste( x1$SYMBOL , x1$Feature , x1$Consequence , x1$Protein_position , x1$Amino_acids , x1$Codons , sep=":" )[ww] , collapse="|" )
                                   } else { worse_csq="No_Protein_Coding" ; symbol="No_Protein_Coding" ; details="No_Protein_Coding" }
                                   return(c( WorseCSQ=worse_csq , WorseCSQ_SYMBOL=symbol , WorseCSQ_DETAILS=details ))
                                  }
               )

byVariant1 = data.frame( CHROM_POS=names(byVariant0) , do.call( rbind , byVariant0 ) , stringsAsFactors=F )


uu = unique(vep3[,c("CHROM_POS","FROM","TO")])
byVariant2 = merge( uu , byVariant1 , by="CHROM_POS")



load( "/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/VEP/VEP_ForSara_CircularPlots_detailedinput.RData" )
vep0_Marker = unique( vep0[,c("MarkerName","Allele1","Allele2","For_byMarker")])
vep0_Marker$CHROM_POS = sapply( vep0_Marker$MarkerName , FUN=function(x){x1=strsplit(x,":")[[1]] ; return(paste(x1[1],x1[2],sep=":")) } )

table( vep0_Marker$CHROM_POS %in% byVariant1$CHROM_POS)

byVariant3 = merge( vep0_Marker , byVariant2 , by="CHROM_POS" , all.x=T)

table(byVariant3$Allele1 , is.na(byVariant3$TO) )

write.table( byVariant3 , file="/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/VEP/VEP_ForSara_CircularPlots_WorseCSQ_perVariants.txt" , quote=F , row.names=F , sep="\t" )



###############################################################
### Compare Gaelle & Jani MANTRA results
###############################################################





Marker Name     Chr     Pos     Log10BF_MANTRA  Marker Name     Chr     Pos     Log10BF_MANTRA

CompFromMila = rbind( c("1:219625465:SNP",1,219625465,18.379,"1:219628973:SNP",1,219628973,18.24518),
                      c("2:622827:SNP",2,622827,6.79616,"2:630902:SNP",2,630902,6.62187),
                      c("3:12390484:SNP",3,12390484,27.31244,"3:12344730:SNP",3,12344730,26.98707),
                      c("3:49884913:SNP",3,49884913,6.78591,"3:49884261:SNP",3,49884261,6.64205),
                      c("6:31484561:SNP",6,31484561,7.19828,"6:31484550:SNP",6,31484550,7.16251),
                      c("6:127449447:SNP",6,127449447,14.52175,"6:127452935:SNP",6,127452935,14.09472),
                      c("6:139828916:SNP",6,139828916,8.94016,"6:139834012:SNP",6,139834012,8.53993),
                      c("7:130427057:SNP",7,130427057,10.13994,"7:130429186:SNP",7,130429186,9.47701),
                      c("7:50746141:SNP",7,50746141,6.62803,"7:50754679:SNP",7,50754679,6.43153),
                      c("9:4287466:SNP",9,4287466,10.50957,"9:4295880:SNP",9,4295880,10.25815),
                      c("9:82312046:SNP",9,82312046,6.09656,"9:82294364:SNP",9,82294364,5.70463),
                      c("10:65133822:SNP",10,65133822,6.1752,"10:65184717:SNP",10,65184717,5.91038),
                      c("10:122916639:SNP",10,122916639,8.74474,"10:122930612:SNP",10,122930612,8.32323),
                      c("11:72351358:SNP",11,72351358,6.07796,"11:72350595:SNP",11,72350595,5.9898),
                      c("12:26467696:SNP",12,26467696,11.01207,"12:26474867:SNP",12,26474867,9.82511),
                      c("12:66351826:SNP",12,66351826,7.61363,"12:66371880:SNP",12,66371880,7.29821),
                      c("12:102898446:SNP",12,102898446,11.89553,"12:102912558:SNP",12,102912558,10.69346),
                      c("18:39473567:SNP",18,39473567,10.04902,"18:39475759:SNP",18,39475759,9.03973),
                      c("20:45582472:SNP",20,45582472,8.69106,"20:45581777:SNP",20,45581777,8.58845),
                      c("8:42670386:SNP",8,42670386,10.50957,NA,NA,NA,NA),
                      c("13:97081565:SNP",13,97081565,6.21545,NA,NA,NA,NA),
                      c("14:31174237:SNP",14,31174237,6.11825,NA,NA,NA,NA),
                      c("16:86372022:INDEL",16,86372022,6.22223,NA,NA,NA,NA),
                      c(NA,NA,NA,NA,"12:79157553:SNP",12,79157553,4.26116))
CompFromMila = data.frame( CompFromMila , stringsAsFactors=F )
colnames(CompFromMila) = c("Mila_MarkerName","Mila_Chr","Mila_Pos","Mila_Log10BF_MANTRA","Gaelle_MarkerName","Gaelle_Chr","Gaelle_Pos","Gaelle_Log10BF_MANTRA")
for ( i in c(2,3,4,6,7,8) ) { CompFromMila[,i]=as.numeric(CompFromMila[,i]) } ; rm(i)

load("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/FORESTPLOTS_data/DataExtracted_ALLsignalsANDknown_FInsadjBMI.InvNorm.GM_mantra.RData")
gm=vvMANTRA
rm(vvMANTRA)
load("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/FORESTPLOTS_data/DataExtracted_ALLsignalsANDknown_FInsadjBMI.InvNorm.Jani_mantra.RData")
jani=vvMANTRA
rm(vvMANTRA)

mm=merge(gm,jani,by="MarkerName")


table(mm$N_Ethnicity.x,mm$N_Ethnicity.y)
table(mm$Sample_Size.x==mm$Sample_Size.y)
plot(mm$Log10BF_MANTRA.x,mm$Log10BF_MANTRA.y) ; abline(0,1,col="grey")
table(mm$Log10BF_MANTRA.x<mm$Log10BF_MANTRA.y)
table(mm$Log10BF_MANTRA.x>=6,mm$Log10BF_MANTRA.y>=6)

table(CompFromMila$Mila_MarkerName %in% mm$MarkerName)
table(CompFromMila$Gaelle_MarkerName %in% mm$MarkerName)



zcat MANTRA_FInsadjBMI_InvNorm/mantra.FInsadjBMI.InvNorm.GM.out.gz | grep 12:79157553:SNP
zcat MANTRA_FInsadjBMI_InvNorm/mantra.FInsadjBMI.InvNorm.GM.out.gz | grep 8:42670386:SNP
zcat MANTRA_FInsadjBMI_InvNorm/mantra.FInsadjBMI.InvNorm.GM.out.gz | grep 13:97081565:SNP
zcat MANTRA_FInsadjBMI_InvNorm/mantra.FInsadjBMI.InvNorm.GM.out.gz | grep 14:31174237:SNP
zcat MANTRA_FInsadjBMI_InvNorm/mantra.FInsadjBMI.InvNorm.GM.out.gz | grep 16:86372022:INDEL


#
zcat /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_ResFromVolunteers/mantra.FInsadjBMI.InvNorm.ALL.JH.out.gz | head
zcat /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FInsadjBMI_InvNorm/mantra.FInsadjBMI.InvNorm.GM.out.gz  | head




### ----- START SCRIPT -------------------------------
param = commandArgs(trailingOnly=T)

pathA=param[1]  #"/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FInsadjBMI_InvNorm/mantra.FInsadjBMI.InvNorm.GM.out.gz"
pathB=param[2]  #"/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_ResFromVolunteers/mantra.FInsadjBMI.InvNorm.ALL.JH.out.gz"
pre=param[3]  #pre = "FInsadjBMI_InvNorm_GAELLEvsJANI"

# upload
runA = read.table( gzfile(pathA) , as.is=T , col.names=c("MarkerName","Chr","Pos","Effect_Allele","Other_Allele","N_Ethnicity","Effect_AC","Minor_AC","Effect_Allele_Freq","Log10BF_MANTRA","Log10BF_FE","Log10BF_Heterogeneity","Sample_Size","Direction") , nrows=10000 )
runA = runA[,c("MarkerName","N_Ethnicity","Effect_Allele_Freq","Log10BF_MANTRA","Log10BF_Heterogeneity","Sample_Size")]
gc()

runB = read.table( gzfile(pathB) , as.is=T , col.names=c("MarkerName","Chr","Pos","Effect_Allele","Other_Allele","N_Ethnicity","Effect_AC","Minor_AC","Effect_Allele_Freq","Log10BF_MANTRA","Log10BF_FE","Log10BF_Heterogeneity","Sample_Size","Direction") , nrows=10000 )
runB = runB[,c("MarkerName","N_Ethnicity","Effect_Allele_Freq","Log10BF_MANTRA","Log10BF_Heterogeneity","Sample_Size")]
gc()


# check markers
table( runA$MarkerName %in% runB$MarkerName )
table( runB$MarkerName %in% runA$MarkerName )

if ( sum(!(runA$MarkerName %in% runB$MarkerName))>0 | sum(!(runB$MarkerName %in% runA$MarkerName))>0 )
{
 cat("Extracted markers from a single run.. ")
 runA_only = runA[which(!(runA$MarkerName %in% runB$MarkerName)),]
 runB_only = runB[which(!(runB$MarkerName %in% runA$MarkerName)),]
 save(runA_only,file=paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_VolunteersComparison/",pre,"_A_only.RData",sep=""))
 save(runB_only,file=paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_VolunteersComparison/",pre,"_B_only.RData",sep=""))
 rm(runA_only,runB_only)
 runA = runA[which(runA$MarkerName %in% runB$MarkerName),]
 runB = runB[which(runB$MarkerName %in% runA$MarkerName),]
 gc()
 cat("Done.\n")
}

table( runA$MarkerName == runB$MarkerName )
table( runB$MarkerName == runA$MarkerName )

colnames(runA)[-c(1)] = paste("A",colnames(runA)[-c(1)],sep="_")
colnames(runB)[-c(1)] = paste("B",colnames(runB)[-c(1)],sep="_")

# combining data
if( sum(runA$MarkerName!=runB$MarkerName)==0 )
{
 cat("Same order, binding.. ")
 comp = cbind( runA , runB[-c(1)] )
 rm( runA , runB )
 gc()
 cat("Done.\n")
} else {
         cat("Different order, merging.. ")
         comp = merge( runA , runB , by="MarkerName" )
         rm( runA , runB )
         gc()
         cat("Done.\n")
       }


# check number of ethnicities
table( comp$A_N_Ethnicity , comp$B_N_Ethnicity )

# check EAF
table( comp$A_Effect_Allele_Freq == comp$B_Effect_Allele_Freq , exclude=c() )

table( is.na(comp$A_Effect_Allele_Freq) , is.na(comp$B_Effect_Allele_Freq) )

if( sum(comp$A_Effect_Allele_Freq!=comp$B_Effect_Allele_Freq,na.rm=T)>0 )
{
 cat("Extracted markers with different EAF.. ")
 EAF_diff = comp[which(comp$A_Effect_Allele_Freq!=comp$B_Effect_Allele_Freq),]
 save(EAF_diff,file=paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_VolunteersComparison/",pre,"_EAF_diff.RData",sep=""))
 rm(EAF_diff) ; gc()
 cat("Done.\n")
}

# check sample size
table( comp$A_Sample_Size == comp$B_Sample_Size , exclude=c() )

table( is.na(comp$A_Sample_Size) , is.na(comp$B_Sample_Size) )

if( sum(comp$A_Sample_Size!=comp$B_Sample_Size,na.rm=T)>0 )
{
 cat("Extracted markers with different sample size.. ")
 N_diff = comp[which(comp$A_Sample_Size!=comp$B_Sample_Size),]
 save(N_diff,file=paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_VolunteersComparison/",pre,"_N_diff.RData",sep=""))
 rm(N_diff) ; gc()
 cat("Done.\n")
}

# check logBF MANTRA  significance conlcusion

comp$logBFMANTRA_diff = comp$A_Log10BF_MANTRA-comp$B_Log10BF_MANTRA
comp$logBFHET_diff = comp$A_Log10BF_Heterogeneity-comp$B_Log10BF_Heterogeneity

comp$MAF = pmin(comp$A_Effect_Allele_Freq,1-comp$A_Effect_Allele_Freq) # EAF should be the same! See check before.

table( comp$A_Log10BF_MANTRA>=6comp$B_Log10BF_MANTRA>=6 , exclude=c())

wwD = which( (comp$A_Log10BF_MANTRA>=6 & comp$B_Log10BF_MANTRA<6) | (comp$A_Log10BF_MANTRA<6 & comp$B_Log10BF_MANTRA>=6) )
if( length(wwD)>0 )
{
 cat("Extracted markers with different side of 6 for LogBF_MANTRA.. ")
 Conclu_diff = comp[wwD,]
 save(Conclu_diff,file=paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_VolunteersComparison/",pre,"_Conclu_diff.RData",sep=""))
 rm(Conclu_diff) ; gc()
 cat("Done.\n")
}
rm(wwD)

# check logBF MANTRA
png(paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_VolunteersComparison/",pre,"_plot_logBFMANTRA_all.png",sep=""))
plot( comp$A_Log10BF_MANTRA , comp$B_Log10BF_MANTRA , main="Log10BF_MANTRA" , xlab="run A" , ylab="run B" ) ; abline(0,1,col="grey") ; abline(h=6,col="red") ; abline(v=6,col="red")
dev.off()

png(paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_VolunteersComparison/",pre,"_plot_logBFMANTRA_zoom.png",sep=""))
minX = min(comp$A_Log10BF_MANTRA,na.rm=T)
minY = min(comp$B_Log10BF_MANTRA,na.rm=T)
plot( comp$A_Log10BF_MANTRA , comp$B_Log10BF_MANTRA , main="Log10BF_MANTRA" , xlab="run A" , ylab="run B" , xlim=c(minX,6) , ylim=c(minY,6) ) ; abline(0,1,col="grey")
rm(minX,minY)
dev.off()

png(paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_VolunteersComparison/",pre,"_plot_MANTRAdiff_vs_runs.png",sep=""),width=800,heigh=800)
par(mfrow=c(2,2))
plot( comp$A_Log10BF_MANTRA , comp$logBFMANTRA_diff , xlab="run A Log10BF_MANTRA" , ylab="Log10BF_MANTRA diff" ) ; abline(v=0,h=0,col="grey")
plot( comp$B_Log10BF_MANTRA , comp$logBFMANTRA_diff , xlab="run B Log10BF_MANTRA" , ylab="Log10BF_MANTRA diff" ) ; abline(v=0,h=0,col="grey")
plot( comp$MAF , comp$logBFMANTRA_diff , xlab="MAF" , ylab="Log10BF_MANTRA diff" ) ; abline(v=0.01,col="red") ; abline(h=0,col="grey")
plot( comp$A_Sample_Size , comp$logBFMANTRA_diff , xlab="Sample size (runA)" , ylab="Log10BF_MANTRA diff" ) ; abline(h=0,col="grey")
dev.off()

# check logBF HET in significant signals
wwS = which( comp$A_Log10BF_MANTRA>=6 | comp$B_Log10BF_MANTRA>=6 )
length(wwS)

if( length(wwS)>0 )
{
 png(paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_VolunteersComparison/",pre,"_plot_logBFHET_signif.png",sep=""))
 plot( comp$A_Log10BF_Heterogeneity[wwS] , comp$B_Log10BF_Heterogeneity[wwS] , main="Log10BF_Heterogeneity\nfor Log10BF_MANTRA≥6 in one run at least" , xlab="run A" , ylab="run B" ) ; abline(0,1,col="grey")
 dev.off()

 png(paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_VolunteersComparison/",pre,"_plot_MANTRAdiff_vs_HETdiff_signif.png",sep=""))
 plot( comp$logBFMANTRA_diff[wwS] , comp$logBFHET_diff[wwS] , main="MANTRA diff vs HET diff\nfor Log10BF_MANTRA≥6 in one run at least" , xlab="Log10BF_MANTRA diff" , ylab="Log10BF_Heterogeneity diff" ) ; abline(0,1,col="grey")
 dev.off()
}
### ----- END SCRIPT -------------------------------


## submit script
bsub -q normal -G t35_magic -P t35_magic -o /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_VolunteersComparison/bsub.GAELLEvsJANI.out -e /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_VolunteersComparison/bsub.GAELLEvsJANI.err -R"select[mem>25000]  rusage[mem=25000]"  -M25000  "/software/R-3.0.0/bin/R --no-save --args /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_FInsadjBMI_InvNorm/mantra.FInsadjBMI.InvNorm.GM.out.gz /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_ResFromVolunteers/mantra.FInsadjBMI.InvNorm.ALL.JH.out.gz FInsadjBMI_InvNorm_GAELLEvsJANI < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_VolunteersComparison/Script_MANTRA_Comparison.R"


## look SNPs with different conclusion on logBF>=6
load("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/MANTRA_VolunteersComparison/FInsadjBMI_InvNorm_GAELLEvsJANI_Conclu_diff.RData")
summary(Conclu_diff$logBFMANTRA_diff)

plot( Conclu_diff$A_Log10BF_MANTRA , Conclu_diff$B_Log10BF_MANTRA , main="Log10BF_MANTRA\nFor 197 markers going either side of logBF=6" , xlab="run A" , ylab="run B") ; abline(0,1,col="grey") ; abline(h=6,col="red") ; abline(v=6,col="red")



tocheck=c("12:79157553:SNP","8:42670386:SNP","13:97081565:SNP","14:31174237:SNP","16:86372022:INDEL")
Conclu_diff[which(Conclu_diff$MarkerName %in% tocheck),]
#MarkerName     Jani    Gaelle
#8:42670386:SNP 7.49309 3.65807  ### In Mila's table, it get a logBF=10.5 from Jani's results... but it get a logBF=7.5, so less difference!
#12:79157553:SNP        4.26116 6.09657
#13:97081565:SNP        6.21545 5.01811
#14:31174237:SNP        6.11825 5.7537
#16:86372022:INDEL      6.22223 5.86031
