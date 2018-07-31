library(readr)
# setwd('~/Projects/lookup_coordinates/')
CCDS_20180614 <- read_delim("CCDS.20180614.txt", "\t", escape_double = FALSE, trim_ws = TRUE,
                            col_types = cols(`#chromosome` = 'c',
                                                  nc_accession = 'c',
                                                  gene = 'c',
                                                  gene_id = 'i',
                                                  ccds_id = 'c',
                                                  ccds_status = 'c',
                                                  cds_strand = 'c',
                                                  cds_from = 'i',
                                                  cds_to = 'i',
                                                  cds_locations = 'c',
                                                  match_type = 'c'))

library(dplyr)
public <- filter(CCDS_20180614,ccds_status == 'Public')

#check if the first entry is the longest
check_largest <- function(x){if(x[1]==max(x)) {return(1)} else {return(0)}}
check_res <- group_by(public,gene) %>% summarise(check = check_largest(cds_to))
which(check_res$check != 1) ## not always first

#uniq <- group_by(public,gene) %>% summarise_all(funs(first))

uniq <- group_by(public,gene) %>% summarise(cds_start = min(cds_from),cds_end = max(cds_to),`#chromosome`=paste(unique(`#chromosome`),collapse='_'))
unique(uniq$`#chromosome`) ## there is "X_Y"

filter(uniq,`#chromosome`=='X_Y') ## 18 genes
XYgenes <- filter(uniq,`#chromosome`=='X_Y') $gene

## apparently some genes are only on X, but entry is wrong
filter(public,gene=='ZBED1')

## and some on both X and Y.
filter(public,gene=='SPRY3')

## for 3 genes, need to create entry on both X and Y.
uniq <- group_by(public,gene,`#chromosome`) %>% summarise(cds_min = min(cds_from),cds_max = max(cds_to))

## manually remove the genes which are using X coordinates but have chromosome Y entry
remove <- c('IL9R','SPRY3','VAMP7')
XYgenes <- XYgenes [!XYgenes %in% remove]
uniq <- filter(uniq, !(gene %in% XYgenes & `#chromosome` == 'Y'))

final <- data.frame(uniq, gene_id = public$gene_id[match(uniq$gene, public$gene)])
colnames(final) <- c('gene_symbol','reference_name','cds_start_min','cds_end_max','gene_entrez_id')
final <- final[,c('gene_symbol','gene_entrez_id','reference_name','cds_start_min','cds_end_max')]
write.table(final,'table.tsv',quote = F, sep='\t',row.names = F)
