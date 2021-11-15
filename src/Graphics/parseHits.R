################################################################################

# load packages
require(magrittr)
require(tidyverse)

################################################################################

# load alignment hits
dmfile <- paste0( statsDir, '/diamondHits.csv' )
diamondHits <- read_csv(dmfile)

################################################################################

# patch subspecies names
diamondHits$treeLink <- diamondHits$species
diamondHits[!is.na(diamondHits$subspecies), 'treeLink'] <- diamondHits[!is.na(diamondHits$subspecies), 'subspecies']

diamondHits[diamondHits$Species == 'Canis_lupus_dingo_alpine_ecotype', 'treeLink'] <- 'Canis lupus dingo alpine ecotype'
diamondHits[diamondHits$Species == 'Canis_lupus_dingo_desert_ecotype', 'treeLink'] <- 'Canis lupus dingo desert ecotype'
diamondHits[diamondHits$Species == 'Canis_lupus_familiaris_Basenji', 'treeLink'] <- 'Canis lupus familiaris Basenji'
diamondHits[diamondHits$Species == 'Canis_lupus_familiaris_German_Shepherd', 'treeLink'] <- 'Canis lupus familiaris German Shepherd'

# replace no hits
diamondHits %<>% mutate(hits = na_if(hits, 0))

################################################################################

# TODO: annotate placental types manually according to reference
# add placental type label
placentalTypes <- c('Epitheliochorial', 'Synepitheliochorial', 'Endotheliochorial', 'Haemochorial')
diamondHits$placentalType <- sample(placentalTypes, dim(diamondHits)[1], replace = TRUE)

################################################################################

# assign taxonomic names
# empty list
gr <- list()

# targeted suborders
suborders <- c('Carnivora', 'Primates')

# targeted families
families <- c('Ruminantia')

# add group color
diamondHits$treeGroup <- diamondHits$Order
diamondHits$treeGroup[diamondHits$Order %in% suborders] <- diamondHits$Suborder[diamondHits$Order %in% suborders]
diamondHits$treeGroup[diamondHits$Suborder %in% families] <- diamondHits$Family[diamondHits$Suborder %in% families]

# collect taxomonic names
tbOrder <- diamondHits %>% filter(!(Order %in% suborders)) %>% filter(!(Suborder %in% families)) %$% table(Order)
tbSuborder <- diamondHits %>% filter(Order %in% suborders) %$% table(Suborder)
tbFamily <- diamondHits %>% filter(Suborder %in% families) %$% table(Family)

# iteratate over order
for ( ι in seq_along(tbOrder) ) {
  gr[[ι]] <- diamondHits$treeLink[diamondHits$Order == names(tbOrder)[ι] & !(diamondHits$Suborder %in% families)]
  names(gr)[ι] <- names(tbOrder)[ι]
}

# iterate over suborders
for ( ι in seq_along(tbSuborder) ) {
  gr[[ι + length(tbOrder)]] <- diamondHits$treeLink[diamondHits$Suborder == names(tbSuborder)[ι] & !is.na(diamondHits$Suborder)]
  names(gr)[ι + length(tbOrder)] <- names(tbSuborder)[ι]
}

# iterate over families
for ( ι in seq_along(tbFamily) ) {
  gr[[ι + length(tbOrder) + length(tbSuborder)]] <- diamondHits$treeLink[diamondHits$Family == names(tbFamily)[ι]]
  names(gr)[ι + length(tbOrder) + length(tbSuborder)] <- names(tbFamily)[ι]
}

# group by taxonomic unit
syncytinTree <- groupOTU(syncytinTree, gr)

################################################################################

# taxon coloring
taxonColors <- c(
  'Artiodactyla' = 'skyblue4',
  'Chiroptera' = 'yellow3',
  'Dasyuromorphia' = 'green4',
  'Didelphimorphia' = 'sandybrown',
  'Diprotodontia' = 'gold1',
  'Hyracoidea' = 'dodgerblue2',
  'Lagomorpha' = 'purple1',
  'Perissodactyla' = 'palegreen2',
  'Pholidota' = 'red4',
  'Pilosa' = 'gray70',
  'Proboscidea' = 'yellow3',
  'Rodentia' = 'navy',
  'Sirenia' = 'maroon',
  'Struthioniformes' = 'orchid1',
  'Tubulidentata' = 'deeppink1',
  'Caniformia' = 'darkorange4',
  'Feliformia' = 'seagreen4',
  'Haplorrhini' = 'darkturquoise',
  'Strepsirrhini' = 'violetred4',
  'Bovidae' = 'yellow4',
  'Cervidae' = 'steelblue3',
  'Giraffidae' = 'blue1',
  'Moschidae' = 'brown'
)
# TODO: update colors

################################################################################

# image path & taxonomi positions
img <- data.frame(
  node = c(275, 222, 264, 236, 271, 240, 319, 270, 309, 228, 167, 306, 183, 203, 286, 226, 285, 196),
  file = c(
    paste0( projDir, '/arch/assets/Bat.png' ),
    paste0( projDir, '/arch/assets/Bear.png' ),
    paste0( projDir, '/arch/assets/Bison.png' ),
    paste0( projDir, '/arch/assets/Camel.png' ),
    paste0( projDir, '/arch/assets/Deer.png' ),
    paste0( projDir, '/arch/assets/Dolphin.png' ),
    paste0( projDir, '/arch/assets/Elephant.png' ),
    paste0( projDir, '/arch/assets/Giraffe.png' ),
    paste0( projDir, '/arch/assets/Gorilla.png' ),
    paste0( projDir, '/arch/assets/Horse.png' ),
    paste0( projDir, '/arch/assets/Koala.png' ),
    paste0( projDir, '/arch/assets/Lemur.png' ),
    paste0( projDir, '/arch/assets/Lion.png' ),
    paste0( projDir, '/arch/assets/Mink.png' ),
    paste0( projDir, '/arch/assets/Mouse.png' ),
    paste0( projDir, '/arch/assets/Pangolin.png' ),
    paste0( projDir, '/arch/assets/Rabbit.png' ),
    paste0( projDir, '/arch/assets/Wolf.png' )
  )
)

################################################################################
