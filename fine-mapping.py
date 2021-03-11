#! /usr/bin/python

import sys,gzip,glob
from subprocess import Popen, PIPE

if len(sys.argv)!=4:
    exit('usage: python finemapping_input.py trait pop region')
else:
    pass

trait,pop,region=sys.argv[1:]
sz_rt=0.9
flank=500000

#trait,pop,region=['FInsadjBMI','EA','19_6625519_7625519']

trait_pop=trait+'_'+pop

if pop=='UAA':
    pop1='Uganda'
else:
    pop1=pop

summary_stats_link='/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/jc34/Clean_signal/Finemap/Results/summary_gwas_list'
signal_file='/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/jc34/Clean_signal/signal_list_Feb2017'
LD_dir='/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/jc34/Clean_signal/Finemap/LD_matrix/'+pop+'_LD/'
outdir='/lustre/scratch115/projects/t35_magic/TRANSETHNIC_1000G/jc34/Clean_signal/Finemap/Results/'+trait_pop+'/'

chrn,pos_bn,pos_en=[int(x) for x in region.split('_')]
chrn=str(chrn)

LD_regions=glob.glob(LD_dir+'*map')
for regioni in LD_regions:
    regiontt=regioni.split('.')[0]
    region_chr,region_posb,region_pose=regiontt.split('/')[-1].split('_')
    if region_chr==chrn and int(region_posb)<=pos_bn and int(region_pose)>=pos_en:
        LD_file=regiontt
    else:
        pass

path_all={}
with open(summary_stats_link,'r') as fr:
    header=fr.readline().split()
    traitn,popn,pathn=[header.index(x) for x in ['Trait','Ancestry','Path']]
    for line in fr:
        tt=line.split()
        if len(tt)==0:
            pass
        else:
            path_all[tt[traitn]+'_'+tt[popn]]=tt[pathn]

try:
    path=path_all[trait_pop]
except KeyError:
    exit('Trait or ancestry is not found!')
else:
    pass

ld_snp=[]
with open(LD_file+'.map','r') as fr:
    header=fr.readline().split()
    markn=header.index('Marker')
    for line in fr:
        ld_snp.append(line.split()[markn])

signals={}
signal_all_pos=[]
with open(signal_file,'r') as fr:
    header=fr.readline().split('\t')
    traitn,chrtn,postn,signal_reasonn,transn,ancestryn,a1n,a2n=[header.index(x) for x in ['trait','Chr','Pos','signalreason','Transethnic_Decision','AS_Decision','Allele1','Allele2']]
    for line in fr:
        tt=line.split('\t')
        if len(tt)>1:
            chri=tt[chrtn]
            if chri=='X':
                chri='23'
            else:
                pass
            if ('OK' in tt[transn] or 'OK' in tt[ancestryn]) and chri==chrn and int(tt[postn])>=pos_bn and int(tt[postn])<=pos_en:
                a1i=tt[a1n].upper()
                a2i=tt[a2n].upper()
                if len(a1i)>len(a2i):
                    a1i,a2i=['I','D']
                elif len(a1i)<len(a2i):
                    a1i,a2i=['D','I']
                else:
                    pass
                marker='_'.join([str(chri),tt[postn],a2i,a1i])
                marker1='_'.join([str(chri),tt[postn],a1i,a2i])
                signal_all_pos.append(int(tt[postn]))
                reason_list=tt[signal_reasonn].split(',')
                try:
                    indexi=ld_snp.index(marker)
                except ValueError:
                    try:
                        indexi=ld_snp.index(marker1)
                    except ValueError:
                        print('no LD for '+tt[signal_reasonn]+' '+tt[traitn]+' signal: '+marker+'\n')
                    else:
                        if trait==tt[traitn] and (pop1 in reason_list or pop1+'(dist)' in reason_list or pop1+'(LD)' in reason_list):
                            signals[indexi]=marker1
                        else:
                            pass
                else:
                    if trait==tt[traitn] and (pop1 in reason_list or pop1+'(dist)' in reason_list or pop1+'(LD)' in reason_list):
                        signals[indexi]=marker
                    else:
                        pass
            else:
                pass
        else:
            pass

if len(signal_all_pos)==0:
    exit('No signal in 500Kb region '+region+'\n')
else:
    pass

signal_all_pos=sorted(signal_all_pos)

regions=[pos_bn,pos_en,[],0.0]

z_snp={}
with gzip.open(path,'rt') as fr:
    header=fr.readline().split()
    markn,a1n,a2n,a1fn,ezn,sdn,pvn,szn=[header.index(x) for x in['MarkerName','Allele1','Allele2','Freq1','Effect','StdErr','P-value','TotalSampleSize']]
    for line in fr:
        tt=line.split()
        chri,posi=tt[markn].split(':')[0:2]
        if chri=='X':
            chri='23'
            posi=int(posi)
        else:
            posi=int(posi)
        if chri!=chrn or posi>pos_en or posi<pos_bn:
            pass
        else:
            a1i=tt[a1n].upper()
            a2i=tt[a2n].upper()
            a1fi=float(tt[a1fn])
            ezi=float(tt[ezn])
            sdi=float(tt[sdn])
            zscorei=ezi/sdi
            pvi=tt[pvn]
            szi=float(tt[szn])
            snp='_'.join([chri,str(posi),a2i,a1i])
            snp1='_'.join([chri,str(posi),a1i,a2i])
            try:
                indexi=ld_snp.index(snp)
            except ValueError:
                try:
                    indexi=ld_snp.index(snp1)
                except ValueError:
                    pass
                else:
                    z_snp[indexi]=[snp1+' '+str(-zscorei),szi,posi]
                    if posi>=regions[0] and posi<=regions[1]:
                        if indexi in signals.keys():
                            regions[2].append(szi)
                        else:
                            pass
                        if szi>regions[3]:
                            regions[3]=szi
                        else:
                            pass
                    else:
                        pass
            else:
                z_snp[indexi]=[snp+' '+str(zscorei),szi,posi]
                if posi>=regions[0] and posi<=regions[1]:
                    if indexi in signals.keys():
                        regions[2].append(szi)
                    else:
                        pass
                    if szi>regions[3]:
                        regions[3]=szi
                    else:
                        pass
                else:
                    pass

index_all=sorted(z_snp.keys())

if(len(regions[2]))>0:
    causaln=len(regions[2])+2
    sz_rt_out=str(len(regions[2]))+'_'+str(len([x for x in regions[2] if x<(regions[3]*sz_rt)]))
else:
    sz_rt_out='0_0'
    causaln=2

index_sz=[x for x in index_all if z_snp[x][2] in signal_all_pos or z_snp[x][1]>=(regions[3]*sz_rt) and z_snp[x][2]>=regions[0] and z_snp[x][2]<=regions[1]]#force lead variants included
namet=chrn+'_'+str(regions[0])+'_'+str(regions[1])+'_'+str(sz_rt_out)
with open(outdir+namet+'.finemap','w') as fw:
    fw.write("z;ld;snp;config;k;log;n-ind\n{0}.finemap.z;{0}.finemap.ld;{0}.finemap.snp;{0}.finemap.config;{0}.finemap.k;{0}.finemap.log;{1}\n".format(outdir+namet,int(regions[3])))

regions[2]=index_sz
regions[3]=sz_rt
cmd="bsub -G zuluds -oo {0}.finemap.log.1 -R'select[mem>{1}] rusage[mem={1}]' -M{1} ~/finemap_v1.1_x86_64/finemap --sss --in-files {0}.finemap --regions 1 --n-causal-max {2} --log {0}.finemap.log --corr-config 0.9".format(outdir+namet,causaln*1000,causaln)

k=0
with gzip.open(LD_file+'.ld.gz','rt') as fr, open(outdir+namet+'.finemap.z','w') as fwz, open(outdir+namet+'.finemap.ld','w') as fwld:
    for line in fr:
        tt=line.split()
        if k in regions[2]:
            fwz.write(z_snp[k][0]+' '+str(z_snp[k][1])+'\n')
            ldk=' '.join([tt[x] if tt[x]!='NA' else '0' for x in regions[2]])
            fwld.write(ldk+'\n')
        k=k+1

# run=Popen([cmd], shell=True,stdin=None, stdout=PIPE, stderr=PIPE, close_fds=True)
# print(cmd+'\n'+'\n'.join(run.communicate()))
