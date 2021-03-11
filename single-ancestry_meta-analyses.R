## FREEZE1 and FREEZE2 cleaned and "free of outliers" files (988)
ff0 = dir("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/FilesForMA_feb2016_WithoutTRIALLELIC/files_uploaded",full.names=T)
ff0_file = sapply( ff0 , FUN=function(x){ x1 = strsplit(x,"/",fixed=T)[[1]] ; return(x1[length(x1)]) } )
ff0_file = sub("CLEANED.","",ff0_file)
ff0_fileName = sub(".txt","",sub(".gz","",ff0_file))
ff0_fileName = sub("CM_SW","CM.SW",ff0_fileName)
ff1 = sapply( ff0_fileName , FUN=function(x){ x1=strsplit(x,"_")[[1]]
                                              if( x1[5]=="InvNorm" ) {tt="InvNorm";ss=x1[6]} else {tt="Raw";ss=x1[5]}
                                              return(c(Ancestry=x1[1],Chip=x1[2],Chr=x1[3],Trait=x1[4],Transf=tt,Study=ss))
                                             } )

table(ff1["Ancestry",])
table(ff1["Chip",])
table(ff1["Chr",])
table(ff1["Trait",])
table(ff1["Transf",])
table(ff1["Trait",],ff1["Transf",])

table( paste(ff1["Trait",],ff1["Transf",],sep=":") , ff1["Ancestry",] )

ssFGr = ff1["Study", which(ff1["Trait",]=="FGluadjBMI" & ff1["Transf",]=="Raw" & ff1["Ancestry",]=="EA") ]
ssFGi = ff1["Study", which(ff1["Trait",]=="FGluadjBMI" & ff1["Transf",]=="InvNorm" & ff1["Ancestry",]=="EA") ]


## Make METAL scripts with each cohort results fro the meta-analysis - for raw files - by trait and ancestry

table(ff1["Trait",],ff1["Ancestry",],ff1["Chr",])
table(ff1["Trait",],ff1["Ancestry",],ff1["Transf",])

table( paste(ff1["Trait",],ff1["Transf",],sep=":") , ff1["Ancestry",] )

toRun = rbind( c(A="EA" , T="2hrGluadjBMI" , F="Raw") ,
               c(A="EA" , T="FGluadjBMI"   , F="Raw") ,
               c(A="EA" , T="HbA1cadjFGlu" , F="Raw") ,

               c(A="AA" , T="2hrGluadjBMI" , F="Raw") ,
               c(A="AA" , T="FGluadjBMI"   , F="Raw") ,
               c(A="AA" , T="HbA1cadjFGlu" , F="Raw") ,

               c(A="EAA" , T="2hrGluadjBMI" , F="Raw") ,
               c(A="EAA" , T="FGluadjBMI"   , F="Raw") ,
               c(A="EAA" , T="HbA1cadjFGlu" , F="Raw") ,

               c(A="HA" , T="2hrGluadjBMI" , F="Raw") ,
               c(A="HA" , T="FGluadjBMI"   , F="Raw") ,
               c(A="HA" , T="HbA1cadjFGlu" , F="Raw") ,

               c(A="IAA" , T="FGluadjBMI"   , F="Raw") ,
               c(A="IAA" , T="HbA1cadjFGlu" , F="Raw") ,

               c(A="UAA" , T="HbA1c" , F="Raw") ,
               c(A="UAA" , T="HbA1c" , F="InvNorm")
             )

toRun = rbind( c(A="ALL" , T="2hrGluadjBMI" , F="Raw") ,
               c(A="ALL" , T="FGluadjBMI"   , F="Raw") ,
               c(A="ALL" , T="HbA1cadjFGlu" , F="Raw") ,
               c(A="ALL" , T="FInsadjBMI"   , F="Raw") ,
               c(A="ALL" , T="HbA1c" , F="Raw") ,
               c(A="ALL" , T="HbA1c" , F="InvNorm") ,
               c(A="ALL" , T="2hrGluadjBMI" , F="InvNorm") ,
               c(A="ALL" , T="FGluadjBMI"   , F="InvNorm") ,
               c(A="ALL" , T="HbA1cadjFGlu" , F="InvNorm") ,
               c(A="ALL" , T="FInsadjBMI"   , F="InvNorm")
             )

toRun = rbind( c(A="EA" , T="HbA1c" , F="InvNorm") )


for ( i in 1:nrow(toRun) )
{
  if(i==1) {cat(nrow(toRun),": ")}
  cat(i,".. ")
  aa = toRun[i,"A"]
  tt = toRun[i,"T"]
  tf = toRun[i,"F"]

  if( aa!="ALL" )
  {
   ww = which(ff1["Trait",]==tt & ff1["Ancestry",]==aa & ff1["Transf",]==tf)
   wwo = ww[order(ff0_fileName[ww])]
  } else {
           ww = which(ff1["Trait",]==tt & ff1["Transf",]==tf)
           wwo = ww[order(ff0_fileName[ww])]
         }

  for ( wwi in wwo )
  {
   if (wwi==wwo[1])
   {
    script=c("# === START ===",
             "SCHEME STDERR",
             "# === DESCRIBE AND PROCESS THE INPUT FILES ===",
             "SEPARATOR TAB",
             "MARKER MarkerName",
             "ALLELE EFFECT_ALLELE NON_EFFECT_ALLELE",
             "EFFECT BETA",
             "STDERR SE",
             "AVERAGEFREQ ON",
             "MINMAXFREQ ON",
             "FREQLABEL EAF_QTL ",
             "CUSTOMVARIABLE  TotalSampleSize",
             "LABEL TotalSampleSize as N_QTL",
             ifelse( ff1["Chip",wwi]=="GWAS" , yes="GENOMICCONTROL ON" , no="GENOMICCONTROL LIST /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/ReferenceFiles/Metabochip_QT_SNPs_MarkerName_LIST.txt" ),
             paste("PROCESS",ff0[wwi]),
             ""
            )
   } else { script = c( script ,
                        ifelse( ff1["Chip",wwi]=="GWAS" , yes="GENOMICCONTROL ON" , no="GENOMICCONTROL LIST /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/ReferenceFiles/Metabochip_QT_SNPs_MarkerName_LIST.txt" ),
                        paste("PROCESS",ff0[wwi]), "" ) }
  } ; rm(wwi)
  script = c( script ,
              "# === ANALYSE ===",
              paste("OUTFILE /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_results/METAANALYSIS_1",aa,tt,tf," .tbl",sep="_"),
              "ANALYZE HETEROGENEITY" )

  write.table( cbind(script) , paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_scripts/METAL_script_1",aa,tt,tf,sep="_") , quote=F , row.names=F , col.names=F )
  rm(aa,tt,tf,ww,wwo)
} ; rm(i) ; cat("Done.\n")



cd /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_scripts/
#for ss in `ls -1 METAL_script_1*`; do bsub -G t35_magic -P t35_magic  -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.err -R"select[mem>20000] rusage[mem=20000]" -M20000 "/software/team35/METAL-2011-03-25/generic-metal/executables/metal /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_scripts/$ss"; done
#for ss in METAL_script_1_IAA_HbA1cadjFGlu_Raw; do bsub -G t35_magic -P t35_magic  -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.err -R"select[mem>20000] rusage[mem=20000]" -M20000 "/software/team35/METAL-2011-03-25/generic-metal/executables/metal /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_scripts/$ss"; done
#for ss in METAL_script_1_EA_2hrGluadjBMI_Raw; do bsub -G t35_magic -P t35_magic  -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.err -R"select[mem>20000] rusage[mem=20000]" -M20000 "/software/team35/METAL-2011-03-25/generic-metal/executables/metal /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_scripts/$ss"; done
#for ss in `ls -1 METAL_script_1_ALL*`; do bsub -G t35_magic -P t35_magic  -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.err -R"select[mem>20000] rusage[mem=20000]" -M20000 "/software/team35/METAL-2011-03-25/generic-metal/executables/metal /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_scripts/$ss"; done
#for ss in `ls -1 METAL_script_1_ALL_FG*`; do bsub -G t35_magic -P t35_magic  -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.err -R"select[mem>30000] rusage[mem=30000]" -M30000 "/software/team35/METAL-2011-03-25/generic-metal/executables/metal /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_scripts/$ss"; done
for ss in METAL_script_1_EA_HbA1c_InvNorm_11_5248232; do bsub -G t35_magic -P t35_magic  -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.err -R"select[mem>30000] rusage[mem=30000]" -M30000 "/software/team35/METAL-2011-03-25/generic-metal/executables/metal /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_scripts/$ss"; done
cd ../

bjobs | grep Raw | wc
bjobs | grep InvNorm | wc
grep "Completed meta-analysis" METAL_bsubs/*_1_* | wc
grep Success METAL_bsubs/*_1_* | wc
grep "Max Memory" METAL_bsubs/*_1_*

ls -1 /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_results

cd /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_results/
for ff in `ls -1 *.tbl`; do bgzip $ff; done
cd ../


## METAL scripts with meta-analysis METAL outputs in order to apply the double-GC correction

outMETAL = dir ("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_results" , full.names=T )
outMETAL1 = outMETAL[ which( grepl("METAANALYSIS_1_",outMETAL) & !grepl(".info",outMETAL)) ]
outMETAL2 = outMETAL[ which( grepl("METAANALYSIS_2_",outMETAL) & !grepl(".info",outMETAL)) ]

woutMETAL1 = sub("_InvNorm_","",sub("_Raw_","",sub("1.tbl.gz","",sub("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_results/METAANALYSIS_1_","",outMETAL1))))
woutMETAL2 = sub("_InvNorm","",sub("_Raw","",sub("1.tbl.gz","",sub("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_results/METAANALYSIS_2_","",outMETAL2))))

table( woutMETAL2 %in% woutMETAL1 )
table( woutMETAL1 %in% woutMETAL2 )
woutMETAL1[which(!(woutMETAL1 %in% woutMETAL2))]


outMETAL_ALL = outMETAL[ which( grepl("METAANALYSIS_1_",outMETAL) & grepl("_ALL_",outMETAL) & !grepl(".info",outMETAL)) ]
outMETAL_TE  = outMETAL[ which( grepl("METAANALYSIS_1_",outMETAL) & grepl("_TE_" ,outMETAL) & !grepl(".info",outMETAL)) ]



for ( oo in outMETAL_TE )
{

  script = c( "# Specify column separator",
              "SEPARATOR WHITESPACE",
              "# Specify analysis scheme",
              "# (STDERR for inverse-variance fixed-effects)",
              "# (or SAMPLESIZE for weighted Z-score)",
              "SCHEME STDERR",
              "# Specify column headers",
              "MARKERLABEL MarkerName",
              "ALLELELABELS Allele1 Allele2",
              "EFFECTLABEL Effect",
              "STDERRLABEL StdErr",
              "FREQLABEL Freq1",
              "",
              "CUSTOMVARIABLE TotalTESampleSize",
              "CUSTOMVARIABLE Freq1",
              "CUSTOMVARIABLE FreqSE",
              "CUSTOMVARIABLE HetPVal",
              "",
              "# For I,V: use genomic control correction (Be sure to use genomic-correction for all primary-study files)",
              "GENOMICCONTROL  ON",
              #"GENOMICCONTROL LIST /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/ReferenceFiles/Metabochip_QT_SNPs_MarkerName_LIST.txt",
              "",
              "# Process the metal output file",
              paste("PROCESS",oo),
              "",
              "#Set output file prefix and suffix",
              paste("OUTFILE",sub("_1.tbl.gz"," .tbl",sub("METAANALYSIS_1_","METAANALYSIS_2_",oo))),  # 2b
              "",
              "#turn verbose mode on",
              "VERBOSE ON",
              "ANALYZE",
              "QUIT"
            )

  write.table( cbind(script) , sub("_1.tbl.gz","",sub("METAL_results/METAANALYSIS_1_","METAL_scripts/METAL_script_2_",oo)) , quote=F , row.names=F , col.names=F ) # 2b
  rm(script)
} ; rm(oo)



cd METAL_scripts/
#for ss in `ls -1 METAL_script_2b_*`; do bsub -G t35_magic -P t35_magic  -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.err -R"select[mem>20000] rusage[mem=20000]" -M20000 "/software/team35/METAL-2011-03-25/generic-metal/executables/metal /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_scripts/$ss"; done
#for ss in METAL_script_2c_AA_FGluadjBMI_Raw; do bsub -G t35_magic -P t35_magic  -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.err -R"select[mem>20000] rusage[mem=20000]" -M20000 "/software/team35/METAL-2011-03-25/generic-metal/executables/metal /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_scripts/$ss"; done
#for ss in METAL_script_2_EA_2hrGluadjBMI_Raw; do bsub -G t35_magic -P t35_magic  -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.err -R"select[mem>20000] rusage[mem=20000]" -M20000 "/software/team35/METAL-2011-03-25/generic-metal/executables/metal /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_scripts/$ss"; done
cd METAL_scripts/
#for ss in METAL_script_2_ALL_*; do bsub -G t35_magic -P t35_magic  -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.err -R"select[mem>20000] rusage[mem=20000]" -M20000 "/software/team35/METAL-2011-03-25/generic-metal/executables/metal /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_scripts/$ss"; done
for ss in METAL_script_2_TE_*; do bsub -G t35_magic -P t35_magic  -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.err -R"select[mem>20000] rusage[mem=20000]" -M20000 "/software/team35/METAL-2011-03-25/generic-metal/executables/metal /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_scripts/$ss"; done
cd ../

bjobs | grep Raw | wc
bjobs | grep InvNorm | wc
bjobs | grep normal | wc
grep "Completed meta-analysis" METAL_bsubs/*_2_ALL_* |wc
grep Success METAL_bsubs/*_2_ALL_* |wc
grep CRASHED METAL_bsubs/*_2_ALL_* |wc
grep "Max Memory" METAL_bsubs/*_2_ALL_*

grep "Completed meta-analysis" METAL_bsubs/*_2_TE_* |wc
grep Success METAL_bsubs/*_2_TE_* |wc
grep CRASHED METAL_bsubs/*_2_TE_* |wc
grep "Max Memory" METAL_bsubs/*_2_TE_*


ls -1 METAL_results

cd METAL_results/
for ff in `ls -1 *.tbl`; do bgzip $ff; done
cd ../


mkdir Gaelle_2hrGluadjBMI_Raw
mkdir Gaelle_HbA1cadjFGlu_Raw
mkdir Gaelle_FGluadjBMI_Raw

put /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_results/METAANALYSIS_2_*2hrGluadjBMI*gz /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_METAL_Results/Gaelle_2hrGluadjBMI_Raw/
put /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_results/METAANALYSIS_2_*HbA1cadjFGlu*gz /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_METAL_Results/Gaelle_HbA1cadjFGlu_Raw/
put /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_results/METAANALYSIS_2_*FGluadjBMI_*gz  /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_METAL_Results/Gaelle_FGluadjBMI_Raw/
put /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_results/METAANALYSIS_1*2hrGluadjBMI*info /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_METAL_Results/Gaelle_2hrGluadjBMI_Raw/
put /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_results/METAANALYSIS_1*HbA1cadjFGlu*info /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_METAL_Results/Gaelle_HbA1cadjFGlu_Raw/
put /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_results/METAANALYSIS_1*FGluadjBMI_*info  /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_METAL_Results/Gaelle_FGluadjBMI_Raw/
put /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_results/METAANALYSIS_2_EA_2hrGluadjBMI*gz   /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_METAL_Results/Gaelle_2hrGluadjBMI_Raw/
put /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_results/METAANALYSIS_1_EA_2hrGluadjBMI*info /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_METAL_Results/Gaelle_2hrGluadjBMI_Raw/

put /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_results/METAANALYSIS_1*2hrGluadjBMI*gz /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_METAL_Results/Gaelle_2hrGluadjBMI_Raw/


###############################################################
### RESULTS from METAL from volunteers
###############################################################

#get files from sftp
cd /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_METAL_Results/

ls -1 Ching-Ti.Jae
ls -1 Gaelle_2hrGluadjBMI_Raw
ls -1 Gaelle_FGluadjBMI_Raw
ls -1 Gaelle_HbA1cadjFGlu_Raw
ls -1 Jani_FInsadjBMI_InvNorm
ls -1 Jani_FInsadjBMI_Raw
ls -1 Laura_FInsadjBMI_InvNorm
ls -1 Laura_HbA1c_InvNorm
ls -1 Laura_HbA1c_Raw
ls -1 Sara_2hrGluadjBMI_InvNorm
ls -1 Sara_FGluadjBMI_InvNorm
ls -1 Sara_HbA1cadjFGlu_InvNorm
ls -1 Ying_HbA1c_InvNorm
ls -1 Ying_HbA1cadjFGlu_InvNorm
ls -1 Ying_HbA1cadjFGlu_Raw


#listing all results files
ListFiles01 = data.frame( Trait=c("FInsadjBMI","FInsadjBMI","FGluadjBMI","FGluadjBMI","HbA1c","HbA1c","HbA1cadjFGlu","HbA1cadjFGlu","2hrGluadjBMI","2hrGluadjBMI"),
                          Transf=c("Raw","InvNorm","Raw","InvNorm","Raw","InvNorm","Raw","InvNorm","Raw","InvNorm"),
                          Volunteer1=c("Jani","Jani","Ching-Ti/Jae","Ching-Ti/Jae","Laura","Laura","Ying","Ying","Thibaud","Thibaud"),
                          Volunteer2=c("Ching-Ti/Jae","Laura","Gaelle","Sara","Thibaud","Ying","Gaelle","Sara","Gaelle","Sara"),
                          stringsAsFactors=F)
ListFiles02 = rbind( data.frame(ListFiles01,Ancestry="AA",stringsAsFactors=F) ,
                     data.frame(ListFiles01,Ancestry="EA",stringsAsFactors=F) ,
                     data.frame(ListFiles01,Ancestry="HA",stringsAsFactors=F) ,
                     data.frame(ListFiles01,Ancestry="EAA",stringsAsFactors=F) ,
                     data.frame(ListFiles01,Ancestry="IAA",stringsAsFactors=F) )
ListFiles03 = rbind( data.frame(ListFiles02,Run=1,stringsAsFactors=F) ,
                     data.frame(ListFiles02,Run=2,stringsAsFactors=F) ,
                     data.frame(Trait=rep("HbA1c",4),Transf=c("Raw","InvNorm","Raw","InvNorm"),Volunteer1=rep("Gaelle",4),Volunteer2=rep(NA,4),Ancestry=rep("UAA",4),Run=c(1,1,2,2),stringsAsFactors=F)
                      )



ff=c( dir("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_ResFromVolunteers/Ying",full.names=T)
      ,dir("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_ResFromVolunteers/Laura",full.names=T)
      ,dir("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_ResFromVolunteers/Thibaud",full.names=T)
      ,dir("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_ResFromVolunteers/Jae",full.names=T)
      ,dir("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_ResFromVolunteers/Jani",full.names=T)
      ,dir("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_ResFromVolunteers/Sara",full.names=T)
    )
ff=ff[-grep("info",ff)]
ff=ff[-grep("metal",ff)]
ff=ff[-grep("diff",ff)]
ff=ff[-grep("log",ff)]
ff=ff[-grep("pdf",ff)]
ffg=dir("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_results",full.names=T)
ffg=ffg[ which( !grepl("METAANALYSIS_2b_",ffg) & !grepl("info",ffg))]
ffa=c(ff,ffg) ; rm(ff,ffg)
ff1 = data.frame( Path=ffa,
                  File=sapply(ffa,FUN=function(x){x1=strsplit(x,"/")[[1]] ; return(x1[length(x1)]) }) ,
                  stringsAsFactors=F)
row.names(ff1)=NULL
rm(ffa)

ff1$volunteer=NA
ff1$volunteer[grep("METAL_results",ff1$Path)]="Gaelle"
ff1$volunteer[grep("Laura",ff1$Path)]="Laura"
ff1$volunteer[grep("Sara",ff1$Path)]="Sara"
ff1$volunteer[grep("Ying",ff1$Path)]="Ying"
ff1$volunteer[grep("Jae",ff1$Path)]="Ching-Ti/Jae"
ff1$volunteer[grep("Jani",ff1$Path)]="Jani"
ff1$volunteer[grep("Thibaud",ff1$Path)]="Thibaud"

ff1$Ancestry=NA
ff1$Ancestry[grep("AA_",ff1$File)]="AA"
ff1$Ancestry[grep("_AA",ff1$File)]="AA"
ff1$Ancestry[grep("EA_",ff1$File)]="EA"
ff1$Ancestry[grep("_EA",ff1$File)]="EA"
ff1$Ancestry[grep("HA_",ff1$File)]="HA"
ff1$Ancestry[grep("_HA",ff1$File)]="HA"
ff1$Ancestry[grep("EAA_",ff1$File)]="EAA"
ff1$Ancestry[grep("_EAA",ff1$File)]="EAA"
ff1$Ancestry[grep("IAA_",ff1$File)]="IAA"
ff1$Ancestry[grep("_IAA",ff1$File)]="IAA"
ff1$Ancestry[grep("_UAA",ff1$File)]="UAA"

ff1$Trait=NA
ff1$Trait[grep("FGluadjBMI",ff1$File)]="FGluadjBMI"
ff1$Trait[grep("FInsadjBMI",ff1$File)]="FInsadjBMI"
ff1$Trait[grep("2hrGluadjBMI",ff1$File)]="2hrGluadjBMI"
ff1$Trait[grep("HbA1c",ff1$File)]="HbA1c"
ff1$Trait[grep("HbA1cadjFGlu",ff1$File)]="HbA1cadjFGlu"

ff1$Transf=NA
ff1$Transf[grep("Raw",ff1$File,ignore.case=T)]="Raw"
ff1$Transf[grep("InvNorm",ff1$File,ignore.case=T)]="InvNorm"
ff1$Transf[which( ff1$volunteer=="Jani" & !grepl("Raw",ff1$File))]="InvNorm"

ff1$Run=NA
ff1$Run[which(grepl("METAL_results",ff1$Path) & grepl("_1_",ff1$File))]=1
ff1$Run[which(grepl("METAL_results",ff1$Path) & grepl("_2_",ff1$File))]=2
ff1$Run[which(grepl("Ying",ff1$Path) & grepl("_1_",ff1$File))]=1
ff1$Run[which(grepl("Ying",ff1$Path) & grepl("_2_",ff1$File))]=2
ff1$Run[which(grepl("Jae",ff1$Path) & grepl("2GC",ff1$File))]=2
ff1$Run[which(grepl("Jani",ff1$Path) & !grepl("pass2",ff1$File))]=1
ff1$Run[which(grepl("Jani",ff1$Path) & grepl("pass2",ff1$File))]=2
ff1$Run[which(grepl("Laura",ff1$Path) & grepl("GCadjusted_LC",ff1$File))]=2
ff1$Run[which(grepl("Laura",ff1$Path) & !grepl("GCadjusted_LC",ff1$File))]=1
ff1$Run[which(grepl("Sara",ff1$Path) & grepl("2nd",ff1$File))]=2
ff1$Run[which(grepl("Sara",ff1$Path) & !grepl("2nd",ff1$File))]=1



ListFiles04 = merge( ListFiles03 , ff1 , by.x=c("Volunteer1","Trait","Transf","Ancestry","Run") , by.y=c("volunteer","Trait","Transf","Ancestry","Run") , all.x=T)
colnames(ListFiles04)[which(colnames(ListFiles04)=="Path")]="Path1"
colnames(ListFiles04)[which(colnames(ListFiles04)=="File")]="File1"
ListFiles = merge( ListFiles04 , ff1 , by.x=c("Volunteer2","Trait","Transf","Ancestry","Run") , by.y=c("volunteer","Trait","Transf","Ancestry","Run") , all.x=T)
colnames(ListFiles)[which(colnames(ListFiles)=="Path")]="Path2"
colnames(ListFiles)[which(colnames(ListFiles)=="File")]="File2"

save(ListFiles,file="/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/ListFiles.RData")


ww=which(!is.na(ListFiles$Path1) & !is.na(ListFiles$Path2) & ListFiles$Run==2)
table(ListFiles$Transf[ww],ListFiles$Ancestry[ww],ListFiles$Trait[ww])


wwMiss = which(is.na(ListFiles$Path1) & is.na(ListFiles$Path2))
table(ListFiles$Transf[wwMiss],ListFiles$Ancestry[wwMiss],ListFiles$Trait[wwMiss]) # 2hrGluadjBMI IAA : no study --> no m-a!


# Add in the list the overall analysis results path (pooling all cohorts from all ancestries together, ancestry labeled as "ALL")
# Add in the list the trans-ethnic analysis results path (taking each ancestry-specific m-a results as input, ancestry labeled as "TE")
load("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/ListFiles.RData")


ListFilesb1 = data.frame( Trait=c("FInsadjBMI","FInsadjBMI","FGluadjBMI","FGluadjBMI","HbA1c","HbA1c","HbA1cadjFGlu","HbA1cadjFGlu","2hrGluadjBMI","2hrGluadjBMI"),
                          Transf=c("Raw","InvNorm","Raw","InvNorm","Raw","InvNorm","Raw","InvNorm","Raw","InvNorm"),
                          Volunteer1="Gaelle",
                          Volunteer2=NA,
                          stringsAsFactors=F)
ListFilesb2 = rbind( data.frame(ListFilesb1,Ancestry="ALL",stringsAsFactors=F) ,
                     data.frame(ListFilesb1,Ancestry="TE",stringsAsFactors=F)
                    )
ListFilesb3 = rbind( data.frame(ListFilesb2,Run=1,stringsAsFactors=F) ,
                     data.frame(ListFilesb2,Run=2,stringsAsFactors=F)
                      )


ffg=dir("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_results",full.names=T)
ffg=ffg[ which( ( grepl("_ALL_",ffg) | grepl("_TE_",ffg) ) &  !grepl("info",ffg))]
ff1 = data.frame( Path=ffg,
                  File=sapply(ffg,FUN=function(x){x1=strsplit(x,"/")[[1]] ; return(x1[length(x1)]) }) ,
                  stringsAsFactors=F)
row.names(ff1)=NULL
rm(ffg)

ff1$Ancestry=NA
ff1$Ancestry[grep("_ALL_",ff1$File)]="ALL"
ff1$Ancestry[grep("_TE_",ff1$File)]="TE"

ff1$Trait=NA
ff1$Trait[grep("FGluadjBMI",ff1$File)]="FGluadjBMI"
ff1$Trait[grep("FInsadjBMI",ff1$File)]="FInsadjBMI"
ff1$Trait[grep("2hrGluadjBMI",ff1$File)]="2hrGluadjBMI"
ff1$Trait[grep("HbA1c",ff1$File)]="HbA1c"
ff1$Trait[grep("HbA1cadjFGlu",ff1$File)]="HbA1cadjFGlu"

ff1$Transf=NA
ff1$Transf[grep("Raw",ff1$File,ignore.case=T)]="Raw"
ff1$Transf[grep("InvNorm",ff1$File,ignore.case=T)]="InvNorm"

ff1$Run=NA
ff1$Run[which(grepl("METAL_results",ff1$Path) & grepl("_1_",ff1$File))]=1
ff1$Run[which(grepl("METAL_results",ff1$Path) & grepl("_2_",ff1$File))]=2


ListFilesb4 = merge( ListFilesb3 , ff1 , by.x=c("Trait","Transf","Ancestry","Run") , by.y=c("Trait","Transf","Ancestry","Run") , all.x=T)
colnames(ListFilesb4)[which(colnames(ListFilesb4)=="Path")]="Path1"
colnames(ListFilesb4)[which(colnames(ListFilesb4)=="File")]="File1"
ListFilesb4$Path2=NA
ListFilesb4$File2=NA
rm(ListFilesb1,ListFilesb2,ListFilesb3,ff1)

table( colnames(ListFilesb4) %in% colnames(ListFiles) )
table( colnames(ListFiles) %in% colnames(ListFilesb4) )

ListFiles2 = rbind( ListFiles , ListFilesb4[colnames(ListFiles)] )
rm(ListFiles,ListFilesb4) ; ListFiles=ListFiles2 ; rm(ListFiles2)



save(ListFiles,file="/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/ListFiles_withALLandTEanalyses.RData")










# --> R script for comparison: /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/PairComp_Feb2016.R

#for x in AA EA EAA HA IAA; do for y in HbA1cadjFGlu FGluadjBMI; do for z in Raw; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/bsub.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/bsub.$x.$y.$z.err -R"select[mem>40000]  rusage[mem=40000]"  -M40000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/PairComp_Feb2016.R"; done; done; done
#for x in AA EA EAA HA IAA; do for y in HbA1c; do for z in InvNorm;               do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/bsub.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/bsub.$x.$y.$z.err -R"select[mem>40000]  rusage[mem=40000]"  -M40000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/PairComp_Feb2016.R"; done; done; done

#for x in AA EA EAA HA IAA; do for y in FInsadjBMI; do for z in InvNorm Raw; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/bsub.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/bsub.$x.$y.$z.err -R"select[mem>40000]  rusage[mem=40000]"  -M40000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/PairComp_Feb2016.R"; done; done; done

#for x in AA EA EAA HA IAA; do for y in HbA1cadjFGlu FGluadjBMI; do for z in InvNorm; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/bsub.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/bsub.$x.$y.$z.err -R"select[mem>40000]  rusage[mem=40000]"  -M40000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/PairComp_Feb2016.R"; done; done; done

for x in AA EA EAA HA IAA; do for y in HbA1c; do for z in Raw;                       do bsub -q hugemem -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/bsub.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/bsub.$x.$y.$z.err -R"select[mem>40000]  rusage[mem=40000]"  -M40000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/PairComp_Feb2016.R"; done; done; done
for x in AA EA EAA HA; do for y in 2hrGluadjBMI; do for z in InvNorm Raw; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/bsub.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/bsub.$x.$y.$z.err -R"select[mem>40000]  rusage[mem=40000]"  -M40000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/PairComp_Feb2016.R"; done; done; done


bjobs -l | grep "MAX MEM"
tail -n2 METAL_VolunteersComparison/bsub.*HbA1cadjFGlu.InvNorm.out
tail -n2 METAL_VolunteersComparison/bsub.*FGluadjBMI.InvNorm.out
grep Success METAL_VolunteersComparison/bsub.*HbA1cadjFGlu.InvNorm.out
grep Success METAL_VolunteersComparison/bsub.*FGluadjBMI.InvNorm.out

###############################################################
### Run trans-ethnic METAL with inputs being teh ancestry-specific METAL outputs
###############################################################

load("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/ListFiles.RData")

wwToDo = which(ListFiles$Run==2 & !(is.na(ListFiles$Path1) & is.na(ListFiles$Path2)) )
table(ListFiles$Transf[wwToDo],ListFiles$Ancestry[wwToDo],ListFiles$Trait[wwToDo])


toRun = rbind( c(A="TE" , T="2hrGluadjBMI" , F="Raw") ,
               c(A="TE" , T="FGluadjBMI"   , F="Raw") ,
               c(A="TE" , T="HbA1cadjFGlu" , F="Raw") ,
               c(A="TE" , T="FInsadjBMI"   , F="Raw") ,
               c(A="TE" , T="HbA1c"        , F="Raw") ,
               c(A="TE" , T="HbA1c"        , F="InvNorm") ,
               c(A="TE" , T="2hrGluadjBMI" , F="InvNorm") ,
               c(A="TE" , T="FGluadjBMI"   , F="InvNorm") ,
               c(A="TE" , T="HbA1cadjFGlu" , F="InvNorm") ,
               c(A="TE" , T="FInsadjBMI"   , F="InvNorm")
             )

for ( i in 1:nrow(toRun) )
{
  aa = toRun[i,"A"]
  tt = toRun[i,"T"]
  tf = toRun[i,"F"]
  cat("--------------------------\n",aa,tt,tf,"\n--------------------------\n")

  ww = which( ListFiles$Run==2 & !(is.na(ListFiles$Path1) & is.na(ListFiles$Path2)) & ListFiles$Trait==tt & ListFiles$Transf==tf)

  for ( wwi in ww )
  {
   cat(ListFiles$Ancestry[wwi],"-- Volunteers are 1:",ListFiles$Volunteer1[wwi],"and 2:",ListFiles$Volunteer2[wwi],"\n")
   if( !is.na(ListFiles$Path1[wwi]) & !is.na(ListFiles$Path2[wwi]) )
   {
    set.seed(7787*wwi*wwi) ; PathVol = sample(c("Path1","Path2"),1)
   } else { if( !is.na(ListFiles$Path1[wwi]) ) {PathVol="Path1"} else {PathVol="Path2"} }
   Pathin = ListFiles[wwi,PathVol]
   cat("Output used from",PathVol,":",Pathin,"\n")

   if (wwi==ww[1])
   {
    script=c("# === START ===",
             "SCHEME STDERR",
             "# === DESCRIBE AND PROCESS THE INPUT FILES ===",
             "SEPARATOR WHITESPACE",
             "MARKERLABEL MarkerName",
             "ALLELELABELS Allele1 Allele2",
             "EFFECTLABEL Effect",
             "STDERRLABEL StdErr",
             "AVERAGEFREQ ON",
             "MINMAXFREQ ON",
             "FREQLABEL Freq1",
             "CUSTOMVARIABLE  TotalTESampleSize",
             "LABEL TotalTESampleSize as TotalSampleSize",
             "GENOMICCONTROL OFF",
             paste("PROCESS",Pathin),
             ""
            )
   } else { script = c( script ,
                        paste("PROCESS",Pathin), "" ) }

   rm(PathVol,Pathin)
  } ; rm(wwi)
  script = c( script ,
              "# === ANALYSE ===",
              paste("OUTFILE /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_results/METAANALYSIS_1",aa,tt,tf," .tbl",sep="_"),
              "ANALYZE HETEROGENEITY" )

  write.table( cbind(script) , paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_scripts/METAL_script_1",aa,tt,tf,sep="_") , quote=F , row.names=F , col.names=F )
  rm(aa,tt,tf,ww,script)
} ; rm(i) ; cat("Done.\n")



cd METAL_scripts/
for ss in `ls -1 METAL_script_1_TE*`; do bsub -G t35_magic -P t35_magic  -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_$ss.err -R"select[mem>20000] rusage[mem=20000]" -M20000 "/software/team35/METAL-2011-03-25/generic-metal/executables/metal /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_scripts/$ss"; done
cd ../

grep "Completed meta-analysis" METAL_bsubs/*_1_TE* |wc
grep Success METAL_bsubs/*_1_TE* |wc
grep CRASHED METAL_bsubs/*_1_TE* |wc
grep "Max Memory" METAL_bsubs/*_1_TE*

ls -1 METAL_results

cd METAL_results/
ls -1 *.tbl
for ff in `ls -1 *.tbl`; do echo $ff; bgzip $ff; done
cd ../



###############################################################
### RESULTS from METAL for MANTRA : Order by MarkerName and keep a subset of the columns for Andrew to create MANTRA inputs
###############################################################


load("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/ListFiles.RData")

wwDone = which(ListFiles$Run==2 & !(is.na(ListFiles$Path1) & is.na(ListFiles$Path2)))
table(ListFiles$Transf[wwDone],ListFiles$Ancestry[wwDone],ListFiles$Trait[wwDone])

wwToOrder = which(ListFiles$Run==2 & !(is.na(ListFiles$Path1) & is.na(ListFiles$Path2)) & ListFiles$Trait!="2hrGluadjBMI")
table(ListFiles$Transf[wwToOrder],ListFiles$Ancestry[wwToOrder],ListFiles$Trait[wwToOrder])

wwToOrder = which(ListFiles$Run==2 & !(is.na(ListFiles$Path1) & is.na(ListFiles$Path2)) & ListFiles$Trait=="FInsadjBMI" & ListFiles$Ancestry=="EA")
table(ListFiles$Transf[wwToOrder],ListFiles$Ancestry[wwToOrder],ListFiles$Trait[wwToOrder])

wwToOrder = which(ListFiles$Run==2 & !(is.na(ListFiles$Path1) & is.na(ListFiles$Path2)) & ListFiles$Trait=="2hrGluadjBMI" & ListFiles$Transf=="Raw" & ListFiles$Ancestry=="EA")
table(ListFiles$Transf[wwToOrder],ListFiles$Ancestry[wwToOrder],ListFiles$Trait[wwToOrder])


# create and submit the bsub command through R
for ( i in wwToOrder)
{
 cat("---------------------------------------------------\n")
 cat("--->",ListFiles$Trait[i],"-",ListFiles$Transf[i],"-",ListFiles$Ancestry[i],"\n")
 cat("Volunteers are 1:",ListFiles$Volunteer1[i],"and 2:",ListFiles$Volunteer2[i],"\n")
 if( !is.na(ListFiles$Path1[i]) & !is.na(ListFiles$Path2[i]) )
 {
  set.seed(7787*i*i) ; PathVol = sample(c("Path1","Path2"),1)
 } else { if( !is.na(ListFiles$Path1[i]) ) {PathVol="Path1"} else {PathVol="Path2"} }
 Pathin = ListFiles[i,PathVol]
 cat("Output used from",PathVol,"\n")
 Pathout = paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_orderingForMANTRA/metal",ListFiles$Trait[i],ListFiles$Transf[i],ListFiles$Ancestry[i],"dat.gz",sep=".")
 ll = paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_orderingForMANTRA/bsub",ListFiles$Trait[i],ListFiles$Transf[i],ListFiles$Ancestry[i],sep=".")
 command = paste("bsub -q normal -G t35_magic -o ",ll,".out -e ",ll,".err -R\"select[mem>50]  rusage[mem=50]\"  -M50 \"zcat ",Pathin," | cut -f1-5,8,9 | sort -n | bgzip -c > ",Pathout,"\"",sep="")
 #print(command)
 system(command)
 rm(PathVol,Pathin,Pathout,ll,command)
} ; rm(i)



bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_orderingForMANTRA/bsub.HbA1c.InvNorm.UA.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_orderingForMANTRA/bsub.HbA1c.InvNorm.UA.err -R"select[mem>50]  rusage[mem=50]"  -M50 "zcat /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_results/METAANALYSIS_2_UAA_HbA1c_InvNorm1.tbl.gz | cut -f1-5,8,9 | sort -n | bgzip -c > /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_orderingForMANTRA/metal.HbA1c.InvNorm.UA.dat.gz"
bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_orderingForMANTRA/bsub.HbA1c.Raw.UA.out     -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_orderingForMANTRA/bsub.HbA1c.Raw.UA.err     -R"select[mem>50]  rusage[mem=50]"  -M50 "zcat /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_results/METAANALYSIS_2_UAA_HbA1c_Raw1.tbl.gz     | cut -f1-5,8,9 | sort -n | bgzip -c > /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_orderingForMANTRA/metal.HbA1c.Raw.UA.dat.gz"






grep Success /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_orderingForMANTRA/bsub*2hrGlu*


put /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_orderingForMANTRA/metal.2hrGluadjBMI.Raw.EA.dat.gz /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_METAL_Results/Reordered_METAL_results/




###############################################################
### RESULTS from METAL for GCTA : Keep a subset of the columns to use as inputs for GCTA
###############################################################


load("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/ListFiles.RData")

wwDone = which(ListFiles$Run==2 & !(is.na(ListFiles$Path1) & is.na(ListFiles$Path2)))
table(ListFiles$Transf[wwDone],ListFiles$Ancestry[wwDone],ListFiles$Trait[wwDone])

wwToOrder = which(ListFiles$Run==2 & !(is.na(ListFiles$Path1) & is.na(ListFiles$Path2)) & ListFiles$Transf=="InvNorm" & ListFiles$Transf!="HbA1cadjFGlu")
table(ListFiles$Transf[wwToOrder],ListFiles$Ancestry[wwToOrder],ListFiles$Trait[wwToOrder])



# create and submit the bsub command through R
for ( i in wwToOrder)
{
 cat("---------------------------------------------------\n")
 cat("--->",ListFiles$Trait[i],"-",ListFiles$Transf[i],"-",ListFiles$Ancestry[i],"\n")
 cat("Volunteers are 1:",ListFiles$Volunteer1[i],"and 2:",ListFiles$Volunteer2[i],"\n")
 if( !is.na(ListFiles$Path1[i]) & !is.na(ListFiles$Path2[i]) )
 {
  set.seed(7787*i*i) ; PathVol = sample(c("Path1","Path2"),1)
 } else { if( !is.na(ListFiles$Path1[i]) ) {PathVol="Path1"} else {PathVol="Path2"} }
 Pathin = ListFiles[i,PathVol]
 cat("Output used from",PathVol,"\n")
 Pathout = paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_reformatForGCTA/metal",ListFiles$Trait[i],ListFiles$Transf[i],ListFiles$Ancestry[i],"ma.gz",sep=".")
 ll = paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_reformatForGCTA/bsub",ListFiles$Trait[i],ListFiles$Transf[i],ListFiles$Ancestry[i],sep=".")
 command = paste("bsub -q normal -G t35_magic -o ",ll,".out -e ",ll,".err -R\"select[mem>50]  rusage[mem=50]\"  -M50 \"zcat ",Pathin," | awk '{ print \\$1\\\"\\t\\\"toupper(\\$2)\\\"\\t\\\"toupper(\\$3)\\\"\\t\\\"\\$9\\\"\\t\\\"\\$4\\\"\\t\\\"\\$5\\\"\\t\\\"\\$6\\\"\\t\\\"\\$8}' | bgzip -c > ",Pathout,"\"",sep="")
 #print(command)
 system(command)
 rm(PathVol,Pathin,Pathout,ll,command)
} ; rm(i)


grep Success /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_reformatForGCTA/bsub*

put /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_reformatForGCTA/metal.*.ma.gz /cleaned_gluinsrelatedtraits/MetaAnalysis_February2016_METAL_Results/Reformatted_METAL_results_for_GCTA/






###############################################################
### RESULTS from METAL for IPA: MarkerName, Che, Pos, P-value<1e-5
###############################################################




load("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/ListFiles.RData")

wwDone = which(ListFiles$Run==2 & !(is.na(ListFiles$Path1) & is.na(ListFiles$Path2)))
table(ListFiles$Transf[wwDone],ListFiles$Ancestry[wwDone],ListFiles$Trait[wwDone])

wwToOrder = which(ListFiles$Run==2 & !(is.na(ListFiles$Path1) & is.na(ListFiles$Path2)) & ListFiles$Transf=="InvNorm" & ListFiles$Trait!="HbA1cadjFGlu")
table(ListFiles$Transf[wwToOrder],ListFiles$Ancestry[wwToOrder],ListFiles$Trait[wwToOrder])


# create and submit the bsub command through R
for ( i in wwToOrder)
{
 cat("---------------------------------------------------\n")
 cat("--->",ListFiles$Trait[i],"-",ListFiles$Transf[i],"-",ListFiles$Ancestry[i],"\n")
 cat("Volunteers are 1:",ListFiles$Volunteer1[i],"and 2:",ListFiles$Volunteer2[i],"\n")
 if( !is.na(ListFiles$Path1[i]) & !is.na(ListFiles$Path2[i]) )
 {
  set.seed(7787*i*i) ; PathVol = sample(c("Path1","Path2"),1)
 } else { if( !is.na(ListFiles$Path1[i]) ) {PathVol="Path1"} else {PathVol="Path2"} }
 Pathin = ListFiles[i,PathVol]
 cat("Output used from",PathVol,"\n")
 Pathout = paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_ForIPA/metal.ForIPA",ListFiles$Trait[i],ListFiles$Transf[i],ListFiles$Ancestry[i],"txt.gz",sep=".")
 ll = paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_ForIPA/bsub.IPA",ListFiles$Trait[i],ListFiles$Transf[i],ListFiles$Ancestry[i],sep=".")
 command = paste("bsub -q normal -G t35_magic -o ",ll,".out -e ",ll,".err -R\"select[mem>50]  rusage[mem=50]\"  -M50 \"zcat ",Pathin," | awk '{   if(NR==1) { print \\\"SNP\\tChr\\tPos\\tP\\\" } else { if(\\$6<=0.00001) {split(\\$1,a,\\\":\\\") ; if(a[1]==\\\"X\\\") {a[1]=23} ; if(a[1]==\\\"Y\\\") {a[1]=24} ; if(a[1]==\\\"XY\\\") {a[1]=25} ; print \\$1\\\"\\t\\\"a[1]\\\"\\t\\\"a[2]\\\"\\t\\\"\\$6}}}' | bgzip -c > ",Pathout,"\"",sep="")
 #print(command)
 system(command)
 rm(PathVol,Pathin,Pathout,ll,command)
} ; rm(i)



grep Success /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_ForIPA/bsub*



library("biomaRt")


hb.ea = read.table(gzfile("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_ForIPA/metal.ForIPA.HbA1c.InvNorm.EA.txt.gz"),as.is=T,h=T)
fi.aa = read.table(gzfile("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_ForIPA/metal.ForIPA.FInsadjBMI.InvNorm.AA.txt.gz"),as.is=T,h=T)


hb.ea$ChrReg = paste( hb.ea$Chr , hb.ea$Pos , hb.ea$Pos , sep=":" )


ensembl = useMart(biomart = "ENSEMBL_MART_SNP",dataset="hsapiens_snp", host = "feb2014.archive.ensembl.org")

out = getBM(attributes = c('chr_name','chrom_start','allele','refsnp_id','ucsc_id_20137'), filters='chromosomal_region', values = hb.ea$ChrReg[1:5], mart = ensembl)


metal_withRS = vector("list",20)
nn=0
for ( x in c("FInsadjBMI","2hrGluadjBMI","FGluadjBMI","HbA1c") )
{
 cat(x,": ")
 for ( z in c("AA","EA","EAA","HA","IAA","UAA") )
 {
  if ( !(x=="2hrGluadjBMI" & z=="IAA") & !(z=="UAA" & x!="HbA1c") )
  {
   cat(z)
   nn=nn+1
   inp = read.table(gzfile(paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_ForIPA/metal.ForIPA.",x,".InvNorm.",z,".txt.gz",sep="")),as.is=T,h=T)
   cat(" (",nrow(inp),") .. ",sep="")
   inp$ChrReg = paste( inp$Chr , inp$Pos , inp$Pos , sep=":" )
   out = getBM(attributes = c('chr_name','chrom_start','refsnp_id','ucsc_id_20137'), filters='chromosomal_region', values = inp$ChrReg, mart = ensembl)
   colnames(out)[1:2] = c("Chr","Pos")
   fin = merge( inp , out , by=c("Chr","Pos") , all=T )
   metal_withRS[[nn]] = fin
   names(metal_withRS)[nn] = paste(x,z,sep="_")
   rm(inp,out,fin)
   save(metal_withRS,file="/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_ForIPA/metal.ForIPA.all.SNPids.RData")
  }
 } ; rm(z) ; cat("Done. \n")
} ; rm(x,nn)


load("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_ForIPA/metal.ForIPA.all.SNPids.RData")

sapply( metal_withRS , FUN=nrow )

head(metal_withRS[["HbA1c_EA"]])

summary(as.numeric(table(metal_withRS[["HbA1c_EA"]]$SNP)))

t(sapply( metal_withRS , FUN=function(x){x1=unique(x[,c(3,4,6)]) ; return(c( length(unique(x1$SNP)) , sum(is.na(x1$refsnp_id)) , length(unique(x1$SNP[which(duplicated(x1$SNP))])) ))} ))


for ( x in c("FInsadjBMI","2hrGluadjBMI","FGluadjBMI","HbA1c") )
{
 cat(x,": ")
 for ( z in c("AA","EA","EAA","HA","IAA","UAA") )
 {
  if ( !(x=="2hrGluadjBMI" & z=="IAA") & !(z=="UAA" & x!="HbA1c") )
  {
   cat(z,".. ")
   tp1 = metal_withRS[[paste(x,z,sep="_")]]
   tp2 = unique(tp1[which(!is.na(tp1$refsnp_id)),c(1,2,3,4,6)])
   tp3 = tp2[ which( !(tp2$SNP %in% tp2$SNP[which(duplicated(tp2$SNP))]) ) ,]
   write.table( tp3[,c("Chr","Pos","refsnp_id","P")] , paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_ForIPA/metal.ForIPA.rsids.",x,".InvNorm.",z,".txt",sep="") , quote=F , row.names=F , sep="\t")
   rm(tp1,tp2,tp3)
  }
 } ; rm(z) ; cat("Done. \n")
} ; rm(x)




###############################################################
### METAL second run : Overall GC vs QT SNPs GC for the few analyses I ran
###############################################################

gc1 = system("grep \"Genomic control parameter\" /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_METAL_script_2*out",inter=T)
gc1 = sub("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/","",gc1)

FUNgc = function(x)
{
 x1 = strsplit(x,":")[[1]]
 x2 = strsplit(x1[1],"_")[[1]]
 gcvalue = strsplit(sub("## Genomic control parameter is ","",x1[2]),",")[[1]][1]
 gcmeth = ifelse( x2[4]=="2b" , yes="QTsnps" , no="Overall" )
 ancestry = x2[5]
 trait = x2[6]
 transf = sub(".out","",x2[7])
 return( c(ancestry=ancestry,trait=trait,transf=transf,gcmeth=gcmeth,gcvalue=gcvalue) )
}

gc2 = data.frame( t(sapply(gc1,FUN=FUNgc)) , stringsAsFactors=F ) ; row.names(gc2)=NULL
gc2$gcvalue = as.numeric(gc2$gcvalue)

gc3 = merge( gc2[which(gc2$gcmeth=="Overall"),] , gc2[which(gc2$gcmeth=="QTsnps"),] , by=c("ancestry","trait","transf") )

plot( gc3$gcvalue.x , gc3$gcvalue.y , xlab="Overall GC" , ylab="QT SNPs GC" ,
      col=ifelse(gc3$ancestry=="AA",yes="green3",no=ifelse(gc3$ancestry=="EA",yes="blue",no=ifelse(gc3$ancestry=="EAA",yes="red",no=ifelse(gc3$ancestry=="HA",yes="orange",no=ifelse(gc3$ancestry=="IAA",yes="purple",no="green4"))))) ,
      pch=ifelse( gc3$transf=="Raw" , yes=ifelse(gc3$trait=="FGluadjBMI",yes=21,no=ifelse(gc3$trait=="2hrGluadjBMI",yes=22,no=ifelse(gc3$trait=="HbA1cadjFGlu",yes=24,no=3))) , no=ifelse(gc3$trait=="FGluadjBMI",yes=19,no=ifelse(gc3$trait=="2hrGluadjBMI",yes=15,no=ifelse(gc3$trait=="HbA1cadjFGlu",yes=17,no=8))) ),
      xlim=c(0.9,1.2),ylim=c(0.9,1.2),
      main="Double-GC on second run of METAL: Overall vs QT SNPs"
    ) ; abline(0,1)
legend("bottomleft",legend=c("AA","EA","HA","EAA","IAA","UAA","FGluadjBMI-Raw","FGluadjBMI-InvNorm","2hrGluadjBMI-Raw","2hrGluadjBMI-InvNorm","HbA1cadjFGlu-Raw","HbA1cadjFGlu-InvNorm","HbA1c-Raw","HbA1c-InvNorm"),
                    col=c("green3","blue","orange","red","purple","green4",rep("black",8)),
                    pch=c(rep(20,6),21,19,22,15,24,17,3,8))




###############################################################
### RESULTS from METAL : info per file from the bsub output
###############################################################

bsub = dir("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs",full.names=T)
bsub = bsub[ which( grepl("METAL_script_1",bsub) & grepl("out",bsub) ) ]

tp1 = NULL
for ( o in bsub )
{
 o2 = strsplit(sub("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_bsubs/bsub_METAL_script_1_","",sub(".out","",o)),"_")[[1]]
 cat( o2[1] , o2[2] , o2[3] , ": Read .. " )
 out = system( paste("cat",o),intern=T)
 cat("Save info ..")
 for ( i in 1:grep("Set output file",out) )
 {
  if( grepl("Processing file",out[i]) )
  {
   tp2= c( ancestry=o2[1] ,
           trait=o2[2] ,
           transf=o2[3] ,
           file=as.character(sapply(sub("## Processing file ","",gsub("\'","",out[i])),FUN=function(x){x1=strsplit(x,"/")[[1]] ; return(x1[length(x1)]) }))
         )
   mismatch=0
  }
  if( grepl("WARNING: Bad alleles",out[i]) )
  {
   mismatch=mismatch+1
  }
  if( grepl("Genomic control parameter",out[i]) )
  {
   tp2 = c( tp2 ,
            mismatches=mismatch ,
            GC=strsplit(sub("## Genomic control parameter is ","",out[i]),",")[[1]][1] ,
            GCadj=ifelse( grepl("adjusting test statistics",out[i]) , yes=1 , no=ifelse(grepl("no adjustment made",out[i]) , yes=0 , no=9)  )
          )
  }
  if( grepl("Processed",out[i]) )
  {
   tp2 = c( tp2 ,
            markers=sub(" markers ...","",sub("## Processed ","",out[i]))
          )
   tp1 = rbind( tp1 , tp2 )
   rm(tp2)
  }
 } ; rm(i,out,o2,mismatch)
 cat("Done.\n")
} ; rm(o)

tp1 = data.frame( tp1 , stringsAsFactors=F )
for ( i in 5:8 ) { tp1[,i]=as.numeric(tp1[,i]) } ; rm(i)


table( grepl("_X_",tp1$file) | grepl("_XF_",tp1$file) | grepl("_XM_",tp1$file)   , grepl("_A_",tp1$file) | grepl("_AX_",tp1$file) )

ww = which(grepl("_A_",tp1$file) | grepl("_AX_",tp1$file))
table( tp1$ancestry[ww] , tp1$trait[ww] )

summary(tp1$mismatches)

table(tp1$GCadj)
summary(tp1$GC)
summary(tp1$GC[which(tp1$GCadj==0)])
summary(tp1$GC[which(tp1$GCadj==1)])

summary(tp1$markers)




###############################################################
### RESULTS from METAL : Interpreting result file
###############################################################

x="EAA"
y="HbA1c"
z="Raw"
clump=1

#------------------------------------ R code for Interpretation
param = commandArgs(trailingOnly=T)

x=param[1]
y=param[2]
z=param[3]
clump=as.numeric(param[4])

load("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/ListFiles.RData")

summ = c(Trait=y,Transf=z,Ancestry=x)

ww1 = which(ListFiles$Ancestry==x & ListFiles$Trait==y & ListFiles$Transf==z & ListFiles$Run==1)
print(ww1)
if( length(ww1)>1){ ww1=ww1[1] }
ww2 = which(ListFiles$Ancestry==x & ListFiles$Trait==y & ListFiles$Transf==z & ListFiles$Run==2)
print(ww2)
if( length(ww2)>1){ ww2=ww2[1] }

summ = c( summ , Volunteer1=ListFiles$Volunteer1[ww1] , Volunteer2=ListFiles$Volunteer2[ww1] )

if( !is.na(ListFiles$Path1[ww1]) & !is.na(ListFiles$Path2[ww1]) & !is.na(ListFiles$Path1[ww2]) & !is.na(ListFiles$Path2[ww2]) )
{
 set.seed(7787*ww1*ww1) ; PathVol = sample(c("Path1","Path2"),1)
} else { if( !is.na(ListFiles$Path1[ww1]) & !is.na(ListFiles$Path1[ww2]) ) {PathVol="Path1"} else {PathVol="Path2"} }
summ = c( summ , PathChosen=PathVol )

# loading results
if (clump==1 | y %in% c("HbA1c","HbA1cadjFGlu") )
{
 nR = 200000 # -1
 cat("Need both METAL runs: loading first run .. ")
 ff_run1 = read.table( gzfile(ListFiles[ww1,PathVol]) , h=T , as.is=T , nrows=nR )[,c("MarkerName","Direction")]
 cat("loading second run .. ")
 ff_run2 = read.table( gzfile(ListFiles[ww2,PathVol]) , h=T , as.is=T , nrows=nR )
 cat("Checking:\n")
 print(table(ff_run1$MarkerName %in% ff_run2$MarkerName))
 print(table(ff_run2$MarkerName %in% ff_run1$MarkerName))
 cat("Merging .. ")
 ff1=merge(ff_run2,ff_run1,by="MarkerName")
 rm(ff_run2,ff_run1,PathVol,ListFiles,ww1,ww2,nR) ; gc()
 cat("Done.\n")
} else {
        nR = -1
        cat("Need only second METAL run: loading .. ")
        ff1 = read.table( gzfile(ListFiles[ww2,PathVol]) , h=T , as.is=T , nrows=nR )
        rm(PathVol,ListFiles,ww1,ww2)
        cat("Done.\n")
       }

ff1$Chr=sub(":","",substr(ff1$MarkerName,1,2))
temp = sub(":MERGED_DEL","",sub(":INDEL","",sub(":SNP","",ff1$MarkerName)))
ff1$Pos= as.numeric(ifelse( nchar(ff1$Chr)==1 , yes=sub(".:","",temp) , no=sub("..:","",temp) ))
rm(temp)


# common and non-heterogenous and good sample size variants
wwHOM = which( ff1$HetPVal>=0.00001 )
wwHOM_COMM = which( ff1$Freq1>0.05 & ff1$Freq1<0.95 & ff1$HetPVal>=0.00001 )
sampsize=max(ff1$TotalSampleSize)
goodsampsize=(sampsize/3)
wwHOM_COMM_goodsampsize = which( ff1$Freq1>0.05 & ff1$Freq1<0.95 & ff1$HetPVal>=0.00001 & ff1$TotalSampleSize>=goodsampsize )
summ = c( summ ,
          Nvariants=nrow(ff1) ,
          NheterogenousVariants=sum(ff1$HetPVal<0.00001) ,
          NhomogenousVariants=length(wwHOM) ,
          NhomogenousVariants_signif0.05=sum(ff1$HetPVal>=0.00001 & ff1$P.value<0.05) ,
          NhomogenousVariants_signif5.10m8=sum(ff1$HetPVal>=0.00001 & ff1$P.value<0.00000005) ,
          NhomogenousVariants_signif5.10m8_goodsampsize=sum(ff1$HetPVal>=0.00001 & ff1$P.value<0.00000005 & ff1$TotalSampleSize>=goodsampsize ) ,
          Ncommon_homogenous=length(wwHOM_COMM),
          MaxSampleSize=sampsize,
          ThresholdSampSize=goodsampsize,
          Ncommon_homogenous_goodsampsize=length(wwHOM_COMM_goodsampsize)
        )

# Genomic controls
qq1=qchisq(ff1$P.value,1,lower.tail=F) ; qq1=qq1[order(qq1)]
nn=length(ff1$P.value) ; pp0=seq(from=1,to=1/nn,by=(-1/nn)) ; qq0=qchisq(pp0,1,lower.tail=F) ; rm(nn,pp0)

lbd0 = median(qq1,na.rm=T)/qchisq(0.5,df=1)
lbd1 = median(qchisq(ff1$P.value[wwHOM],df=1,lower.tail=F),na.rm=T)/qchisq(0.5,df=1)
lbd2 = median(qchisq(ff1$P.value[wwHOM_COMM],df=1,lower.tail=F),na.rm=T)/qchisq(0.5,df=1)
lbd3 = median(qchisq(ff1$P.value[wwHOM_COMM_goodsampsize],df=1,lower.tail=F),na.rm=T)/qchisq(0.5,df=1)
summ = c( summ ,
          GC_all=lbd0 ,
          GC_hom=lbd1 ,
          GC_hom_common=lbd2 ,
          GC_hom_common_goodsampsize=lbd3 )

png( paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/QQplot_",x,"_",y,"_",z,".png",sep="") )
#qq.chisq.GM(qq1,slope.lambda=T,slope.one=T,genomic.control=T)
plot(qq0,qq1,xlab="Expected",ylab="Observed",main=paste(y,z,x,sep=" - ")) ; abline(0,1,lty=2,col="grey")
legend("topleft",c("Genomic Controls",paste("  Overall :",round(lbd0,4)),paste("  Homogeneous :",round(lbd1,4)),paste("   + MAF>5% :",round(lbd2,4)),paste("    + good sample size :",round(lbd3,4))))
dev.off()
rm(qq0,qq1,wwHOM,wwHOM_COMM,wwHOM_COMM_goodsampsize,sampsize,goodsampsize,lbd0,lbd1,lbd2,lbd3)

# QQ plot on Heterogeneity p-value
qq1=qchisq(ff1$HetPVal,1,lower.tail=F) ; qq1=qq1[order(qq1)]
nn=length(ff1$HetPVal) ; pp0=seq(from=1,to=1/nn,by=(-1/nn)) ; qq0=qchisq(pp0,1,lower.tail=F) ; rm(nn,pp0)
lbdH = median(qq1,na.rm=T)/qchisq(0.5,df=1)
png( paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/Heterogeneity",x,"_",y,"_",z,".png",sep=""),width=800 )
par(mfrow=c(1,2))
plot(qq0,qq1,xlab="Expected",ylab="Observed",main=paste(y,z,x,sep=" - ")) ; abline(0,1,lty=2,col="grey")
mtext(side=3,line=0.25,"QQ plot of the heterogeneity p-values")
legend("topleft",c(paste("Genomic Controls =",round(lbdH,4)),paste("N. heterogeneous variants =",sum(ff1$HetPVal<1e-05))),text.col=c("black","orange"))
abline(h=qchisq(1e-05,1,lower.tail=F),col="orange",lty=2)
rm(qq0,qq1,lbdH)
plot( -log10(ff1$HetPVal) , -log10(ff1$P.value) , xlab="-log10(Het. P)",ylab="-log10(P)" , main=paste(y,z,x,sep=" - ") )
mtext(side=3,line=0.25,"Heterogeneity p-value vs. m-a p-value")
abline(v=5,col="orange",lty=2) ; abline(h=-log10(5e-8),col="green3",lty=2)
wwL = which(ff1$HetPVal<1e-05 & ff1$P.value<5e-8)
legend("topright",paste("N. heterogeneous signals =",length(wwL)),text.col="red")
if(length(wwL)>0) { points( -log10(ff1$HetPVal[wwL]) , -log10(ff1$P.value[wwL]) , col="red") } ; rm(wwL)
dev.off()

# known loci
ff1$Known=0
if (y %in% c("HbA1c","HbA1cadjFGlu"))
{
 known=read.table("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/ReferenceFiles/known_SNPs_B37_HbA1c.txt",as.is=T,h=T,sep="\t")
 known$MarkerName = paste(known$CHR,known$POS_37,"SNP",sep=":")

 summ = c( summ ,
           NknownLociForTrait = nrow(known),
           NknownLociForTraitInFile = sum(ff1$MarkerName %in% known$MarkerName) ,
           NknownLociForTraitInFile0.05 = sum(ff1$MarkerName %in% known$MarkerName & ff1$P.value<0.05) ,
           NknownLociForTraitInFile5.10m8 = sum(ff1$MarkerName %in% known$MarkerName & ff1$P.value<5e-8)
        )

 if( sum(ff1$MarkerName %in% known$MarkerName)>0 )
 {
  known1 = merge( ff1 , known , by="MarkerName" )
  known1$Freq1_raising  = ifelse( known1$Effect_Allele==toupper(known1$Allele2) , yes=known1$Freq1 , no=ifelse(known1$Effect_Allele==toupper(known1$Allele1),yes=(1-known1$Freq1),no=NA) )
  known1$Effect_raising = ifelse( known1$Effect_Allele==toupper(known1$Allele2) , yes=known1$Effect , no=ifelse(known1$Effect_Allele==toupper(known1$Allele1),yes=-(known1$Effect),no=NA) )
  write.table(known1,paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/KnownLoci_",x,"_",y,"_",z,".txt",sep=""),quote=F,row.names=F,sep="\t")
  #png( paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/KnownLoci_",x,"_",y,"_",z,".png",sep="") , width=900 )
  #par(mfrow=c(1,2))
  #plot( known1$raising_allele_freq , known1$Freq1_raising , xlab="Expected frequency" , ylab="Observed frequency" ) ; abline(0,1)
  #plot( known1$beta , known1$Effect_raising , xlab="Expected BETA" , ylab="Observed BETA" , col=ifelse(known1$P.value<0.05,yes="red",no="black") , xlim=c(-0.01,0.1) , ylim=c(-0.01,0.1) ) ; abline(0,1)
  #dev.off()
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
         known=read.table("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/ReferenceFiles/known_SNPs_B37_OtherTraits.txt",as.is=T,h=T,sep="\t")
         if( y=="FGluadjBMI"   ) { known=known[which(known$phenotype=="fg"),] }
         if( y=="FInsadjBMI"   ) { known=known[which(substr(known$phenotype,1,2)=="fi"),] }
         if( y=="2hrGluadjBMI" ) { known=known[which(known$phenotype=="2hglu"),] }
         known$MarkerName = paste(known$chr,known$pos,"SNP",sep=":")
         summ = c( summ ,
                   NknownLociForTrait = nrow(known),
                   NknownLociForTraitInFile = sum(ff1$MarkerName %in% known$MarkerName) ,
                   NknownLociForTraitInFile0.05 = sum(ff1$MarkerName %in% known$MarkerName & ff1$P.value<0.05) ,
                   NknownLociForTraitInFile5.10m8 = sum(ff1$MarkerName %in% known$MarkerName & ff1$P.value<5e-8)
        )
        if( sum(ff1$MarkerName %in% known$MarkerName)>0 )
        {
         known1 = merge( ff1 , known , by="MarkerName" )
         known1$Freq1_raising = ifelse( known1$raising_allele==toupper(known1$Allele2) , yes=known1$Freq1 , no=ifelse(known1$raising_allele==toupper(known1$Allele1),yes=(1-known1$Freq1),no=NA) )
         known1$Effect_raising = ifelse( known1$raising_allele==toupper(known1$Allele2) , yes=known1$Effect , no=ifelse(known1$raising_allele==toupper(known1$Allele1),yes=-(known1$Effect),no=NA) )
         write.table(known1,paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/KnownLoci_",x,"_",y,"_",z,".txt",sep=""),quote=F,row.names=F,sep="\t")
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
ff1$Chr2 = as.numeric(ifelse(ff1$Chr=="X",yes=23,no=ifelse(ff1$Chr=="Y",yes=24,no=ifelse(ff1$Chr=="XY",yes=25,no=ff1$Chr))))
ff1s = ff1[order(ff1$Chr2,ff1$Pos),]
rm(ff1) ; gc()
ff1s$logP=-log10(ff1s$P.value)
maxS = max(ff1s$logP)
obslogbfmax <- trunc(max(ff1s$logP))+5
#obslogbfmax <- 80

print(maxS)
print(obslogbfmax)

x1 <- 1:25
x2<- 1:2

for (i in 1:25)
{
         curchr=which(ff1s$Chr2==i)
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
ff1s$locX = trunc(ff1s$Pos/100) + x2[ff1s$Chr2]


col1=rgb(0,0,108,maxColorValue=255)
col2=rgb(100,149,237,maxColorValue=255)
col4 <- ifelse(ff1s$Chr2%%2==0, col1, col2)

png(paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/Manhattan_beforeClumping_",x,"_",y,"_",z,".png",sep=""),height=600,width=800)
plot(ff1s$locX,ff1s$logP,pch=20,col=col4,xaxt="n",ylab="log10(p-value)",xlab="",bty="n",ylim=c(0,obslogbfmax),cex=0.8,main=paste(y,z,x,sep=" - "))
mtext(side=3,line=0.2,"Known loci ± 500kb (black) - Novel signals (red)")
abline(h=-log10(5e-8),lty=2,col="grey")
#wwC = which(ff1s$nClump > 0)
#if(length(wwC)>0) { points(ff1s$locX[wwC],ff1s$logP[wwC],pch=20,col=col3,cex=0.8) }
#wwS = which(!is.na(ff1s$GeneForSignals))
#if(length(wwS)>0)
#{
# points(ff1s$locX[wwS],ff1s$logP[wwS],pch=20,col="red",cex=0.8)
# text(ff1s$locX[wwS],ff1s$logP[wwS],ff1s$GeneForSignals[wwS],pos=3,srt=90,offset=2.5,col="red",cex=0.7)
#}
wwK = which(ff1s$Known > 0) ; if(length(wwK)>0) { points(ff1s$locX[wwK],ff1s$logP[wwK],pch=20,col="black",cex=0.8) } ; rm(wwK)
wwS = which(ff1s$P.value < 5e-8) ; if(length(wwS)>0) { points(ff1s$locX[wwS],ff1s$logP[wwS],pch=20,col="red",cex=0.8) } ; rm(wwS)
dev.off()



# ---> clump
nClump=0
if (clump==1)
{
 ff1s$nClump=0
 ff1s$GeneForSignals=NA

 genes = read.table("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/ReferenceFiles/hg19_genes.txt", col.names=c("chr","start","end","gene"), header=F,as.is=T)
 genes=unique(genes)
 ff2 = ff1s
 ClumpSignals = NULL
 # identify most significant variant sequentially
 while( min(ff2$P.value)<5e-8 )
 {
  nClump=nClump+1
  cat("--> region no",nClump,": ")
  wwS = which(ff2$P.value==min(ff2$P.value))
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

  cat("Writing .. ")
  write.table(ClumpSignals,paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/signals_500kb_",x,"_",y,"_",z,".txt",sep=""),quote=F,row.names=F,sep="\t")

  cat("Done.\n ")
 } #while < 5x10-8
 rm(genes,ff2,ClumpSignals)

 col1=rgb(0,0,108,maxColorValue=255)
 col2=rgb(100,149,237,maxColorValue=255)
 col3="green3" #rgb(0,205,102,maxColorValue=255)
 col4 <- ifelse(ff1s$Chr2%%2==0, col1, col2)
 png(paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/Manhattan_afterClumping_",x,"_",y,"_",z,".png",sep=""),height=600,width=800)
 plot(ff1s$locX,ff1s$logP,pch=20,col=col4,xaxt="n",ylab="log10(p-value)",xlab="",bty="n",ylim=c(0,obslogbfmax),cex=0.8,main=paste(y,z,x,sep=" - "))
 mtext(side=3,line=0.2,"Clumped regions (signals±500kb, black) - Known loci clumped (green) - Known loci not clumped (red)")
 abline(h=-log10(5e-8),lty=2,col="grey")
 wwC = which(ff1s$nClump > 0) ; if(length(wwC)>0) { points(ff1s$locX[wwC],ff1s$logP[wwC],pch=20,col="black",cex=0.8) } ; rm(wwC)
 wwCK = which(ff1s$Known>0 & ff1s$nClump>0) ; if(length(wwCK)>0) { points(ff1s$locX[wwCK],ff1s$logP[wwCK],pch=20,col=col3,cex=0.8) } ; rm(wwCK)
 wwNK = which(ff1s$Known>0 & ff1s$nClump==0) ; if(length(wwNK)>0) { points(ff1s$locX[wwNK],ff1s$logP[wwNK],pch=20,col="red",cex=0.8) } ; rm(wwNK)
 #wwS = which(!is.na(ff1s$GeneForSignals))
 #if(length(wwS)>0)
 #{
 # points(ff1s$locX[wwS],ff1s$logP[wwS],pch=20,col="red",cex=0.8)
 # text(ff1s$locX[wwS],ff1s$logP[wwS],ff1s$GeneForSignals[wwS],pos=3,srt=90,offset=2.5,col="red",cex=0.7)
 #}
 dev.off()

}

 summ = c( summ ,
           nClump=nClump)
rm(nClump)
save( summ , file=paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/summary_",x,"_",y,"_",z,".RData",sep=""))



#-----------------------------------------------------------------------



for x in AA EA EAA HA IAA UAA; do for y in HbA1c; do for z in InvNorm Raw;                     do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.err -R"select[mem>50000]  rusage[mem=50000]"  -M50000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z 1 < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation.R"; done; done; done
for x in EAA HA IAA ; do for y in FGluadjBMI FInsadjBMI 2hrGluadjBMI; do for z in InvNorm Raw; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.err -R"select[mem>20000]  rusage[mem=20000]"  -M20000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z 0 < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation.R"; done; done; done
for x in AA EA ;      do for y in FGluadjBMI FInsadjBMI 2hrGluadjBMI; do for z in InvNorm Raw; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.err -R"select[mem>40000]  rusage[mem=40000]"  -M40000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z 0 < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation.R"; done; done; done


for x in EAA; do for y in HbA1c; do for z in Raw;          do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.err -R"select[mem>35000]  rusage[mem=35000]"  -M35000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z 1 < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation.R"; done; done; done
for x in AA ; do for y in HbA1c; do for z in Raw;          do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.err -R"select[mem>35000]  rusage[mem=35000]"  -M35000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z 1 < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation.R"; done; done; done


for x in EAA; do for y in FInsadjBMI; do for z in InvNorm; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.err -R"select[mem>20000]  rusage[mem=20000]"  -M20000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z 0 < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation.R"; done; done; done
for x in HA ; do for y in FGluadjBMI; do for z in InvNorm; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.err -R"select[mem>20000]  rusage[mem=20000]"  -M20000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z 0 < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation.R"; done; done; done
for x in EA ; do for y in FInsadjBMI; do for z in InvNorm; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.err -R"select[mem>40000]  rusage[mem=40000]"  -M40000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z 0 < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation.R"; done; done; done
for x in IAA; do for y in FGluadjBMI; do for z in Raw    ; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.err -R"select[mem>20000]  rusage[mem=20000]"  -M20000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z 0 < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation.R"; done; done; done
for x in EA ; do for y in FGluadjBMI; do for z in InvNorm; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.err -R"select[mem>40000]  rusage[mem=40000]"  -M40000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z 0 < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation.R"; done; done; done
for x in EA ; do for y in FGluadjBMI; do for z in Raw    ; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.err -R"select[mem>40000]  rusage[mem=40000]"  -M40000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z 0 < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation.R"; done; done; done





grep exit bsub.*
grep Success bsub.* | wc
bjobs | grep normal | wc


grep "Max Mem" bsub.EAA.HbA1c.Raw.out
grep "Max Mem" bsub.EA.HbA1c.InvNorm.out
grep "Max Mem" bsub.EA.HbA1c.Raw.out
grep "Max Mem" bsub.HA.HbA1c.Raw.out
grep "Max Mem" bsub.IAA.HbA1c.Raw.out

grep "Requested" bsub.EAA.HbA1c.Raw.out
grep "Requested" bsub.EA.HbA1c.InvNorm.out
grep "Requested" bsub.EA.HbA1c.Raw.out
grep "Requested" bsub.HA.HbA1c.Raw.out
grep "Requested" bsub.IAA.HbA1c.Raw.out

grep "killed" bsub.EAA.HbA1c.Raw.out
grep "killed" bsub.EA.HbA1c.InvNorm.out
grep "killed" bsub.EA.HbA1c.Raw.out
grep "killed" bsub.HA.HbA1c.Raw.out
grep "killed" bsub.IAA.HbA1c.Raw.out

rm bsub.EAA.HbA1c.Raw.*
rm bsub.EA.HbA1c.InvNorm.*
rm bsub.EA.HbA1c.Raw.*
rm bsub.HA.HbA1c.Raw.*
rm bsub.IAA.HbA1c.Raw.*

for x in EAA; do for y in HbA1c; do for z in Raw;     do bsub -q long -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.err -R"select[mem>25000]  rusage[mem=25000]"  -M25000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z 1 < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation.R"; done; done; done
for x in IAA; do for y in HbA1c; do for z in Raw;     do bsub -q long -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.err -R"select[mem>30000]  rusage[mem=30000]"  -M30000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z 1 < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation.R"; done; done; done
for x in EA HA ; do for y in HbA1c; do for z in Raw;  do bsub -q long -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.err -R"select[mem>42000]  rusage[mem=42000]"  -M42000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z 1 < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation.R"; done; done; done

for x in EA ; do for y in HbA1c; do for z in InvNorm; do bsub -q hugemem -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.err -R"select[mem>50000]  rusage[mem=50000]"  -M50000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z 1 < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation.R"; done; done; done

for x in EA EAA ; do for y in FGluadjBMI; do for z in InvNorm; do bsub -q hugemem -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.err -R"select[mem>50000]  rusage[mem=50000]"  -M50000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z 1 < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation.R"; done; done; done
for x in EA EAA ; do for y in FInsadjBMI; do for z in InvNorm; do bsub -q hugemem -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.$x.$y.$z.err -R"select[mem>50000]  rusage[mem=50000]"  -M50000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z 1 < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation.R"; done; done; done


for x in AA HA IAA ; do for y in FGluadjBMI  ; do for z in InvNorm; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.clump.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.clump.$x.$y.$z.err -R"select[mem>50000]  rusage[mem=50000]"  -M50000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z 1 < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation_clumpingonly.R"; done; done; done
for x in AA HA IAA ; do for y in FInsadjBMI  ; do for z in InvNorm; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.clump.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.clump.$x.$y.$z.err -R"select[mem>50000]  rusage[mem=50000]"  -M50000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z 1 < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation_clumpingonly.R"; done; done; done
for x in HA EA     ; do for y in 2hrGluadjBMI; do for z in InvNorm; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.clump.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.clump.$x.$y.$z.err -R"select[mem>50000]  rusage[mem=50000]"  -M50000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z 1 < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation_clumpingonly.R"; done; done; done


###############################################################
### RESULTS from METAL : Looking at heterogeneity + redo QQ plots
###############################################################

x="EAA"
y="HbA1c"
z="Raw"

#------------------------------------ R code for Interpretation
param = commandArgs(trailingOnly=T)

x=param[1]
y=param[2]
z=param[3]

load("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/ListFiles.RData")


ww1 = which(ListFiles$Ancestry==x & ListFiles$Trait==y & ListFiles$Transf==z & ListFiles$Run==1)
print(ww1)
if( length(ww1)>1){ ww1=ww1[1] }
ww2 = which(ListFiles$Ancestry==x & ListFiles$Trait==y & ListFiles$Transf==z & ListFiles$Run==2)
print(ww2)
if( length(ww2)>1){ ww2=ww2[1] }


if( !is.na(ListFiles$Path1[ww1]) & !is.na(ListFiles$Path2[ww1]) & !is.na(ListFiles$Path1[ww2]) & !is.na(ListFiles$Path2[ww2]) )
{
 set.seed(7787*ww1*ww1) ; PathVol = sample(c("Path1","Path2"),1)
} else { if( !is.na(ListFiles$Path1[ww1]) & !is.na(ListFiles$Path1[ww2]) ) {PathVol="Path1"} else {PathVol="Path2"} }

# loading results
nR = -1
ff1 = read.table( gzfile(ListFiles[ww2,PathVol]) , h=T , as.is=T , nrows=nR )
rm(PathVol,ListFiles,ww1,ww2,nR)

ff1$Chr=sub(":","",substr(ff1$MarkerName,1,2))
temp = sub(":MERGED_DEL","",sub(":INDEL","",sub(":SNP","",ff1$MarkerName)))
ff1$Pos= as.numeric(ifelse( nchar(ff1$Chr)==1 , yes=sub(".:","",temp) , no=sub("..:","",temp) ))
rm(temp)

ff1$Chr2 = as.numeric(ifelse(ff1$Chr=="X",yes=23,no=ifelse(ff1$Chr=="Y",yes=24,no=ifelse(ff1$Chr=="XY",yes=25,no=ff1$Chr))))
ff1 = ff1[order(ff1$Chr2,ff1$Pos),]
ff1$logHetP=-log10(ff1$HetPVal)
maxHetS = max(ff1$logHetP)
obslogbfmax <- trunc(maxHetS)+5
x1 <- 1:25
x2 <- 1:2
for (i in 1:25)
{
 curchr=which(ff1$Chr2==i)
 x1[i] <- trunc((max(ff1$Pos[curchr]))/100) +100000
 x2[i] <- trunc((min(ff1$Pos[curchr]))/100) -100000
}
x1[1]=x1[1]-x2[1]
x2[1]=0-x2[1]
for (i in 2:26)
{
 x1[i] <- x1[i-1]-x2[i]+x1[i]
 x2[i] <- x1[i-1]-x2[i]
}
ff1$locX = trunc(ff1$Pos/100) + x2[ff1$Chr2]


# Genomic controls
pp1 = ff1$P.value ; pp1=pp1[order(pp1,decreasing=T)] ; qq1=qchisq(pp1,1,lower.tail=F)
nn=length(pp1) ; pp0=seq(from=1,to=1/nn,by=(-1/nn))

lbd0 = median(qq1,na.rm=T)/qchisq(0.5,df=1)

png( paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/QQplot_log10p_",x,"_",y,"_",z,".png",sep="") )
plot( -log10(pp0) , -log10(pp1) ,xlab="Expected -log10(p)",ylab="Observed -log10(p) ",main=paste(y,z,x,sep=" - ")) ; abline(0,1,lty=2,col="grey")
legend("topleft",c("Genomic Controls",paste("  Overall :",round(lbd0,4))))
dev.off()
rm(nn,pp0,pp1,qq1,lbd0)



# QQ plot on Heterogeneity p-value
pp1 = ff1$HetPVal ; pp1=pp1[order(pp1,decreasing=T)] ; qq1=qchisq(pp1,1,lower.tail=F)
nn=length(pp1) ; pp0=seq(from=1,to=1/nn,by=(-1/nn))

lbdH = median(qq1,na.rm=T)/qchisq(0.5,df=1)

png( paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/Heterogeneity2",x,"_",y,"_",z,".png",sep=""),width=1000,height=800 )
layout(matrix(c(1,2,3,4,4,4), 2, 3, byrow = TRUE))
 # 1st plot - QQ plot on het p
plot( -log10(pp0) , -log10(pp1) ,xlab="Expected -log10(p)",ylab="Observed -log10(p) ",main=paste(y,z,x,sep=" - ")) ; abline(0,1,lty=2,col="grey")
mtext(side=3,line=0.25,"QQ plot of the heterogeneity p-values")
legend("topleft",c(paste("Genomic Controls =",round(lbdH,4)),paste("N. heterogeneous variants =",sum(pp1<1e-05))),text.col=c("black","orange"))
abline(h=5,col="orange",lty=2)
rm(nn,pp0,pp1,qq1,lbdH)
 # 2nd plot - het p vs m-a p
plot( -log10(ff1$P.value) , -log10(ff1$HetPVal) , ylab="-log10(Het. P)",xlab="-log10(P)" , main=paste(y,z,x,sep=" - ") )
mtext(side=3,line=0.25,"Heterogeneity p-value vs. m-a p-value")
abline(h=5,col="orange",lty=2) ; abline(v=-log10(5e-8),col="green3",lty=2)
wwL = which(ff1$HetPVal<1e-05 & ff1$P.value<5e-8)
legend("topright",paste("N. heterogeneous signals =",length(wwL)),text.col="red")
if(length(wwL)>0) { points( -log10(ff1$P.value[wwL]) , -log10(ff1$HetPVal[wwL]) , col="red") }
 # 3rd plot - het p vs MAF
plot( ifelse( ff1$Freq1<=0.5 , yes=ff1$Freq1 , no=(1-ff1$Freq1) ) , -log10(ff1$HetPVal) , ylab="-log10(Het. P)",xlab="MAF" , main=paste(y,z,x,sep=" - ") )
mtext(side=3,line=0.25,"Heterogeneity p-value vs. MAF")
abline(h=5,col="orange",lty=2)
legend("topright",c(paste("N. heterogeneous =",sum(ff1$HetPVal<1e-05)),paste("N. heterogeneous MAF<5% =",sum(ff1$HetPVal<1e-05 & (ff1$Freq1<0.05 | ff1$Freq1>0.95))),paste("N. heterogeneous MAF<1% =",sum(ff1$HetPVal<1e-05 & (ff1$Freq1<0.01 | ff1$Freq1>0.99)))))
 # 4th plot - Manhattan plot on het p
col1=rgb(0,0,108,maxColorValue=255)
col2=rgb(100,149,237,maxColorValue=255)
col4 <- ifelse(ff1$Chr2%%2==0, col1, col2)
plot(ff1$locX,ff1$logHetP,pch=20,col=col4,xaxt="n",ylab="log10(Het. P)",xlab="",bty="n",ylim=c(0,obslogbfmax),cex=0.8,main=paste(y,z,x,sep=" - "))
abline(h=5,lty=2,col="orange")
rm(col1,col2,col4)
if(length(wwL)>0) { points( ff1$locX[wwL] , ff1$logHetP[wwL] , col="red" , pch=20 , cex=0.8 ) } ; rm(wwL)
dev.off()
#-----------------------------------------------------------------------



for x in EA  ; do for y in HbA1c; do for z in InvNorm; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.hetP.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.hetP.$x.$y.$z.err -R"select[mem>40000]  rusage[mem=40000]"  -M40000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation_HetP.R"; done; done; done
for x in AA  ; do for y in HbA1c; do for z in InvNorm; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.hetP.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.hetP.$x.$y.$z.err -R"select[mem>40000]  rusage[mem=40000]"  -M40000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation_HetP.R"; done; done; done
for x in HA  ; do for y in HbA1c; do for z in InvNorm; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.hetP.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.hetP.$x.$y.$z.err -R"select[mem>40000]  rusage[mem=40000]"  -M40000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation_HetP.R"; done; done; done
for x in EAA ; do for y in HbA1c; do for z in InvNorm; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.hetP.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.hetP.$x.$y.$z.err -R"select[mem>25000]  rusage[mem=25000]"  -M25000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation_HetP.R"; done; done; done
for x in IAA ; do for y in HbA1c; do for z in InvNorm; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.hetP.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.hetP.$x.$y.$z.err -R"select[mem>25000]  rusage[mem=25000]"  -M25000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation_HetP.R"; done; done; done


tail -n3 METAL_interpretation/bsub.hetP.*.out

grep Success METAL_interpretation/bsub.hetP*
grep reported METAL_interpretation/bsub.hetP*


## List the heterogeneous variants
for x in EA  ; do for y in HbA1c; do for z in InvNorm; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.listHet.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.listHet.$x.$y.$z.err -R"select[mem>27000]  rusage[mem=27000]"  -M27000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation_HetP_listVariants.R"; done; done; done
for x in AA  ; do for y in HbA1c; do for z in InvNorm; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.listHet.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.listHet.$x.$y.$z.err -R"select[mem>25000]  rusage[mem=25000]"  -M25000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation_HetP_listVariants.R"; done; done; done
for x in HA  ; do for y in HbA1c; do for z in InvNorm; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.listHet.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.listHet.$x.$y.$z.err -R"select[mem>25000]  rusage[mem=25000]"  -M25000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation_HetP_listVariants.R"; done; done; done
for x in IAA ; do for y in HbA1c; do for z in InvNorm; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.listHet.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.listHet.$x.$y.$z.err -R"select[mem>10000]  rusage[mem=10000]"  -M10000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation_HetP_listVariants.R"; done; done; done
for x in EAA ; do for y in HbA1c; do for z in InvNorm; do bsub -q normal -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.listHet.$x.$y.$z.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/bsub.listHet.$x.$y.$z.err -R"select[mem>10000]  rusage[mem=10000]"  -M10000  "/software/R-3.0.0/bin/R --no-save --args $x $y $z < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/METAL_Interpretation_HetP_listVariants.R"; done; done; done





###############################################################
### RESULTS from METAL : work on clumped signal files
###############################################################

summl = dir("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation",full.names=T)
summl = summl[which( grepl("summary",summl) & !grepl("old",summl))]
summAll = NULL
for ( i in summl)
{
 load(i)
 summAll = rbind(summAll,summ)
 rm(summ)
} ; rm(i)

a="EAA"

clump = read.table(paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/signals_500kb_",a,"_HbA1c_Raw.txt",sep=""),h=T,as.is=T)
known = read.table(paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/KnownLoci_",a,"_HbA1c_Raw.txt",sep=""),h=T,as.is=T,sep="\t")

par(mfrow=c(1,2))
plot(known$AA_EAF,(1-known$Freq1_raising),col=ifelse(known$HetPVal<0.00001,yes="dark grey",no=ifelse(known$P.value<0.05,yes="red",no="black")),pch=ifelse(is.na(known$AA_PVAL) | known$AA_PVAL>0.05 , yes=21 , no=20 )) ; abline(0,1,col="grey",lty=2)
plot(known$AA_BETA,(-known$Effect_raising),col=ifelse(known$HetPVal<0.00001,yes="dark grey",no=ifelse(known$P.value<0.05,yes="red",no="black")),pch=ifelse(is.na(known$AA_PVAL) | known$AA_PVAL>0.05 , yes=21 , no=20 )) ; abline(0,1,col="grey",lty=2)

plot(known$EA_EAF,(1-known$Freq1_raising),col=ifelse(known$HetPVal<0.00001,yes="dark grey",no=ifelse(known$P.value<0.05,yes="red",no="black")),pch=ifelse(is.na(known$EA_PVAL) | known$AA_PVAL>0.05 , yes=21 , no=20 )) ; abline(0,1,col="grey",lty=2)
plot(known$EA_BETA,(-known$Effect_raising),col=ifelse(known$HetPVal<0.00001,yes="dark grey",no=ifelse(known$P.value<0.05,yes="red",no="black")),pch=ifelse(is.na(known$EA_PVAL) | known$AA_PVAL>0.05 , yes=21 , no=20 )) ; abline(0,1,col="grey",lty=2)

plot(known$SAA_EAF,(1-known$Freq1_raising),col=ifelse(known$HetPVal<0.00001,yes="dark grey",no=ifelse(known$P.value<0.05,yes="red",no="black")),pch=ifelse(is.na(known$SAA_PVAL) | known$AA_PVAL>0.05 , yes=21 , no=20 )) ; abline(0,1,col="grey",lty=2)
plot(known$SAA_BETA,(-known$Effect_raising),col=ifelse(known$HetPVal<0.00001,yes="dark grey",no=ifelse(known$P.value<0.05,yes="red",no="black")),pch=ifelse(is.na(known$SAA_PVAL) | known$AA_PVAL>0.05 , yes=21 , no=20 )) ; abline(0,1,col="grey",lty=2)

plot(known$EAA_EAF,(1-known$Freq1_raising),col=ifelse(known$HetPVal<0.00001,yes="dark grey",no=ifelse(known$P.value<0.05,yes="red",no="black")),pch=ifelse(is.na(known$EAA_PVAL) | known$AA_PVAL>0.05 , yes=21 , no=20 )) ; abline(0,1,col="grey",lty=2)
plot(known$EAA_BETA,(-known$Effect_raising),col=ifelse(known$HetPVal<0.00001,yes="dark grey",no=ifelse(known$P.value<0.05,yes="red",no="black")),pch=ifelse(is.na(known$EAA_PVAL) | known$AA_PVAL>0.05 , yes=21 , no=20 )) ; abline(0,1,col="grey",lty=2)


table(known$MarkerName %in% clump$MarkerName)
mm = merge( clump, known,by="MarkerName")


## Join QQ plot by trait

montage METAL_interpretation/QQplot*FGluadjBMI_Raw*        -tile 2x3 -geometry 1000x1000 METAL_interpretation/ALL_QQplot_FGluadjBMI_Raw.png
montage METAL_interpretation/QQplot*FGluadjBMI_InvNorm*    -tile 2x3 -geometry 1000x1000 METAL_interpretation/ALL_QQplot_FGluadjBMI_InvNorm.png
montage METAL_interpretation/QQplot*FInsadjBMI_Raw*        -tile 2x3 -geometry 1000x1000 METAL_interpretation/ALL_QQplot_FInsadjBMI_Raw.png
#montage METAL_interpretation/QQplot*FInsadjBMI_InvNorm*    -tile 2x3 -geometry 1000x1000 METAL_interpretation/ALL_QQplot_FInsadjBMI_InvNorm.png
montage METAL_interpretation/QQplot*2hrGluadjBMI_Raw*      -tile 2x2 -geometry 1000x1000 METAL_interpretation/ALL_QQplot_2hrGluadjBMI_Raw.png
montage METAL_interpretation/QQplot*2hrGluadjBMI_InvNorm*  -tile 2x2 -geometry 1000x1000 METAL_interpretation/ALL_QQplot_2hrGluadjBMI_InvNorm.png
montage METAL_interpretation/QQplot*HbA1c_Raw*             -tile 2x3 -geometry 1000x1000 METAL_interpretation/ALL_QQplot_HbA1c_Raw.png
montage METAL_interpretation/QQplot*HbA1c_InvNorm*         -tile 2x3 -geometry 1000x1000 METAL_interpretation/ALL_QQplot_HbA1c_InvNorm.png
montage METAL_interpretation/QQplot*HbA1cadjFGlu_Raw*      -tile 2x3 -geometry 1000x1000 METAL_interpretation/ALL_QQplot_HbA1cadjFGlu_Raw.png
montage METAL_interpretation/QQplot*HbA1cadjFGlu_InvNorm*  -tile 2x3 -geometry 1000x1000 METAL_interpretation/ALL_QQplot_HbA1cadjFGlu_InvNorm.png





# Extract known loci in EA analyses


x="EA"
y= "FGluadjBMI" #"HbA1c"
z="Raw"

    par(mfrow=c(5,8))
for ( x in c("AA","EA","EAA","IAA","HA") )
{
 for ( y in c("HbA1c") )  #"FGluadjBMI","FInsadjBMI",,"HbA1cadjFGlu","2hrGluadjBMI") )
 {
  for ( z in c("Raw") )  #"Raw",
  {
   cat(x,y,z,":\n")

   if( !(y=="FInsadjBMI" & z=="InvNorm") & !(x=="IAA" & y=="2hrGluadjBMI") )
   {
    tt1 = read.table( paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/KnownLoci_",x,"_",y,"_",z,".txt",sep="") , h=T , as.is=T , sep="\t" )
    if ( y=="HbA1c" )
    {
     for ( bb in c("EA","AA","EAA","SAA") ) { plot( tt1[,paste(bb,"BETA",sep="_")] , -tt1$Effect_raising , main="Effects"     , ylab=paste(x," current m-a",sep="") , xlab=paste(bb," previous estimate",sep="_") ) ; abline(0,1,col="grey") } ; rm(bb)
     for ( bb in c("EA","AA","EAA","SAA") ) { plot( tt1[,paste(bb,"EAF",sep="_")]  , 1-tt1$Freq1_raising , main="Frequencies" , ylab=paste(x," current m-a",sep="") , xlab=paste(bb," previous estimate",sep="_") ) ; abline(0,1,col="grey") } ; rm(bb)
    }  else { # no beta and freq previously esimated
            }
   }
   rm(tt1)
  } ; rm(z)
 } ; rm(y)
} ; rm(x)


unique(RES[,c(2,4)])

RES2=NULL
for ( y in c("FGluadjBMI","FInsadjBMI","HbA1c","HbA1cadjFGlu","2hrGluadjBMI") )
{
tp2=NULL
for ( z in c("Raw","InvNorm") )
{
tp1 = NULL
for ( x in c("AA","EA","EAA","IAA","HA") )
{
 ww=which( RES[,1]==x & RES[,2]==y & RES[,3]==z)
 if(length(ww)>0) { tp1=rbind(tp1,RES[ww,c(1,2,3,5:11)]) } else { tp1=rbind(tp1,c(x,y,z,rep(NA,7))  )}
 rm(ww)
} ; rm(x)
tp2=cbind(tp2,tp1)
rm(tp1)
} ; rm(z)
RES2=rbind(RES2,tp2)
rm(tp2)
} ; rm(y)

RES2



##### Study freq versus MA freq

cd /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_FromVolunteers/

for ff in `ls -1 Transethnic_1000G_FGluadjBMI_Raw*.tbl.gz`; do bsub -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_Decembre2015/METAL_bsubs/bsub_ForFreq_$ff.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_Decembre2015/METAL_bsubs/bsub_ForFreq_$ff.err  "zcat $ff | cut -f1-7,16 | bgzip -c > ForFreq.$ff"; done
for ff in `ls -1 *HbA1c_InvNorm_meta_LC_20151212_1.txt.gz`; do bsub -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_Decembre2015/METAL_bsubs/bsub_ForFreq_$ff.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_Decembre2015/METAL_bsubs/bsub_ForFreq_$ff.err  "zcat $ff | cut -f1-7,16 | bgzip -c > ForFreq.$ff"; done

for ff in `ls -1 Transethnic_1000G_FGluadjBMI_Raw*.tbl.gz`; do bsub -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_Decembre2015/METAL_bsubs/bsub_ForFreq2_$ff.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_Decembre2015/METAL_bsubs/bsub_ForFreq2_$ff.err  "zcat $ff | cut -f1-4,10,11,16 | bgzip -c > ForFreq2.$ff"; done
for ff in `ls -1 *HbA1c_InvNorm_meta_LC_20151212_1.txt.gz`; do bsub -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_Decembre2015/METAL_bsubs/bsub_ForFreq2_$ff.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_Decembre2015/METAL_bsubs/bsub_ForFreq2_$ff.err  "zcat $ff | cut -f1-4,10,11,16 | bgzip -c > ForFreq2.$ff"; done


   #--------- R code to run with bsub
param = commandArgs(trailingOnly=T)
aa=param[1]

if ( aa=="AA" )
{
 maFreq_FG  = read.table( gzfile("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_Decembre2015/METAL_FromVolunteers/ForFreq2.Transethnic_1000G_FGluadjBMI_Raw_AA1.tbl.gz" ) , h=T , sep="\t" , as.is=T )
 maFreq_Hb  = read.table( gzfile("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_Decembre2015/METAL_FromVolunteers/ForFreq2.AA_HbA1c_InvNorm_meta_LC_20151212_1.txt.gz" ) , h=T , sep="\t" , as.is=T )
 g1000  = read.table( gzfile("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/ReferenceFiles/allelefreq.1000G_AFR_p1v3.impute_legends.noMono.noDup.noX.v2.MarkerName.gz") , h=T , sep="\t" , as.is=T )
}

if ( aa=="EA" )
{
 maFreq_FG  = read.table( gzfile("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_Decembre2015/METAL_FromVolunteers/ForFreq2.Transethnic_1000G_FGluadjBMI_Raw_EA1.tbl.gz" ) , h=T , sep="\t" , as.is=T )
 maFreq_Hb  = read.table( gzfile("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_Decembre2015/METAL_FromVolunteers/ForFreq2.EA_HbA1c_InvNorm_meta_LC_20151212_1.txt.gz" ) , h=T , sep="\t" , as.is=T )
 g1000  = read.table( gzfile("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/ReferenceFiles/allelefreq.1000G_EUR_p1v3.impute_legends.noMono.noDup.noX.v2.MarkerName.gz") , h=T , sep="\t" , as.is=T )
}

if ( aa=="HA" )
{
 maFreq_FG  = read.table( gzfile("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_Decembre2015/METAL_FromVolunteers/ForFreq2.Transethnic_1000G_FGluadjBMI_Raw_HA1.tbl.gz" ) , h=T , sep="\t" , as.is=T )
 maFreq_Hb  = read.table( gzfile("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_Decembre2015/METAL_FromVolunteers/ForFreq2.HA_HbA1c_InvNorm_meta_LC_20151212_1.txt.gz" ) , h=T , sep="\t" , as.is=T )
 g1000  = read.table( gzfile("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/ReferenceFiles/1000G_p1v3.MXL.FiltPass.NoDup.MAFgt01.NoX.AF_rbind.MarkerName.gz") , h=T , sep="\t" , as.is=T )
}

if ( aa=="EAA" )
{
 maFreq_FG = read.table( gzfile("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_Decembre2015/METAL_FromVolunteers/ForFreq2.Transethnic_1000G_FGluadjBMI_Raw_EAA1.tbl.gz") , h=T , sep="\t" , as.is=T )
 maFreq_Hb = read.table( gzfile("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_Decembre2015/METAL_FromVolunteers/ForFreq2.EAA_HbA1c_InvNorm_meta_LC_20151212_1.txt.gz" ) , h=T , sep="\t" , as.is=T )
 g1000 = read.table( gzfile("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/ReferenceFiles/allelefreq.1000G_ASN_p1v3.impute_legends.noMono.noDup.noX.v2.MarkerName.gz") , h=T , sep="\t" , as.is=T )
}

if ( aa=="IAA" )
{
 maFreq_FG = read.table( gzfile("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_Decembre2015/METAL_FromVolunteers/ForFreq2.Transethnic_1000G_FGluadjBMI_Raw_IAA1.tbl.gz") , h=T , sep="\t" , as.is=T )
 maFreq_Hb = read.table( gzfile("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_Decembre2015/METAL_FromVolunteers/ForFreq2.IAA_HbA1c_InvNorm_meta_LC_20151212_1.txt.gz" ) , h=T , sep="\t" , as.is=T )
 g1000 = read.table( gzfile("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/ReferenceFiles/allelefreq.1000G_EUR_p1v3.impute_legends.noMono.noDup.noX.v2.MarkerName.gz") , h=T , sep="\t" , as.is=T )
}

cat("Ancestry = ",aa,"\n")
cat("Number of common markers between FG and HbA1c = " , sum( maFreq_FG$MarkerName %in% maFreq_Hb$MarkerName ) , "\n")
cat("Number of markers in FG and not in HbA1c = " , sum(!(maFreq_FG$MarkerName %in% maFreq_Hb$MarkerName)) , "\n")
cat("Number of markers in HbA1c and not in FG = " , sum(!(maFreq_Hb$MarkerName %in% maFreq_FG$MarkerName)) , "\n")
cat("Number of common markers between FG and HbA1c, also in 1000G = " , sum( maFreq_FG$MarkerName %in% maFreq_Hb$MarkerName & maFreq_FG$MarkerName %in% g1000$MarkerName ) , "\n")
cat("Number of markers in FG and not in HbA1c, but in 1000G = " , sum(!(maFreq_FG$MarkerName %in% maFreq_Hb$MarkerName) & maFreq_FG$MarkerName %in% g1000$MarkerName) , "\n")
cat("Number of markers in HbA1c and not in FG, but in 1000G = " , sum(!(maFreq_Hb$MarkerName %in% maFreq_FG$MarkerName) & maFreq_Hb$MarkerName %in% g1000$MarkerName) , "\n")

mm1 = merge( maFreq_FG , maFreq_Hb , by="MarkerName" , all=T )
rm(maFreq_FG,maFreq_Hb) ; gc()

#mm2 = merge( mm1 , g1000 , by="MarkerName" , all.x=T )
#rm(mm1,g1000) ; gc()

mmB = mm1[which( !(mm1$MarkerName %in% g1000$MarkerName) ),]

g1000_indel=g1000[which(grepl("INDEL",g1000$MarkerName)),]
rm(g1000) ; gc()
g1000_indel$MarkerName=sub("INDEL","MERGED_DEL",g1000_indel$MarkerName)

mm2 = merge( mmB , g1000_indel , by="MarkerName" , all=T )
rm(mmB,g1000_indel) ; gc()

cat("Number of markers in FG or HbA1c, and not in ref = " , nrow( mm2 ) , "\n")
cat("Number of markers in FG or HbA1c, and not in ref, but in as MERGED_DEL = " , sum( !is.na(mm2$a0) ) , "\n")
cat("MERGED_DEL and 1000G\n")
print(table( is.na(mm2$a0) , grepl("MERGED_DEL",mm2$MarkerName) , exclude=c() ))
cat("\n\n")


N_FG = max(mm2$TotalSampleSize.x,na.rm=T)
N_Hb = max(mm2$TotalSampleSize.y,na.rm=T)
cat("Sample sizes:",N_FG,"for FG and",N_Hb,"for HbA1c\n")
cat("Number of markers with less than 1/3 sample size:",sum(mm2$TotalSampleSize.x<(N_FG/3),na.rm=T),"for FG and",sum(mm2$TotalSampleSize.y<(N_Hb/3),na.rm=T),"for HbA1c\n")



cat("Allele comparison between FG and HbA1c\n")
print(table( mm2$Allele1.x==mm2$Allele1.y , mm2$Allele1.x==mm2$Allele2.y , exclude=c() ))
cat("\n\nAllele comparison between FG and 1000G\n")
print(table( mm2$Allele1.x==tolower(mm2$a0) , mm2$Allele1.x==tolower(mm2$a1) , exclude=c() ))
cat("\n\n")


mm2$Flip.FG.HbA1c = 0
ww1 = which( mm2$Allele1.x==mm2$Allele2.y & mm2$Allele2.x==mm2$Allele1.y )
if( length(ww1)>0 )
{
 mm2$Flip.FG.HbA1c[ww1] = 1
 mm2$Allele1.y[ww1] = mm2$Allele2.x[ww1]
 mm2$Allele2.y[ww1] = mm2$Allele1.x[ww1]
 mm2$Freq1.y[ww1]   = 1-mm2$Freq1.y[ww1]
 mm2$MinFreq.y[ww1] = 1-mm2$MinFreq.y[ww1]
 mm2$MaxFreq.y[ww1] = 1-mm2$MaxFreq.y[ww1]
} ; rm(ww1)

mm2$Flip.FG.1000G = 0
ww2 = which( mm2$Allele1.x==tolower(mm2$a1) & mm2$Allele2.x==tolower(mm2$a0) )
if( length(ww2)>0 )
{
 mm2$Flip.FG.1000G[ww2] = 1
 mm2$a0[ww2]  = mm2$Allele1.x[ww2]
 mm2$a1[ww2]  = mm2$Allele2.x[ww2]
 mm2$eaf[ww2] = 1-mm2$eaf[ww2]
} ; rm(ww2)

mm2$Flip.HbA1c.1000G = 0
ww3 = which( mm2$Allele1.y==tolower(mm2$a1) & mm2$Allele2.y==tolower(mm2$a0) )
if( length(ww3)>0 )
{
 mm2$Flip.HbA1c.1000G[ww3] = 1
 mm2$a0[ww3]  = mm2$Allele1.y[ww3]
 mm2$a1[ww3]  = mm2$Allele2.y[ww3]
 mm2$eaf[ww3] = 1-mm2$eaf[ww3]
} ; rm(ww3)


mm2$Mismatch.1000G = 0
mm2$Mismatch.FG = 0
mm2$Mismatch.HbA1c = 0
mm2$Mismatch.all = 0

wwMISMATCH.1000G = which( (mm2$Allele1.x==mm2$Allele1.y & mm2$Allele2.x==mm2$Allele2.y | is.na(mm2$Allele1.x) | is.na(mm2$Allele1.y)) & (mm2$Allele1.x!=tolower(mm2$a0) | mm2$Allele2.x!=tolower(mm2$a1) | mm2$Allele1.y!=tolower(mm2$a0) | mm2$Allele2.y!=tolower(mm2$a1)) )
wwMISMATCH.FG = which( (mm2$Allele1.x!=mm2$Allele1.y | mm2$Allele2.x!=mm2$Allele2.y) & ( (mm2$Allele1.y==tolower(mm2$a0) & mm2$Allele2.y==tolower(mm2$a1)) | is.na(mm2$a0)) )
wwMISMATCH.Hb = which( (mm2$Allele1.x!=mm2$Allele1.y | mm2$Allele2.x!=mm2$Allele2.y) &( ( mm2$Allele1.x==tolower(mm2$a0) & mm2$Allele2.x==tolower(mm2$a1)) | is.na(mm2$a0)) )
wwMISMATCH.all = which( (mm2$Allele1.x!=mm2$Allele1.y | mm2$Allele2.x!=mm2$Allele2.y)
                      & (mm2$Allele1.x!=tolower(mm2$a0) | mm2$Allele2.x!=tolower(mm2$a1))
                      & (mm2$Allele1.y!=tolower(mm2$a0) | mm2$Allele2.y!=tolower(mm2$a1)))

cat("Number of mismatches 1000G = ",length(wwMISMATCH.1000G),"\n")
cat("Number of mismatches FG = ",length(wwMISMATCH.FG),"\n")
cat("Number of mismatches HbA1c = ",length(wwMISMATCH.Hb),"\n")
cat("Number of 3-way mismatches = ",length(wwMISMATCH.all),"\n")

if( length(wwMISMATCH.1000G)>0 ) { mm2$Mismatch.1000G[wwMISMATCH.1000G]=1 ; mm2$eaf[wwMISMATCH.1000G]=NA }
if( length(wwMISMATCH.FG)>0 ) { mm2$Mismatch.FG[wwMISMATCH.FG]=1 ; mm2$Freq1.x[wwMISMATCH.FG]=NA } #; mm2$MinFreq.x[wwMISMATCH.FG]=NA ; mm2$MaxFreq.x[wwMISMATCH.FG]=NA ; mm2$FreqSE.x[wwMISMATCH.FG]=NA }
if( length(wwMISMATCH.Hb)>0 ) { mm2$Mismatch.HbA1c[wwMISMATCH.Hb]=1 ; mm2$Freq1.y[wwMISMATCH.Hb]=NA } #; mm2$MinFreq.y[wwMISMATCH.Hb]=NA ; mm2$MaxFreq.y[wwMISMATCH.Hb]=NA ; mm2$FreqSE.y[wwMISMATCH.Hb]=NA }
if( length(wwMISMATCH.all)>0 )
{
  mm2$Mismatch.all[wwMISMATCH.all]=1
  mm2$Freq1.x[wwMISMATCH.all]=NA #; mm2$MinFreq.x[wwMISMATCH.all]=NA ; mm2$MaxFreq.x[wwMISMATCH.all]=NA ; mm2$FreqSE.x[wwMISMATCH.all]=NA
  mm2$Freq1.y[wwMISMATCH.all]=NA #; mm2$MinFreq.y[wwMISMATCH.all]=NA ; mm2$MaxFreq.y[wwMISMATCH.all]=NA ; mm2$FreqSE.y[wwMISMATCH.all]=NA
  mm2$eaf[wwMISMATCH.all]=NA
}

rm(wwMISMATCH.1000G,wwMISMATCH.FG,wwMISMATCH.Hb,wwMISMATCH.all)

ww = which( !grepl("MERGED_DEL",mm2$MarkerName) & !grepl("X",mm2$MarkerName) )

cat("Sample sizes for autosome not MERGED_DEL\n")
print(summary(mm2$TotalSampleSize.x[ww]))
print(summary(mm2$TotalSampleSize.y[ww]))
cat("\n\n")

cat("P-values for autosome not MERGED_DEL\n")
print(summary(mm2$P.value.x[ww]))
print(summary(mm2$P.value.y[ww]))
cat("\n\n")

cat("Frequencies for autosome not MERGED_DEL\n")
print(summary(mm2$Freq1.x[ww]))
print(summary(mm2$Freq1.y[ww]))
cat("\n\n")


png(paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/Plots/MAfreq2_",aa,".png",sep=""),width=800,heigh=1200)
par(mfrow=c(4,2))

hist( mm2$TotalSampleSize.x[ww] , breaks=100 , xlab="FG sample size (autosomes not MERGED_DEL" )
hist( mm2$TotalSampleSize.y[ww] , breaks=100 , xlab="HbA1c sample size (autosomes not MERGED_DEL" )
hist( mm2$P.value.x[ww] , breaks=100 , xlab="FG p-values (autosomes not MERGED_DEL" )
hist( mm2$P.value.y[ww] , breaks=100 , xlab="HbA1c p-values (autosomes not MERGED_DEL" )
hist( mm2$Freq1.x[ww] , breaks=100 , xlab="FG Frequencies (autosomes not MERGED_DEL" )
hist( mm2$Freq1.y[ww] , breaks=100 , xlab="HbA1c Frequencies (autosomes not MERGED_DEL" )

plot( mm2$Freq1.x , mm2$Freq1.y , xlab="FG frequencies"    , ylab="HbA1c Frequencies" , main=aa ) ; abline(0,1) ; abline(0.2,1,col="orange") ; abline(-0.2,1,col="orange") ; abline(0.4,1,col="red") ; abline(-0.4,1,col="red")
title(main="FG vs HbA1c",line=0.5)

ww=which(mm2$TotalSampleSize.x>=(N_FG/3) & mm2$TotalSampleSize.y>=(N_Hb/3))
plot( mm2$Freq1.x[ww] , mm2$Freq1.y[ww] , xlab="FG frequencies"    , ylab="HbA1c Frequencies" , main=aa ) ; abline(0,1) ; abline(0.2,1,col="orange") ; abline(-0.2,1,col="orange") ; abline(0.4,1,col="red") ; abline(-0.4,1,col="red")
title(main="FG vs HbA1c - restrict on Markers with more than 1/3N for each both traits",line=0.5)
rm(ww)

dev.off()


#png(paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/Plots/MAfreq_",aa,".png",sep=""),width=1000,heigh=1000)
#par(mfrow=c(3,3))

#plot( mm2$Freq1.x , mm2$Freq1.y , xlab="FG frequencies"    , ylab="HbA1c Frequencies" , main=aa ) ; abline(0,1) ; abline(0.2,1,col="orange") ; abline(-0.2,1,col="orange") ; abline(0.4,1,col="red") ; abline(-0.4,1,col="red")
#title(main="FG vs HbA1c",line=0.5)

#ww=which(!is.na(mm2$eaf))
#plot( mm2$Freq1.x[ww] , mm2$Freq1.y[ww] , xlab="FG frequencies"    , ylab="HbA1c Frequencies" , main=aa ) ; abline(0,1) ; abline(0.2,1,col="orange") ; abline(-0.2,1,col="orange") ; abline(0.4,1,col="red") ; abline(-0.4,1,col="red")
#title(main="FG vs HbA1c - restrict on Markers in 1000G p1v3",line=0.5)
#rm(ww)

#ww=which(mm2$TotalSampleSize.x>=(N_FG/3) & mm2$TotalSampleSize.y>=(N_Hb/3))
#plot( mm2$Freq1.x[ww] , mm2$Freq1.y[ww] , xlab="FG frequencies"    , ylab="HbA1c Frequencies" , main=aa ) ; abline(0,1) ; abline(0.2,1,col="orange") ; abline(-0.2,1,col="orange") ; abline(0.4,1,col="red") ; abline(-0.4,1,col="red")
#title(main="FG vs HbA1c - restrict on Markers with more than 1/3N for each both traits",line=0.5)
#rm(ww)

plot( mm2$Freq1.x , mm2$eaf     , xlab="FG frequencies"    , ylab="1000G Frequencies" , main=aa ) ; abline(0,1) ; abline(0.2,1,col="orange") ; abline(-0.2,1,col="orange") ; abline(0.4,1,col="red") ; abline(-0.4,1,col="red")
title(main="FG vs 1000G p1v3",line=0.5)

#ww=which(mm2$TotalSampleSize.x>=(N_FG/3))
#plot( mm2$Freq1.x[ww] , mm2$eaf[ww]     , xlab="FG frequencies"    , ylab="1000G Frequencies" , main=aa ) ; abline(0,1) ; abline(0.2,1,col="orange") ; abline(-0.2,1,col="orange") ; abline(0.4,1,col="red") ; abline(-0.4,1,col="red")
#title(main="FG vs 1000G p1v3 - ≥1/3 N for FG",line=0.5)

#plot( mm2$MinFreq.x , mm2$MaxFreq.x , xlab="FG frequencies - Min"    , ylab="FG Frequencies - Max" , main=aa , type="n")
#title(main="Min vs Max Freq coloured by diff with 1000G - FG",line=0.5)
#legend("bottomright",legend=c("No 1000G freq","diff<=0.2","diff ]0.2-0.4]","diff>0.4"),pch=20,col=c("grey","black","orange","red"))
#ww=which(is.na(mm2$eaf)) ; if(length(ww)>0) { points(mm2$MinFreq.x[ww] , mm2$MaxFreq.x[ww] , col="grey") } ; rm(ww)
#ww=which(abs(mm2$Freq1.x-mm2$eaf)<=0.2) ; if(length(ww)>0) { points(mm2$MinFreq.x[ww] , mm2$MaxFreq.x[ww] , col="black") } ; rm(ww)
#ww=which(abs(mm2$Freq1.x-mm2$eaf)>0.2 & abs(mm2$Freq1.x-mm2$eaf)<=0.4) ; if(length(ww)>0) { points(mm2$MinFreq.x[ww] , mm2$MaxFreq.x[ww] , col="orange") } ; rm(ww)
#ww=which(abs(mm2$Freq1.x-mm2$eaf)>0.4) ; if(length(ww)>0) { points(mm2$MinFreq.x[ww] , mm2$MaxFreq.x[ww] , col="red") } ; rm(ww)

#plot( mm2$Freq1.y , mm2$eaf     , xlab="HbA1c frequencies" , ylab="1000G Frequencies" , main=aa ) ; abline(0,1) ; abline(0.2,1,col="orange") ; abline(-0.2,1,col="orange") ; abline(0.4,1,col="red") ; abline(-0.4,1,col="red")
#title(main="HbA1c vs 1000G p1v3",line=0.5)

#ww=which(mm2$TotalSampleSize.y>=(N_Hb/3))
#plot( mm2$Freq1.y[ww] , mm2$eaf[ww]     , xlab="HbA1c frequencies" , ylab="1000G Frequencies" , main=aa ) ; abline(0,1) ; abline(0.2,1,col="orange") ; abline(-0.2,1,col="orange") ; abline(0.4,1,col="red") ; abline(-0.4,1,col="red")
#title(main="HbA1c vs 1000G p1v3 - ≥1/3 N for HbA1c",line=0.5)

#plot( mm2$MinFreq.y , mm2$MaxFreq.y , xlab="HbA1c frequencies - Min"    , ylab="HbA1c Frequencies - Max" , main=aa , type="n")
#title(main="Min vs Max Freq coloured by diff with 1000G - HbA1c",line=0.5)
#legend("bottomright",legend=c("No 1000G freq","diff<=0.2","diff ]0.2-0.4]","diff>0.4"),pch=20,col=c("grey","black","orange","red"))
#ww=which(is.na(mm2$eaf))                                               ; if(length(ww)>0) { points(mm2$MinFreq.y[ww] , mm2$MaxFreq.y[ww] , col="grey")   } ; rm(ww)
#ww=which(abs(mm2$Freq1.y-mm2$eaf)<=0.2)                                ; if(length(ww)>0) { points(mm2$MinFreq.y[ww] , mm2$MaxFreq.y[ww] , col="black")  } ; rm(ww)
#ww=which(abs(mm2$Freq1.y-mm2$eaf)>0.2 & abs(mm2$Freq1.x-mm2$eaf)<=0.4) ; if(length(ww)>0) { points(mm2$MinFreq.y[ww] , mm2$MaxFreq.y[ww] , col="orange") } ; rm(ww)
#ww=which(abs(mm2$Freq1.y-mm2$eaf)>0.4)                                 ; if(length(ww)>0) { points(mm2$MinFreq.y[ww] , mm2$MaxFreq.y[ww] , col="red")    } ; rm(ww)

#plot( mm2$Freq1.x-mm2$eaf , mm2$FreqSE.x    , xlab="FG Frequencies - 1000G Frequencies"  , ylab="FG frequencies (SE)", main=aa) ; title(main="Freq SE vs diff with 1000G - FG",line=0.5)
#plot( mm2$Freq1.y-mm2$eaf , mm2$FreqSE.y    , xlab="HbA1c Frequencies - 1000G Frequencies"  , ylab="HbA1c frequencies (SE)", main=aa) ; title(main="Freq SE vs diff with 1000G - HbA1c",line=0.5)
#plot( mm2$FreqSE.x[which(is.na(mm2$eaf))] , mm2$FreqSE.y[which(is.na(mm2$eaf))] , xlab="FG frequencies (SE)"  , ylab="HbA1c frequencies (SE)", main=aa ) ; title(main="Freq SE - FG vs HbA1c - When no 1000G marker",line=0.5)

#dev.off()

#ww = which( abs(mm2$Freq1.x-mm2$eaf)>0.4 | abs(mm2$Freq1.y-mm2$eaf)>0.4 | abs(mm2$Freq1.x-mm2$Freq1.y)>0.4 )
#mm3 = mm2[ww,]
#save( mm3 , file=paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/Plots/Outliers_",aa,".RData",sep="") )
#rm(ww,mm3)

   #-------------------------------------- End of R code


for i in EAA; do bsub -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/bsub/bsub.$i.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/bsub/bsub.$i.err -R"select[mem>20000] rusage[mem=20000]" -M20000 "/software/R-3.0.0/bin/R --no-save --args $i < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/PlotFromMA.R"; done
for i in IAA; do bsub -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/bsub/bsub.$i.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/bsub/bsub.$i.err -R"select[mem>30000] rusage[mem=30000]" -M30000 "/software/R-3.0.0/bin/R --no-save --args $i < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/PlotFromMA.R"; done
for i in AA HA; do bsub -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/bsub/bsub.$i.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/bsub/bsub.$i.err -R"select[mem>40000] rusage[mem=40000]" -M40000 "/software/R-3.0.0/bin/R --no-save --args $i < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/PlotFromMA.R"; done
for i in EA; do bsub -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/bsub/bsub.$i.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/bsub/bsub.$i.err -R"select[mem>50000] rusage[mem=50000]" -M50000 "/software/R-3.0.0/bin/R --no-save --args $i < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/PlotFromMA.R"; done

for i in EAA  ; do bsub -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/bsub/bsub2.$i.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/bsub/bsub2.$i.err -R"select[mem>20000] rusage[mem=20000]" -M20000 "/software/R-3.0.0/bin/R --no-save --args $i < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/PlotFromMA2.R"; done
for i in IAA  ; do bsub -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/bsub/bsub2.$i.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/bsub/bsub2.$i.err -R"select[mem>30000] rusage[mem=30000]" -M30000 "/software/R-3.0.0/bin/R --no-save --args $i < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/PlotFromMA2.R"; done
for i in HA; do bsub -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/bsub/bsub2.$i.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/bsub/bsub2.$i.err -R"select[mem>40000] rusage[mem=40000]" -M40000 "/software/R-3.0.0/bin/R --no-save --args $i < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/PlotFromMA2.R"; done
for i in AA; do bsub -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/bsub/bsub2.$i.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/bsub/bsub2.$i.err -R"select[mem>40000] rusage[mem=40000]" -M40000 "/software/R-3.0.0/bin/R --no-save --args $i < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/PlotFromMA2.R"; done
for i in EA   ; do bsub -G t35_magic -o /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/bsub/bsub2.$i.out -e /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/bsub/bsub2.$i.err -R"select[mem>50000] rusage[mem=50000]" -M50000 "/software/R-3.0.0/bin/R --no-save --args $i < /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/PlotFromMA2.R"; done


bjobs -l | grep args
bjobs -l | grep "MAX MEM"
tail -n1 bsub/bsub2.*.out


load( "/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/Plots/Outliers_AA.RData"  ) ; oAA  = mm3 ; rm(mm3)
load( "/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/Plots/Outliers_EA.RData"  ) ; oEA  = mm3 ; rm(mm3)
load( "/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/Plots/Outliers_HA.RData"  ) ; oHA  = mm3 ; rm(mm3)
load( "/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/Plots/Outliers_EAA.RData" ) ; oEAA = mm3 ; rm(mm3)
load( "/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/Plots/Outliers_IAA.RData" ) ; oIAA = mm3 ; rm(mm3)

# investigate oAA
plot( oAA$Freq1.x , oAA$Freq1.y )  ; abline(0,1) ; abline(0.2,1,col="orange") ; abline(-0.2,1,col="orange") ; abline(0.4,1,col="red") ; abline(-0.4,1,col="red")
plot( oAA$Freq1.y , oAA$eaf )  ; abline(0,1) ; abline(0.2,1,col="orange") ; abline(-0.2,1,col="orange") ; abline(0.4,1,col="red") ; abline(-0.4,1,col="red")

sum(is.na(oAA$Freq1.x))
sum(is.na(oAA$Freq1.y))
sum(is.na(oAA$eaf))

table(is.na(oAA$eaf),grepl("MERGED_DEL",oAA$MarkerName))
oAA[which(is.na(oAA$eaf) & !grepl("MERGED_DEL",oAA$MarkerName)),]

mm2 = oAA[ which(is.na(oAA$Freq1.x)),]


# investigate oEAA
sum(is.na(oEAA$Freq1.x))
sum(is.na(oEAA$Freq1.y))
sum(is.na(oEAA$eaf))

mm2 = oEAA
plot( mm2$Freq1.x , 1-mm2$eaf     , xlab="FG frequencies"    , ylab="1000G Frequencies" , main=aa ) ; abline(0,1) ; abline(0.2,1,col="orange") ; abline(-0.2,1,col="orange") ; abline(0.4,1,col="red") ; abline(-0.4,1,col="red")
wwF = which(  abs(mm2$Freq1.x-1+mm2$eaf)<0.1 )
points(mm2$Freq1.x[wwF] , 1-mm2$eaf[wwF] , col="green4" )
wwF = which(  abs(mm2$Freq1.x-1+mm2$eaf)<0.05 )
points(mm2$Freq1.x[wwF] , 1-mm2$eaf[wwF] , col="purple" )

write.table( cbind((mm2[wwF,1])) , file="/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/List_EAA_FG_wrongAbscisse.txt" , quote=F , row.names=F,col.names=F)

zcat /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_Decembre2015/METAL_FromVolunteers/Transethnic_1000G_FGluadjBMI_Raw_EAA1.tbl.gz | awk 'BEGIN {while((getline < "List_EAA_FG_wrongAbscisse.txt")>0){a[$1]=1 }} ; { if (a[$1]==1) {print $0} }' | bgzip -c > WrongAbscisse_Transethnic_1000G_FGluadjBMI_Raw_EAA1.tbl.gz
zcat /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_Decembre2015/METAL_FromVolunteers/EAA_FGluadjBMI_Raw_meta_LC_20151212_1.txt.gz | awk 'BEGIN {while((getline < "List_EAA_FG_wrongAbscisse.txt")>0){a[$1]=1 }} ; { if (a[$1]==1) {print $0} }' | bgzip -c > WrongAbscisse_EAA_FGluadjBMI_Raw_meta_LC_20151212_1.txt.gz

waJ = read.table(gzfile("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/WrongAbscisse_Transethnic_1000G_FGluadjBMI_Raw_EAA1.tbl.gz"),as.is=T)
waL = read.table(gzfile("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/STUDYfreq_vs_MAfreq/WrongAbscisse_EAA_FGluadjBMI_Raw_meta_LC_20151212_1.txt.gz"),as.is=T)

table( waJ$V11 == waL$V11 )

wa = merge( waJ[,c(1,11)],waL[,c(1,11)],by="V1")
table( wa$V11.x == wa$V11.y )

aaJ1 = sapply( waJ$V11, FUN=function(x){x1=strsplit(x,"")[[1]]; return( paste( x1[which(x1!="?")],collapse=";") )} )
aaJ2 = sapply( waJ$V11, FUN=function(x){x1=strsplit(x,"")[[1]]; return( paste( which(x1!="?"),collapse=";") )} )
aaL1 = sapply( waL$V11, FUN=function(x){x1=strsplit(x,"")[[1]]; return( paste( x1[which(x1!="?")],collapse=";") )} )
aaL2 = sapply( waL$V11, FUN=function(x){x1=strsplit(x,"")[[1]]; return( paste( which(x1!="?"),collapse=";") )} )

table( unlist(strsplit(aaJ1,";")) )
table( unlist(strsplit(aaJ2,";")) )
table( unlist(strsplit(aaJ1,";")) , unlist(strsplit(aaJ2,";")) )
table( unlist(strsplit(aaL1,";")) , unlist(strsplit(aaL2,";")) )


unique(unlist(strsplit(aaL2,";"))) # "3"  "4" "5"  "10" "11"  "15" "16"

cat /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_Decembre2015/METAL_FromVolunteers/EAA_FGluadjBMI_Raw_meta_LC_20151212_1.txt.info
# --> Input File 3 : ./input_files/FGluadjBMI_Raw/EAA_GWAS_A_FGluadjBMI_CAGEGWAS1_PLINK_14102014_FT
# --> Input File 4 : ./input_files/FGluadjBMI_Raw/EAA_GWAS_A_FGluadjBMI_CAGE-KING-Omni_MACH_03102014_MN
# --> Input File 5 : ./input_files/FGluadjBMI_Raw/EAA_GWAS_A_FGluadjBMI_CAGE-KING-Quad_MACH_03102014_MN
# --> Input File 10 : ./input_files/FGluadjBMI_Raw/EAA_GWAS_A_FGluadjBMI_VanderbiltGWAS6548_MACH2QTL_11092014_HMR
# --> Input File 11 : ./input_files/FGluadjBMI_Raw/EAA_GWAS_A_FGluadjBMI_VanderbiltLargeShanghai1_MACH2QTL_11092014_HMR
# --> Input File 15 : ./input_files/FGluadjBMI_Raw/EAA_GWAS_AX_FGluadjBMI_KARE_MACH2QTL_31102014_YJK
# --> Input File 16 : ./input_files/FGluadjBMI_Raw/EAA_GWAS_AX_FGluadjBMI_MESA_SNPTEST_29122014_JY

cat /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_Decembre2015/METAL_FromVolunteers/EAA_HbA1c_InvNorm_meta_LC_20151212_1.txt.info
# --> Input File 3 : ./input_files/HbA1c_InvNorm/EAA_GWAS_A_HbA1c_InvNorm_CAGEGWAS1_PLINK_16022015_FT.txt
# --> Input File 4 : ./input_files/HbA1c_InvNorm/EAA_GWAS_A_HbA1c_InvNorm_CAGE-KING-Omni_MACH_03102014_MN.txt
# --> Input File 5 : ./input_files/HbA1c_InvNorm/EAA_GWAS_A_HbA1c_InvNorm_CAGE-KING-Quad_MACH_03102014_MN.txt
# --> Input File 13 : ./input_files/HbA1c_InvNorm/EAA_GWAS_A_HbA1c_InvNorm_VanderbiltGWAS6548_MACH2QTL_11092014_HMR.txt
# --> Input File 16 : ./input_files/HbA1c_InvNorm/EAA_GWAS_AX_HbA1c_InvNorm_KARE_MACH2QTL_31102014_YJK.txt
# --> Input File 17 : ./input_files/HbA1c_InvNorm/EAA_GWAS_AX_HbA1c_InvNorm_MESA_SNPTEST_29122014_JY.txt

load( "/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/QC2_CENTRAL_results/EASYrep_CENT.RData" )
EASYrep_CENT[ which(EASYrep_CENT$Study %in% c("CAGEGWAS1","CAGE-KING-Omni","CAGE-KING-Quad","VanderbiltGWAS6548","VanderbiltLargeShanghai1","KARE","MESA") & EASYrep_CENT$Trait=="FGluadjBMI" & EASYrep_CENT$Transf=="Raw" & EASYrep_CENT$Chr %in% c("A","AX") & EASYrep_CENT$Ancestry=="EAA" ) , c(117:124)  ]


display /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/QC2_CENTRAL_results_AFplots/CENTRALLY_GWAS_ASN_FG_late_1_1.multi.AFCHECK.png
display /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/QC2_CENTRAL_results_AFplots/CENTRALLY_GWAS_ASN_FG_late_1_2.multi.AFCHECK.png
display /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/QC2_CENTRAL_results_AFplots/CENTRALLY_GWAS_ASN_FG_late_1_3.multi.AFCHECK.png






## Investigate High number of significant loci for raw FG IAA


zcat /lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_Decembre2015/METAL_FromVolunteers/Transethnic_1000G_FGluadjBMI_Raw_IAA1.tbl.gz | cut -f1,4,10,11,16 | bgzip -c > META_Dec2015_IAA_FG_raw.txt.gz

ff1=read.table(gzfile("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/META_Dec2015_IAA_FG_raw.txt.gz"),h=T,as.is=T)

source("/nfs/users/nfs_g/gm10/ScriptsFromMac/MYqq.chisq.R")

sum(ff1$P.value<0.00000001)
class(ff1$P.value)

lbd = median(qchisq(ff1$P.value,df=1,lower.tail=F),na.rm=T)/qchisq(0.5,df=1)
qq1=qchisq(ff1$P.value,1,lower.tail=F)
qq.chisq.GM(qq1,slope.lambda=T,slope.one=T,genomic.control=T)


max(ff1$TotalSampleSize)


table(ff1$P.value<1e-8 , ff1$TotalSampleSize<(max(ff1$TotalSampleSize)/3))
table(ff1$P.value<1e-8 , ff1$Freq1<0.05 | ff1$Freq1>0.95 )
table(ff1$P.value<1e-8 , ff1$Freq1<0.01 | ff1$Freq1>0.99 )

plot( ff1$Freq1 , -log10(ff1$P.value) , xlab="Frequency" , ylab="-log10(p)" )
abline(h=8,col="grey")
abline(v=c(0.05,0.95),col="green4")
abline(v=c(0.01,0.99),col="red")
title(main="FGluadjBMI raw - IAA - Frequencies vs p-values")
legend(x=0.4,y=300,legend=c("p-value = 10-8","MAF = 5%","MAF = 1%"),col=c("grey","green4","red"),lty=1)

plot( ff1$TotalSampleSize , -log10(ff1$P.value) , xlab="Sample Size" , ylab="-log10(p)" )
abline(h=8,col="grey")
title(main="FGluadjBMI raw - IAA - Sample size vs p-values")
abline(v=max(ff1$TotalSampleSize)/3,col="green4")
legend(x=3500,y=330,legend=c("p-value = 10-8","1/3 of the total sample size"),col=c("grey","green4"),lty=1)






################################################################
###   Effect vs Frequency for all novel and known signals
################################################################
# - Look for GCTA ancestry-specific signals
# - Extract their effect & frequency in ancestry-specific m-a results on RAW trait
# - Plot Effect (y-axis) vs Frequency (x-axis) per ancestry
# - Highlight in the plots
#     Novel signals (outside 500kb of any known loci for the trait) - red
#     Signals in 500kb of a known loci for the trait                - orange
#     Signals already known loci for the trait                      - green4
#     Known loci in clumped regions (and whether logBF>6)           - light blue
#     Known loci non-identified (not clumped)                       - blue










################################################################
###   Clunping on heterogeneity
################################################################


hetvariants = NULL
for ( aa in c("EA","AA","HA","IAA","EAA") )
{
 load( paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_interpretation/HeterogeneousVariants_",aa,"_HbA1c_InvNorm.RData",sep="") )
 ffH$Ancestry=aa
 hetvariants = rbind( hetvariants , ffH )
 rm(ffH)
} ; rm(aa)

table( hetvariants$Ancestry )

tp = sapply( hetvariants$MarkerName , FUN=function(x){x1=strsplit(x,":")[[1]] ; return(c(chr=x1[1],pos=x1[2])) } )
hetvariants$CHR = tp["chr",]
hetvariants$POS = as.numeric(tp["pos",])
rm(tp)

hetvariants$nClumpHet=0
hetvariants$HetSignal=0
wwNC = which(hetvariants$nClumpHet==0)
while( min(hetvariants$HetPVal[wwNC])<=1e-5 )
{
 #cat(">>> ")
 wwS = which(hetvariants$nClumpHet==0 & hetvariants$HetPVal==min(hetvariants$HetPVal[wwNC]))
 if( length(wwS)>1 )
 {
  #cat("More than one signal. ")
  wwS = wwS[ which(hetvariants$TotalSampleSize[wwS]==max(hetvariants$TotalSampleSize[wwS])) ]
  if(length(wwS)>1){ #cat("STILL More than one signal: ",paste(hetvariants$MarkerName[wwS],collapse=","),". ")
                     wwS=wwS[1]}
 }
 aa = hetvariants$Ancestry[wwS]
 chr = hetvariants$CHR[wwS]
 pos = hetvariants$POS[wwS]
 nClump=max(hetvariants$nClumpHet[which(hetvariants$Ancestry==aa)])+1
 wwC = which(hetvariants$nClumpHet==0 & hetvariants$Ancestry==aa & hetvariants$CHR==chr & hetvariants$POS>=(pos-500000) & hetvariants$POS<=(pos+500000))
 oo = sum( hetvariants$nClumpHet>0 & hetvariants$Ancestry==aa & hetvariants$CHR==chr & hetvariants$POS>=(pos-500000) & hetvariants$POS<=(pos+500000) )
 #cat(aa,"- clump n",nClump," - ",length(wwC),"markers - overlap with previous clump:",oo,".\n")
 hetvariants$nClumpHet[ wwC ] = nClump
 hetvariants$HetSignal[ wwS ] = 1
 rm(wwS,wwC,aa,chr,pos,nClump,oo)
 wwNC = which(hetvariants$nClumpHet==0)
}


table(hetvariants$HetSignal,hetvariants$P.value<5e-8)

tp = by( hetvariants[,c("MarkerName","CHR","HetSignal","P.value","HetPVal")] ,
         INDICES=as.factor(paste(hetvariants$Ancestry,hetvariants$nClumpHet,sep="_")) ,
         FUN=function(x){return( c( top_signal = x[which(x$HetSignal==1),"MarkerName"] ,
                                    n_signals_5=nrow(x) ,
                                    n_signals_8 = sum(x$HetPVal<1e-8) ,
                                    n_signals_10 = sum(x$HetPVal<1e-10) ,
                                    top_signal_assoc=ifelse(x[which(x$HetSignal==1),"P.value"]<5e-8,yes=1,no=0) ,
                                    chr = unique(x$CHR)
                                   )
                                )
                        }
       )

tp2 = as.data.frame(do.call(rbind,tp),stringsAsFactors=F) ; rm(tp)
tp2$n_signals_5        = as.numeric(tp2$n_signals_5)
tp2$n_signals_8        = as.numeric(tp2$n_signals_8)
tp2$n_signals_10       = as.numeric(tp2$n_signals_10)
tp2$top_signal_assoc = as.numeric(tp2$top_signal_assoc)

tt = sapply( row.names(tp2) , FUN=function(x){x1=strsplit(x,"_")[[1]] ; return(c(ancestry=x1[1],nClump=x1[2]))} )
tp2$ancestry = tt["ancestry",]
tp2$nClump   = as.numeric(tt["nClump",])
rm(tt)

table( tp2$n_signals_5>=5 )
table( tp2$n_signals_8>=5 )
table( tp2$n_signals_10>=5 )

table( tp2$top_signal_assoc , tp2$n_signals_5>=5 , tp2$ancestry )


table( tp2$top_signal_assoc , tp2$n_signals>=5 , tp2$chr=="X" )
tp2[which(tp2$chr=="X"),]


tp2[which(tp2$chr!="X" & tp2$top_signal_assoc==1 &  tp2$n_signals>=5),]


tp2[which(tp2$ancestry=="EAA" & tp2$nClump %in% 1:5),]
tp2[which(tp2$ancestry=="IAA" & tp2$nClump %in% 1:12),]
tp2[which(tp2$ancestry=="IAA" & tp2$n_signals_5>=5),]

tp2[which(tp2$ancestry=="EA" & tp2$nClump %in% 1:5),]
tp2[which(tp2$ancestry=="EA" & tp2$n_signals_5>=5),]

tp2[which(tp2$ancestry=="AA" & tp2$nClump %in% 1:5),]
tp2[which(tp2$ancestry=="AA" & tp2$n_signals_5>=5),]

tp2[which(tp2$ancestry=="HA" & tp2$nClump %in% 1:5),]
tp2[which(tp2$ancestry=="HA" & tp2$n_signals_5>=5),]



sum(tp2$chr!="X" & tp2$top_signal_assoc==0 &  tp2$n_signals_5>=5)
list_het_peaks = hetvariants$MarkerName[which( hetvariants$HetSignal==1 & paste(hetvariants$Ancestry,hetvariants$nClumpHet,sep="_") %in% row.names(tp2)[which(tp2$chr!="X" & tp2$top_signal_assoc==0 &  tp2$n_signals>=5)] )]
save( list_het_peaks , file="/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/FORESTPLOTS_data/list_het_peaks.RData" )
