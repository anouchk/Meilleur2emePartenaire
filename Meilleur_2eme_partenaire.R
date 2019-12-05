
library(data.table)

#set working directory
setwd('/Users/analutzky/Desktop/UMR_CNRS/dep3_par_etab')

Table_UMR=fread('/Users/analutzky/Desktop/UMR_CNRS/dep1_dotations/UMR_tableau_global_avec_nb_et_liste_tutelles_ou_partenariats.csv')

var.names=colnames(Table_UMR)
colnames(Table_UMR)=make.names(var.names)


Table_UMR
# Subtilité 1 : On ne prend que les UMR, USR, UPR, ERL et FRE (on laisse de côté des UMS, UMI, FR)
# Subtilité 2 : on ne regarde que les tutelles (pas les partenariats institutionnels, dits aussi "tutelles secondaires")
Table_UMR=Table_UMR[type.d.unité%in%c('UMR','UPR','USR','ERL','FRE') & Type.partenariat=='Tutelle',]

# on sort toutes les paires détablissement qui on un UMR en commun
Table_2MP=Table_UMR[,.(associated_etab=strsplit(ListeTutelles,',')[[1]], liste_tutellles= ListeTutelles, Type_etab=type.d.établissement),by=.(Code.Unité.au.31.12.2018,nom.court)]

# on enlève les paires avec 2 fois le même etablissement
Table_2MP=Table_2MP[associated_etab!=nom.court,]

write.csv2(as.data.frame(Table_2MP),file='UMR_deuxieme_meilleur_partenaire.csv',fileEncoding = "UTF8")


#tableau croisé dynamique pour sorbonne U
Table_2MP[nom.court=='Sorbonne U',length(Code.Unité.au.31.12.2018),by=associated_etab]

#tableau croisé dynamique pour tout le monde
TCD=Table_2MP[,length(Code.Unité.au.31.12.2018),by=.(associated_etab, nom.court)]
# on l'ordonne en mettant tous les nom court identiques l'un après l'autre, dans l'ordre décroissant des meilleurs partenanries
TCD[order(nom.court,-V1),]