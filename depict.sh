# Precomputed loci for each 1000 Genomes project SNPs
ls -1 /software/team35/DEPICT_v1_rel194/DEPICT/data/collections/ld0.5_collection_1000genomespilot_depict_150429.txt.gz

# The reconstituted gene set files used by DEPICT
ls -1 /software/team35/DEPICT_v1_rel194/DEPICT/data/reconstituted_genesets/reconstituted_genesets_example.txt

# The tissue expression matrix
ls -1 /software/team35/DEPICT_v1_rel194/DEPICT/data/tissue_expression/GPL570EnsemblGeneExpressionPerTissue_DEPICT20130820_z_withmeshheader.txt

# Mapping from tissue/cell type identifier to tissue name and information
ls -1 /software/team35/DEPICT_v1_rel194/DEPICT/data/tissue_expression/GPL570EnsemblGeneExpressionPerTissue_DEPICT20130820_z_withmeshheader_mapping.txt

# Gene annotation file
ls -1 /software/team35/DEPICT_v1_rel194/DEPICT/data/mapping_and_annotation_files/GPL570ProbeENSGInfo+HGNC_reformatted.txt


# Directory with precomputed background files
ls -1 /software/team35/DEPICT_v1_rel194/DEPICT/data/backgrounds | wc

# Mapping from gene set identifiers to gene set names
ls -1 /software/team35/DEPICT_v1_rel194/DEPICT/data/mapping_and_annotation_files/GO.terms_alt_ids_withoutheader.tab
ls -1 /software/team35/DEPICT_v1_rel194/DEPICT/data/mapping_and_annotation_files/VOC_MammalianPhenotype.rpt
ls -1 /software/team35/DEPICT_v1_rel194/DEPICT/data/mapping_and_annotation_files/inweb_mapping.tab

ls -1 /software/team35/DEPICT_v1_rel194/DEPICT/data/mapping_and_annotation_files/2012-08-08-IlluminaAll96PercentIdentity-ProbeAnnotation-ProbesWithWrongMappingLengthFilteredOut-EnsemblAnnotation.txt
ls -1 /software/team35/DEPICT_v1_rel194/DEPICT/data/mapping_and_annotation_files/eQTLProbesFDR0.05.txt






###############################################################
### RESULTS from METAL for DEPICT : keep a subset of the columns to create DEPICT inputs
###############################################################


load("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/METAL_VolunteersComparison/ListFiles.RData")

wwDone = which(ListFiles$Run==2 & !(is.na(ListFiles$Path1) & is.na(ListFiles$Path2)))
table(ListFiles$Transf[wwDone],ListFiles$Ancestry[wwDone],ListFiles$Trait[wwDone])

wwToOrder = which(ListFiles$Run==2 & !(is.na(ListFiles$Path1) & is.na(ListFiles$Path2)) & ListFiles$Transf=="InvNorm" & ListFiles$Ancestry=="EA" & ListFiles$Trait!="HbA1cadjFGlu")
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
 Pathout = paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/metal.relaxed",ListFiles$Trait[i],ListFiles$Transf[i],ListFiles$Ancestry[i],"txt.gz",sep=".")
 ll = paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/bsub/bsub",ListFiles$Trait[i],ListFiles$Transf[i],ListFiles$Ancestry[i],sep=".")
 command = paste("bsub -q normal -G t35_magic -o ",ll,".out -e ",ll,".err -R\"select[mem>50]  rusage[mem=50]\"  -M50 \"zcat ",Pathin," | awk '{   if(NR==1) { print \\\"SNP\\tChr\\tPos\\tP\\\" } else {  if(\\$6<0.00001) { split(\\$1,a,\\\":\\\") ; if(a[1]==\\\"X\\\") {a[1]=23} ; if(a[1]==\\\"Y\\\") {a[1]=24} ; if(a[1]==\\\"XY\\\") {a[1]=25} ; print \\$1\\\"\\t\\\"a[1]\\\"\\t\\\"a[2]\\\"\\t\\\"\\$6}}}' | bgzip -c > ",Pathout,"\"",sep="")
 #command = paste("zcat ",Pathin," | awk 'BEGIN {oo=0} ; { if($6<0.00000001) { oo=oo+1 } } ; END { print oo}' ",sep="")
 #print(command)
 system(command,intern=T)
 rm(PathVol,Pathin,Pathout,ll,command)
} ; rm(i)


grep Success /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/bsub/bsub*





###############################################################
### GWAS ONLY
###
### RESULTS from METAL for DEPICT : keep a subset of the columns to create DEPICT inputs
###############################################################



# create and submit the bsub command through R
for ( i in c("HbA1c","FGluadjBMI","FInsadjBMI","2hrGluadjBMI") )
{
 cat("---------------------------------------------------\n")
 cat("--->",i,"\n")
 Pathin = paste("/lustre/scratch113/projects/t35_magic/TRANSETHNIC_1000G/ellie/METAL_GWASonly/METAL_results/METAANALYSIS_GWAS_2_EA_",i,"_InvNorm1.tbl.gz",sep="")
 Pathout = paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/metal_GWASonly.relaxed",i,"InvNorm.EA.txt.gz",sep=".")
 ll = paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/bsub/bsub.GWASonly",i,"InvNorm.EA",sep=".")
 command = paste("bsub -q normal -G t35_magic -o ",ll,".out -e ",ll,".err -R\"select[mem>50]  rusage[mem=50]\"  -M50 \"zcat ",Pathin," | awk '{   if(NR==1) { print \\\"SNP\\tChr\\tPos\\tP\\\" } else {  if(\\$6<0.00001) { split(\\$1,a,\\\":\\\") ; if(a[1]==\\\"X\\\") {a[1]=23} ; if(a[1]==\\\"Y\\\") {a[1]=24} ; if(a[1]==\\\"XY\\\") {a[1]=25} ; print \\$1\\\"\\t\\\"a[1]\\\"\\t\\\"a[2]\\\"\\t\\\"\\$6}}}' | bgzip -c > ",Pathout,"\"",sep="")
 system(command,intern=T)
 rm(Pathin,Pathout,ll,command)
} ; rm(i)


grep Success /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/bsub/bsub.GWASonly*


###############################################################
### create config file for DEPICT
###############################################################

sed 's/XX/2hrGluadjBMI/g' /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/template.cfg | sed 's/YY/InvNorm/g' | sed 's/ZZ/EA/g' > /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/depict.2hrGluadjBMI.InvNorm.EA.cfg
sed 's/XX/FGluadjBMI/g'   /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/template.cfg | sed 's/YY/InvNorm/g' | sed 's/ZZ/EA/g' > /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/depict.FGluadjBMI.InvNorm.EA.cfg
sed 's/XX/FInsadjBMI/g'   /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/template.cfg | sed 's/YY/InvNorm/g' | sed 's/ZZ/EA/g' > /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/depict.FInsadjBMI.InvNorm.EA.cfg
sed 's/XX/HbA1c/g'        /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/template.cfg | sed 's/YY/InvNorm/g' | sed 's/ZZ/EA/g' > /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/depict.HbA1c.InvNorm.EA.cfg

cd /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/
sed 's/5e-8/1e-5/g' depict.HbA1c.InvNorm.EA.cfg        | sed 's/metal/metal.relaxed/g' | sed 's/depict.HbA1c.InvNorm.EA/depict.HbA1c.InvNorm.EA.relaxed/g'               > depict.HbA1c.InvNorm.EA.relaxed.cfg
sed 's/5e-8/1e-5/g' depict.FGluadjBMI.InvNorm.EA.cfg   | sed 's/metal/metal.relaxed/g' | sed 's/depict.FGluadjBMI.InvNorm.EA/depict.FGluadjBMI.InvNorm.EA.relaxed/g'     > depict.FGluadjBMI.InvNorm.EA.relaxed.cfg
sed 's/5e-8/1e-5/g' depict.FInsadjBMI.InvNorm.EA.cfg   | sed 's/metal/metal.relaxed/g' | sed 's/depict.FInsadjBMI.InvNorm.EA/depict.FInsadjBMI.InvNorm.EA.relaxed/g'     > depict.FInsadjBMI.InvNorm.EA.relaxed.cfg
sed 's/5e-8/1e-5/g' depict.2hrGluadjBMI.InvNorm.EA.cfg | sed 's/metal/metal.relaxed/g' | sed 's/depict.2hrGluadjBMI.InvNorm.EA/depict.2hrGluadjBMI.InvNorm.EA.relaxed/g' > depict.2hrGluadjBMI.InvNorm.EA.relaxed.cfg



sed 's/XX/2hrGluadjBMI/g' /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/template_Nov2016.cfg | sed 's/YY/InvNorm/g' | sed 's/ZZ/EA/g' > /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/depict.Nov2016.2hrGluadjBMI.InvNorm.EA.cfg
sed 's/XX/FGluadjBMI/g'   /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/template_Nov2016.cfg | sed 's/YY/InvNorm/g' | sed 's/ZZ/EA/g' > /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/depict.Nov2016.FGluadjBMI.InvNorm.EA.cfg
sed 's/XX/FInsadjBMI/g'   /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/template_Nov2016.cfg | sed 's/YY/InvNorm/g' | sed 's/ZZ/EA/g' > /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/depict.Nov2016.FInsadjBMI.InvNorm.EA.cfg
sed 's/XX/HbA1c/g'        /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/template_Nov2016.cfg | sed 's/YY/InvNorm/g' | sed 's/ZZ/EA/g' > /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/depict.Nov2016.HbA1c.InvNorm.EA.cfg



cp /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/template_Nov2016.cfg /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/template_GWASonly.cfg
sed 's/XX/2hrGluadjBMI/g' /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/template_GWASonly.cfg | sed 's/YY/InvNorm/g' | sed 's/ZZ/EA/g' > /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/depict.GWASonly.2hrGluadjBMI.InvNorm.EA.cfg
sed 's/XX/FGluadjBMI/g'   /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/template_GWASonly.cfg | sed 's/YY/InvNorm/g' | sed 's/ZZ/EA/g' > /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/depict.GWASonly.FGluadjBMI.InvNorm.EA.cfg
sed 's/XX/FInsadjBMI/g'   /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/template_GWASonly.cfg | sed 's/YY/InvNorm/g' | sed 's/ZZ/EA/g' > /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/depict.GWASonly.FInsadjBMI.InvNorm.EA.cfg
sed 's/XX/HbA1c/g'        /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/template_GWASonly.cfg | sed 's/YY/InvNorm/g' | sed 's/ZZ/EA/g' > /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/depict.GWASonly.HbA1c.InvNorm.EA.cfg


###############################################################
### run DEPICT
###############################################################

for x in 2hrGluadjBMI FGluadjBMI FInsadjBMI HbA1c; do for y in InvNorm; do for z in EA; do bsub -q normal -G t35_magic -o /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/bsub/bsub.depict.20160624.$x.$y.$z.out -e /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/bsub/bsub.depict.20160624.$x.$y.$z.err -R"select[mem>20000]  rusage[mem=20000]"  -M20000  "/software/python-2.7.10/bin/python /software/team35/DEPICT_v1_rel194/DEPICT/src/python/depict.py /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/depict.$x.$y.$z.cfg"; done; done; done
for x in 2hrGluadjBMI FGluadjBMI FInsadjBMI HbA1c; do for y in InvNorm; do for z in EA; do bsub -q normal -G t35_magic -o /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/bsub/bsub.depict.20160624.$x.$y.$z.out -e /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/bsub/bsub.depict.20160624.$x.$y.$z.err -R"select[mem>20000]  rusage[mem=20000]"  -M20000  "/software/python-2.7.10/bin/python /software/team35/DEPICT_v1_rel194/DEPICT/src/python/depict.py /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/depict.$x.$y.$z.relaxed.cfg"; done; done; done

for x in FInsadjBMI; do for y in InvNorm; do for z in EA; do bsub -q normal -G t35_magic -P t35_magic -o /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/bsub/bsub.depict.$(date +"%Y%m%d").$x.$y.$z.out -e /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/bsub/bsub.depict.$(date +"%Y%m%d").$x.$y.$z.err -R"select[mem>12000]  rusage[mem=12000]"  -M12000  "/software/python-2.7.10/bin/python /software/team35/DEPICT_v1_rel194/DEPICT/src/python/depict.py /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/depict.Nov2016.$x.$y.$z.cfg"; done; done; done
#2hrGluadjBMI FGluadjBMI  HbA1c

for x in FInsadjBMI 2hrGluadjBMI FGluadjBMI  HbA1c; do for y in InvNorm; do for z in EA; do bsub -q normal -G t35_magic -P t35_magic -o /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/bsub/bsub.depict.GWASonly.$(date +"%Y%m%d").$x.$y.$z.out -e /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/bsub/bsub.depict.GWASonly.$(date +"%Y%m%d").$x.$y.$z.err -R"select[mem>12000]  rusage[mem=12000]"  -M12000  "/software/python-2.7.10/bin/python /software/team35/DEPICT_v1_rel194/DEPICT/src/python/depict.py /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/depict.GWASonly.$x.$y.$z.cfg"; done; done; done


###############################################################
### results for tissue enrichment
###############################################################

# enrichment of 5e-8 results
tissue_hba1c  = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/outputs/depict.HbA1c.InvNorm.EA_tissueenrichment.txt",h=T,as.is=T,sep="\t")
tissue_2hrglu = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/outputs/depict.2hrGluadjBMI.InvNorm.EA_tissueenrichment.txt",h=T,as.is=T,sep="\t")
tissue_fglu   = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/outputs/depict.FGluadjBMI.InvNorm.EA_tissueenrichment.txt",h=T,as.is=T,sep="\t")
tissue_fins   = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/outputs/depict.FInsadjBMI.InvNorm.EA_tissueenrichment.txt",h=T,as.is=T,sep="\t")


# enrichment of 1e-5 results - Nov2016 results with right gene set enrichement analyses!
tissue_hba1c  = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/outputs/depict.Nov2016.HbA1c.InvNorm.EA.relaxed_tissueenrichment.txt",h=T,as.is=T,sep="\t")
tissue_2hrglu = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/outputs/depict.Nov2016.2hrGluadjBMI.InvNorm.EA.relaxed_tissueenrichment.txt",h=T,as.is=T,sep="\t")
tissue_fglu   = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/outputs/depict.Nov2016.FGluadjBMI.InvNorm.EA.relaxed_tissueenrichment.txt",h=T,as.is=T,sep="\t")
tissue_fins   = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/outputs/depict.Nov2016.FInsadjBMI.InvNorm.EA.relaxed_tissueenrichment.txt",h=T,as.is=T,sep="\t")

# quick comparison between 2 results
tissue_hba1c_old  = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/outputs/depict.HbA1c.InvNorm.EA.relaxed_tissueenrichment.txt",h=T,as.is=T,sep="\t")
mm=merge(tissue_hba1c_old[,2:6],tissue_hba1c[,c(2,5,6)],by="Name")
table(mm$False.discovery.rate.x,mm$False.discovery.rate.y)
plot(mm$Nominal.P.value.x,mm$Nominal.P.value.y) ; abline(0,1,col="grey")


table(tissue_hba1c$False.discovery.rate)
table(tissue_2hrglu$False.discovery.rate)
table(tissue_fglu$False.discovery.rate)
table(tissue_fins$False.discovery.rate)


tp=tissue_hba1c[ which(tissue_hba1c$False.discovery.rate %in% c("<0.01","<0.05","<0.20")) , 2:6 ] ; tp[order(tp$MeSH.second.level.term,tp$Nominal.P.value),] ; rm(tp)
tissue_fglu[ which(tissue_fglu$False.discovery.rate %in% c("<0.05","<0.20")) , 2:6 ]
tissue_fins[ which(tissue_fins$False.discovery.rate %in% c("<0.05","<0.20")) , 2:6 ]
tissue_2hrglu[ which(tissue_2hrglu$False.discovery.rate %in% c("<0.05","<0.20")) , 2:6 ]




tissue_hba1c[grep("lood",tissue_hba1c$MeSH.second.level.term),2:6]

tissue_fglu[which(tissue_fglu$MeSH.second.level.term %in% c("Liver","Pancreas")),2:6]
tissue_fins[which(tissue_fins$MeSH.second.level.term %in% c("Liver","Pancreas")),2:6]
tissue_2hrglu[which(tissue_2hrglu$MeSH.second.level.term %in% c("Liver","Pancreas")),2:6]

tissue_fins[grep("Connective Tissue",tissue_fins$MeSH.second.level.term),2:6]




tissue_to_plot = tissue_hba1c #  tissue_hba1c    tissue_fglu    tissue_fins    tissue_2hrglu
mtitle= "HbA1c - EA - enrichment of p<1e-5 meta-analysis results"
            #  "HbA1c - EA - enrichment of p<5e-8 meta-analysis results"
            #  "HbA1c - EA - enrichment of p<1e-5 meta-analysis results"
            #  "FGluadjBMI - EA - enrichment of p<5e-8 meta-analysis results"
            #  "FInsadjBMI - EA - enrichment of p<5e-8 meta-analysis results"
            #  "2hrGluadjBMI - EA - enrichment of p<5e-8 meta-analysis results"

oo = cbind(x=1:nrow(tissue_to_plot),original=order(tissue_to_plot$MeSH.second.level.term,tissue_to_plot$Nominal.P.value))
oo = oo[order(oo[,"original"]),]

tissue_to_plot$x = oo[,"x"] ; rm(oo)
tissue_to_plot$ost = as.numeric(as.factor(tissue_to_plot$MeSH.second.level.term))
tissue_to_plot$x2 = tissue_to_plot$x+(tissue_to_plot$ost-1)*5

clr=ifelse( tissue_to_plot$False.discovery.rate %in% c("<0.01","<0.05") , yes="red" , no=ifelse(tissue_to_plot$False.discovery.rate=="<0.20",yes="orange",no="black") )
par( mar=c(10,4,4,2)+0.1 )
plot( tissue_to_plot$x2 , -log10(tissue_to_plot$Nominal.P.value) , type="h" , col=clr , xaxt="n" , xlab="" , ylab="-log10(p) for tissue enrichment" , bty="n" , main=mtitle )
rm(clr,mtitle)
for ( mm in unique(tissue_to_plot$MeSH.second.level.term) )
{
 xs = min(tissue_to_plot$x2[which(tissue_to_plot$MeSH.second.level.term==mm)])-1
 xe = max(tissue_to_plot$x2[which(tissue_to_plot$MeSH.second.level.term==mm)])+1
 segments( xs , par("usr")[3] , xe , par("usr")[3] )
 rm(xs,xe)
} ; rm(mm)
lab = tapply( tissue_to_plot$x2 , INDEX=as.factor(tissue_to_plot$MeSH.second.level.term) , FUN=mean )
text( lab ,par("usr")[3] , labels=names(lab) , srt=45 , xpd=T , adj = c(1.1,1.1) )
rm(lab)
#abline(h=-log10(0.05/209),col="grey",lty=2)

rm(tissue_to_plot)

plot(1,1,xaxt="n",yaxt="n",bty="n")
legend("bottomleft",c("False positive rate (FPR) <0.05","FPR < 0.20","FPR > 0.20"),lty=1,lwd=2,col=c("red","orange","black"))


###############################################################
### results for gene prioritization
###############################################################
load( "/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/SIGNALS_LIST/Signal_list_allTraits_ToWrite1.RData" )

smr_hba1c  = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/SARA_ExpressionEnrichmentAnalyses/SMR_HbA1c_InvNorm_EA_withVEP.txt",h=T,as.is=T,sep="\t")
smr_2hrglu = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/SARA_ExpressionEnrichmentAnalyses/SMR_2hrGluadjBMI_InvNorm_EA_withVEP.txt",h=T,as.is=T,sep="\t")
smr_fglu   = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/SARA_ExpressionEnrichmentAnalyses/SMR_FGluadjBMI_InvNorm_EA_withVEP.txt",h=T,as.is=T,sep="\t")
smr_fins   = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/SARA_ExpressionEnrichmentAnalyses/SMR_FInsadjBMI_InvNorm_EA_withVEP.txt",h=T,as.is=T,sep="\t")

dim(smr_hba1c)
dim(smr_fglu)
dim(smr_fins)
dim(smr_2hrglu)

table( smr_hba1c$probeid %in% smr_fglu$probeid )
table( smr_hba1c$probeid %in% smr_fins$probeid )
table( smr_hba1c$probeid %in% smr_2hrglu$probeid )

table( smr_hba1c$snp %in% smr_fglu$snp )
table( smr_hba1c$snp %in% smr_fins$snp )
table( smr_hba1c$snp %in% smr_2hrglu$snp )



table( smr_fglu$p_smr<5e-6 , smr_fglu$p_het>1e-3 )
rr = smr_fglu[ which(smr_fglu$p_smr<5e-6 & smr_fglu$p_het>1e-3) , 1:21 ]
rr[order(rr$snp_chr,rr$snp_bp),]




par(mfrow=c(2,2))
smr = list(HbA1c=smr_hba1c,FGluadjBMI=smr_fglu,FInsadjBMI=smr_fins,x2hrGluadjBMI=smr_2hrglu)
names(smr)[4]="2hrGluadjBMI"
for ( i in 1:4 )
{
 plot( -log10(smr[[i]]$p_smr) , -log10(smr[[i]]$p_gwas) , main=names(smr)[i] , xlab="-log10(p_SMR)" , ylab="-log10(p_GWAS)" )
 abline(0,1,col="grey")
 abline(h=-log10(5e-6),v=-log10(5e-6),col="red")
} ; rm(i)

for ( i in 1:4 )
{
 plot( -log10(smr[[i]]$p_smr) , -log10(smr[[i]]$p_eqtl) , main=names(smr)[i] , xlab="-log10(p_SMR)" , ylab="-log10(p_eQTL)" )
 abline(0,1,col="grey")
 abline(h=-log10(5e-6),v=-log10(5e-6),col="red")
} ; rm(i)





genep_hba1c  = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/outputs/depict.Nov2016.HbA1c.InvNorm.EA.relaxed_geneprioritization.txt",h=T,as.is=T,sep="\t")
genep_2hrglu = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/outputs/depict.Nov2016.2hrGluadjBMI.InvNorm.EA.relaxed_geneprioritization.txt",h=T,as.is=T,sep="\t")
genep_fglu   = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/outputs/depict.Nov2016.FGluadjBMI.InvNorm.EA.relaxed_geneprioritization.txt",h=T,as.is=T,sep="\t")
genep_fins   = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/outputs/depict.Nov2016.FInsadjBMI.InvNorm.EA.relaxed_geneprioritization.txt",h=T,as.is=T,sep="\t")

table(genep_hba1c$False.discovery.rate)
table(genep_2hrglu$False.discovery.rate)
table(genep_fglu$False.discovery.rate)
table(genep_fins$False.discovery.rate)


genep_hba1c[ which(genep_hba1c$False.discovery.rate %in% c("<0.05","<0.20")) ,  ]

table(smr_fglu$p_smr<5e-6 , smr_fglu$p_het>5e-3 , smr_fglu$p_gwas<5e-8)
ff = smr_fglu[which(smr_fglu$p_smr<5e-6 & smr_fglu$p_het>5e-3),c(1,2,4,13,19,20,24,6,7)]
ff[order(ff$snp_chr,ff$snp_bp),]




final_wA[which(final_wA$trait=="HbA1c" & grepl("17:76",final_wA$MarkerName)),c("NN","trait","MarkerName","signalreason","pJ_WGHS",grep("_EA_",grep("METAL",colnames(final_wA),value=T),value=T))]



corrDEPICT_SMR=NULL
for ( trait in c("HbA1c","FGluadjBMI","FInsadjBMI","2hrGluadjBMI") )
{
 cat("--------\n",trait,"\n--------\n")
 smr     = read.table(paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/SARA_ExpressionEnrichmentAnalyses/SMR_",trait,"_InvNorm_EA_withVEP.txt",sep=""),h=T,as.is=T,sep="\t")
 depict  = read.table(paste("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/outputs/depict.Nov2016.",trait,".InvNorm.EA.relaxed_geneprioritization.txt",sep=""),h=T,as.is=T,sep="\t")

 tp = sapply( depict$Chromosome.and.position , FUN=function(x){x1=strsplit(x,":")[[1]] ; x2=strsplit(x1[2],"-")[[1]] ; return(c(C=as.numeric(sub("chr","",x1[1])),S=as.numeric(x2[1]),E=as.numeric(x2[2])))} )
 depict$chr=tp["C",]
 depict$start=tp["S",]
 depict$end=tp["E",]
 rm(tp)
 corrTP = NULL
 r_depict = unique(depict[,c("Chromosome.and.position","chr","start","end")])
 for ( i in 1:nrow(r_depict) )
 {
   ww = which(smr$snp_chr==r_depict$chr[i] & smr$snp_bp>=(r_depict$start[i]-200000) & smr$snp_bp<=(r_depict$end[i]+200000) )
   if( length(ww)>0 )
   {
    corrTP=rbind(corrTP,cbind(DEPICT=which(depict$Chromosome.and.position==r_depict$Chromosome.and.position[i]),SMR=ww))
   } else {
            corrTP=rbind(corrTP,cbind(DEPICT=which(depict$Chromosome.and.position==r_depict$Chromosome.and.position[i]),SMR=NA))
          }
   rm(ww)
 } ; rm(i)
 print(table( which(smr$p_smr<5e-6 & smr$p_het>1e-3) %in% corrTP[,"SMR"]))
 print(table( 1:nrow(depict) %in% corrTP[,"DEPICT"]))
 colnames(depict) = paste("DEPICT_",colnames(depict),sep="")
 colnames(smr) = paste("SMR_",colnames(smr),sep="")
 corrTP_2 = cbind( trait=trait , corrTP , depict[corrTP[,"DEPICT"],] , smr[corrTP[,"SMR"],])
 corrDEPICT_SMR = rbind( corrDEPICT_SMR , corrTP_2 )
 rm(depict,r_depict,smr,corrTP,corrTP_2)
} ; rm(trait)


table( corrDEPICT_SMR$DEPICT_False.discovery.rate )
table(corrDEPICT_SMR$DEPICT_False.discovery.rate,toupper(corrDEPICT_SMR$DEPICT_Gene.symbol)==toupper(corrDEPICT_SMR$SMR_gene))



###############################################################
### results for gene set enrichment
###############################################################

geneset_hba1c  = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/outputs/depict.Nov2016.HbA1c.InvNorm.EA.relaxed_genesetenrichment.txt",h=T,as.is=T,sep="\t",quote="")
geneset_2hrglu = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/outputs/depict.Nov2016.2hrGluadjBMI.InvNorm.EA.relaxed_genesetenrichment.txt",h=T,as.is=T,sep="\t",quote="")
geneset_fglu   = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/outputs/depict.Nov2016.FGluadjBMI.InvNorm.EA.relaxed_genesetenrichment.txt",h=T,as.is=T,sep="\t",quote="")
geneset_fins   = read.table("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/outputs/depict.Nov2016.FInsadjBMI.InvNorm.EA.relaxed_genesetenrichment.txt",h=T,as.is=T,sep="\t",quote="")

dim(geneset_hba1c)
dim(geneset_2hrglu)
dim(geneset_fglu)
dim(geneset_fins)

table(geneset_hba1c$False.discovery.rate)
table(geneset_2hrglu$False.discovery.rate)
table(geneset_fglu$False.discovery.rate)
table(geneset_fins$False.discovery.rate)


table( substr(geneset_hba1c$Original.gene.set.ID,1,3) , geneset_hba1c$False.discovery.rate )
table( substr(geneset_fglu$Original.gene.set.ID,1,3) , geneset_fglu$False.discovery.rate)
table( substr(geneset_fins$Original.gene.set.ID,1,3) , geneset_fins$False.discovery.rate)
table( substr(geneset_2hrglu$Original.gene.set.ID,1,3) , geneset_2hrglu$False.discovery.rate)


table( geneset_hba1c$False.discovery.rate , substr(geneset_hba1c$Original.gene.set.ID,1,3) )
table( geneset_fglu$False.discovery.rate , substr(geneset_fglu$Original.gene.set.ID,1,3) )
table( geneset_fins$False.discovery.rate , substr(geneset_fins$Original.gene.set.ID,1,3) )
table( geneset_2hrglu$False.discovery.rate , substr(geneset_2hrglu$Original.gene.set.ID,1,3) )




head( geneset_2hrglu[which(substr(geneset_2hrglu$Original.gene.set.ID,1,2) %in% c("MP","RE","KE","GO")),1:4] )



geneset_hba1c[which(geneset_hba1c$Nominal.P.value<5e-6),1:4]
geneset_fglu[which(geneset_fglu$False.discovery.rate=="<0.01"),1:4]
geneset_fins[which(geneset_fins$False.discovery.rate=="<0.01"),1:4]






geneset_hba1c[which(geneset_hba1c$False.discovery.rate %in% c("<0.01","<0.05") & substr(geneset_hba1c$Original.gene.set.ID,1,3)=="KEG" ),1:4]
geneset_fglu[which(geneset_fglu$False.discovery.rate %in% c("<0.01","<0.05") & substr(geneset_fglu$Original.gene.set.ID,1,3)=="KEG" ),1:4]
geneset_fins[which(geneset_fins$False.discovery.rate %in% c("<0.01","<0.05") & substr(geneset_fins$Original.gene.set.ID,1,3)=="KEG" ),1:4]

geneset_hba1c[which(geneset_hba1c$False.discovery.rate %in% c("<0.01","<0.05") & substr(geneset_hba1c$Original.gene.set.ID,1,3)=="REA" ),1:4]
geneset_fglu[which(geneset_fglu$False.discovery.rate %in% c("<0.01","<0.05") & substr(geneset_fglu$Original.gene.set.ID,1,3)=="REA" ),1:4]
geneset_fins[which(geneset_fins$False.discovery.rate %in% c("<0.01","<0.05") & substr(geneset_fins$Original.gene.set.ID,1,3)=="REA" ),1:4]

geneset_hba1c[which(geneset_hba1c$False.discovery.rate %in% c("<0.01","<0.05") & substr(geneset_hba1c$Original.gene.set.ID,1,2)=="GO" ),1:4]
geneset_fglu[which(geneset_fglu$False.discovery.rate %in% c("<0.01","<0.05") & substr(geneset_fglu$Original.gene.set.ID,1,2)=="GO" ),1:4]
geneset_fins[which(geneset_fins$False.discovery.rate %in% c("<0.01","<0.05") & substr(geneset_fins$Original.gene.set.ID,1,2)=="GO" ),1:4]

geneset_hba1c[which(geneset_hba1c$False.discovery.rate %in% c("<0.01","<0.05") & substr(geneset_hba1c$Original.gene.set.ID,1,2)=="MP" ),1:4]
geneset_fglu[which(geneset_fglu$False.discovery.rate %in% c("<0.01","<0.05") & substr(geneset_fglu$Original.gene.set.ID,1,2)=="MP" ),1:4]
geneset_fins[which(geneset_fins$False.discovery.rate %in% c("<0.01","<0.05") & substr(geneset_fins$Original.gene.set.ID,1,2)=="MP" ),1:4]



FUNw = function(x,rr=c()){ x1=gsub("/"," ",gsub(":"," ",gsub("_"," ",tolower(x)))) ; x2=unlist(strsplit(x1," ")) ; return(x2[which(!(x2 %in% rr))]) }

whb1 = geneset_hba1c[ which(geneset_hba1c$False.discovery.rate  %in% c("<0.01","<0.05") & substr(geneset_hba1c$Original.gene.set.ID ,1,3)!="ENS" ),"Original.gene.set.description"]
wfg1 = geneset_fglu[  which(geneset_fglu$False.discovery.rate   %in% c("<0.01","<0.05") & substr(geneset_fglu$Original.gene.set.ID  ,1,3)!="ENS" ),"Original.gene.set.description"]
wfi1 = geneset_fins[  which(geneset_fins$False.discovery.rate   %in% c("<0.01","<0.05") & substr(geneset_fins$Original.gene.set.ID  ,1,3)!="ENS" ),"Original.gene.set.description"]
w2g1 = geneset_2hrglu[which(geneset_2hrglu$Nominal.P.value<0.001 & substr(geneset_2hrglu$Original.gene.set.ID,1,3)!="ENS" ),"Original.gene.set.description"]


RR = c("kegg","reactome","amount","during","partial","level","of","decreased","positive","abnormal","increased","and","number","to","by","on","small")

whb2=FUNw(whb1,rr=RR) ; whbt=table(whb2) ; whbt=whbt[order(whbt,decreasing=T)] ; whb3=paste(names(whbt),whbt,sep=":") ; cbind(whb3)
wfg2=FUNw(wfg1,rr=RR) ; wfgt=table(wfg2) ; wfgt=wfgt[order(wfgt,decreasing=T)] ; wfg3=paste(names(wfgt),wfgt,sep=":") ; cbind(wfg3)
wfi2=FUNw(wfi1,rr=RR) ; wfit=table(wfi2) ; wfit=wfit[order(wfit,decreasing=T)] ; wfi3=paste(names(wfit),wfit,sep=":") ; cbind(wfi3)
w2g2=FUNw(w2g1,rr=RR) ; w2gt=table(w2g2) ; w2gt=w2gt[order(w2gt,decreasing=T)] ; w2g3=paste(names(w2gt),w2gt,sep=":") ; cbind(w2g3)

grep("red",whb1,value=T,ignore.case=T)
grep("beta",w2g1,value=T,ignore.case=T)



###############################################################
### DEPICT for Neneh
###############################################################
# /lustre/scratch113/teams/barroso/shared/DEPICT_Neneh


sed 's/XX/k81/g'   /lustre/scratch113/teams/barroso/shared/DEPICT_Neneh/inputs/template.cfg > /lustre/scratch113/teams/barroso/shared/DEPICT_Neneh/inputs/depict.k81.cfg
sed 's/XX/kshv/g'  /lustre/scratch113/teams/barroso/shared/DEPICT_Neneh/inputs/template.cfg > /lustre/scratch113/teams/barroso/shared/DEPICT_Neneh/inputs/depict.kshv.cfg
sed 's/XX/orf73/g' /lustre/scratch113/teams/barroso/shared/DEPICT_Neneh/inputs/template.cfg > /lustre/scratch113/teams/barroso/shared/DEPICT_Neneh/inputs/depict.orf73.cfg



#orf73
for x in k81 kshv  ; do bsub -q normal -G team35-grp -o /lustre/scratch113/teams/barroso/shared/DEPICT_Neneh/bsub/bsub.depict.20161102.$x.out -e /lustre/scratch113/teams/barroso/shared/DEPICT_Neneh/bsub/bsub.depict.20161102.$x.err -n2 -R"span[hosts=1] select[mem>12000]  rusage[mem=12000]"  -M12000  "/software/python-2.7.10/bin/python /software/team35/DEPICT_v1_rel194/DEPICT/src/python/depict.py /lustre/scratch113/teams/barroso/shared/DEPICT_Neneh/inputs/depict.$x.cfg"; done

#



###############################################################
### shuffle HbA1c results for Tune
###############################################################

hh = read.table(gzfile("/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/metal.HbA1c.InvNorm.EA.txt.gz"),as.is=T,h=T)
hh$Ps = sample(hh$P)


summary(hh$P)
summary(hh$Ps)
min(hh$P)
min(hh$Ps)
max(hh$P)
max(hh$Ps)
plot( -log10(hh$P), -log10(hh$Ps) ) ; abline(0,1,col="grey")

hh2 = hh[ sample(1:nrow(hh),2000) , -c(4) ]
colnames(hh2)[4] = "P"

write.table( hh2 , "/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/metal.forTune.txt" , quote=F , row.names=F , sep="\t" )


bsub -q normal -G t35_magic -o /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/bsub/bsub.depict.20160909.TEST.out -e /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/bsub/bsub.depict.20160909.TEST.err -R"select[mem>20000]  rusage[mem=20000]"  -M20000  "/software/python-2.7.10/bin/python /software/team35/DEPICT_v1_rel194/DEPICT/src/python/depict.py /lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/gaelle/METAANALYSIS_February2016/DEPICT/inputs/depict.forTune.cfg"
