################################################################################

# declarations
source('/Users/drivas/Factorem/Syncytin/src/Config/syncytinConfig.R')

################################################################################

# load packages
require(magrittr)
require(tidyverse)

require(ggtree)
require(ggtreeExtra)
require(ggstar)
require(treeio)
require(ggnewscale)
require(TreeTools)

################################################################################

# load tree file
trfile <- paste0( phylogenyDir, '/taxonomyBinominal.nwk' )
syncytinTree <- read.tree(trfile)

################################################################################

# patch collapsed species at phylogenetic newick
# canis
canisIx <- 192
canisTree <- bind.tree(BalancedTree(2), BalancedTree(2)) %>% bind.tree(., BalancedTree(2))
canisTree$tip.label <- c('Canis lupus dingo', 'Canis lupus dingo alpine ecotype', 'Canis lupus dingo desert ecotype', 'Canis lupus familiaris', 'Canis lupus familiaris Basenji', 'Canis lupus familiaris German Shepherd')
syncytinTree <- bind.tree(syncytinTree, canisTree, canisIx) %>% DropTip(., 'Canis_lupus')

################################################################################

# patch assembly ids
# retag without underscores
syncytinTree$tip.label %<>% str_replace(., '_', ' ')

# patch misslabeled species
syncytinTree$tip.label[syncytinTree$tip.label == 'Aonyx cinerea'] <- 'Amblonyx cinereus'
syncytinTree$tip.label[syncytinTree$tip.label == 'Manis tricuspis'] <- 'Phataginus tricuspis'
syncytinTree$tip.label[syncytinTree$tip.label == 'Monachus schauinslandi'] <- 'Neomonachus schauinslandi'
syncytinTree$tip.label[syncytinTree$tip.label == 'Sus scrofa'] <- 'Babyrousa celebensis'
syncytinTree$tip.label[syncytinTree$tip.label == 'Lasiurus cinereus'] <- 'Aeorestes cinereus'
syncytinTree$tip.label[syncytinTree$tip.label == 'Callithrix pygmaea'] <- 'Cebuella pygmaea'

# patch subspecies
syncytinTree$tip.label[syncytinTree$tip.label == 'Equus burchellii'] <- 'Equus burchellii quagga'
syncytinTree$tip.label[syncytinTree$tip.label == 'Mustela putorius'] <- 'Mustela putorius furo'
syncytinTree$tip.label[syncytinTree$tip.label == 'Perognathus longimembris'] <- 'Perognathus longimembris pacificus'
syncytinTree$tip.label[syncytinTree$tip.label == 'Stenella longirostris'] <- 'Stenella longirostris orientalis'
syncytinTree$tip.label[syncytinTree$tip.label == 'Tragelaphus eurycerus'] <- 'Tragelaphus eurycerus isaaci'

# TODO: repatch names to fit with newick file

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

# # open io
# tiff( paste0( projDir, '/arch/plots/plotTreeFan.tiff' ), width = 4, height = 4, units = 'in', res = 300 )

# TODO: calibrate final colors
# TODO: patch taxonomic groups

# create graph
φ <- syncytinTree %>%

  # plot tree
  ggtree(
    layout = 'fan',
    alpha = 0.5
  ) +

  # colors
  scale_color_manual(
    values = taxonColors
  ) +

  # add tip labels
  geom_tiplab(
    mapping = aes(
      label = label,
      color = group
    ),
    align = TRUE,
    linetype = 'dotted',
    linesize = .1,
    offset = 1,
    size = 3.5,
  ) +

  # colors
  scale_fill_manual(
    values = taxonColors
  ) +

  # add bars
  geom_fruit(
    data = diamondHits,
    geom = geom_bar,
    mapping = aes(
      y = treeLink,
      x = hits,
      fill = treeGroup,
    ),
    stat = 'identity',
    orientation = 'y',
    offset = 1.0,
  ) +

  # add numbers
  geom_fruit(
    data = diamondHits,
    geom = geom_text,
    mapping = aes(
      y = treeLink,
      label = hits
    )
  )






# φ <- ggtree(
#     syncytinTree,
#     # aes(
#     #   color = group
#     # ),
#     layout = 'fan',
#   ) +

#   scale_color_discrete() +
  # scale_color_brewer(
  #   'location',
  #   palette = 'Spectral'
  # ) +

  # theme(legend.position = 'none') +
  # scale_color_manual(values = seq_along(gr))

  # scale_color_manual(values = sample(seq_along(colors())))

  # , length(tb)), labels = names(tb))

  # # add tip labels
  # geom_tiplab(
  #   align = TRUE,
  #   linetype = 'dotted',
  #   linesize = .1,
  #   offset = 1,
  #   aes(
  #     label = label,
  #     color = group
  #   ),
  #   size = 3.5,
  # ) +

  # geom_tiplab(
  #   data = diamondHits,
  #   aes(
  #     label = hits,
  #   )
  # ) +

  # geom_text(
  #   data = diamondHits,
  #   aes(
  #     label = hits
  #   )
  # ) +

# add images
φ %<+% img +
  geom_nodelab(
    aes(
      image = file,
    ),
    size = .05,
    geom = 'image',
    alpha = 0.1
  )


# plot
φ %>% print

# # close plotting device
# dev.off()

ggsave( paste0( projDir, '/arch/plots/plotTreeFan.tiff' ) )

################################################################################

# # open io
# # tiff( paste0( projDir, '/arch/plots/plotTree.tiff' ), width = 4, height = 4, units = 'in', res = 300 )
# # pdf( paste0( projDir, '/arch/plots/plotTree.pdf' ) )
# png( paste0( projDir, '/arch/plots/plotTree.png' ), res = 300 )

# # create tree plot
# t0 <- ggtree(
#     syncytinTree,
#     aes(
#       color = group
#     ),
#     layout = 'rectangular'
#   )

# # add tip labels
# t1 <- t0 +
#   geom_tiplab(
#     aes(
#       label = label
#     ),
#     size = 1.5,
#   )

# # add bars
# t2 <- t1 +
#   geom_fruit(
#     data = diamondHits,
#     geom = geom_bar,
#     mapping = aes(
#       y = Species,
#       x = hits,
#       fill = Suborder,
#     ),
#     stat = 'identity',
#     orientation = 'y',
#     offset = 0.8,
#   )

# # plot
# t2 %>% print

# # close plotting device
# dev.off()

# ################################################################################


# nwk <- system.file("extdata", "sample.nwk", package="treeio")
# tree <- read.tree(nwk)
# tree2 <- groupClade(tree, c(17, 21))
# p <- ggtree(tree2, aes(color=group)) +
#   scale_color_manual(values=c("black", "firebrick", "steelblue"))


# library(ggimage)
# library(ggtree)
# library(ape)

# tree <- read.tree("tree_boots.nwk")
# info <- read_csv("taxa_info.csv")

# mass <- info$mass_in_kg
# names(mass) <- info$Newick_label
# fit <- fastAnc(tree,mass,vars=TRUE,CI=TRUE)

# td <- data.frame(node = nodeid(tree, names(mass)),
#                  trait = mass)
# nd <- data.frame(node = as.numeric(names(fit$ace)),
#                  trait = fit$ace)
# d <- rbind(td, nd)

# library(treeio)
# tree2 <- full_join(tree, d, by = 'node')

# pg <- ggtree(tree2, aes(color=trait), continuous = TRUE, size=3) +
#   scale_color_gradientn(colours=c("red", 'orange', 'green', 'cyan', 'blue'),
#                         name="mass (kg)") +
#   geom_tiplab(hjust = -.2) + xlim(0, 4)

#   trophic_habit <- setNames(info$trophic_habit, info$Newick_label)

#   cols <- RColorBrewer::brewer.pal(length(unique(trophic_habit)), "Set1")
#   names(cols) <- sort(unique(trophic_habit))
#   fitER <- ape::ace(trophic_habit,tree,model="ER",type="discrete")
#   ancstats <- as.data.frame(fitER$lik.anc)
#   ancstats$node <- 1:Nnode(tree)+Ntip(tree)

#   pies <- nodepie(ancstats, cols=1:3)
#   pies <- lapply(pies, function(g) g + scale_fill_manual(values = cols))

#   pg <- pg %<+% info +
#     geom_tippoint(aes(fill = trophic_habit), shape=21, size=10, color='white') +
#     scale_fill_manual(values = cols) +
#     geom_inset(pies, width = .2, height=.2)




#     ## function does fast estimation of ML ancestral states using ace
#     ## written by Liam J. Revell 2012, 2013, 2015, 2019, 2020

#     fastAnc<-function(tree,x,vars=FALSE,CI=FALSE,...){
#      if(!inherits(tree,"phylo")) stop("tree should be object of class \"phylo\".")
#      if(length(class(tree)>1)) class(tree)<-"phylo"
#      if(hasArg(anc.states)) anc.states<-list(...)$anc.states
#      else anc.states<-NULL
#      if(!is.null(anc.states)){
#        nodes<-as.numeric(names(anc.states))
#        tt<-tree
#        for(i in 1:length(nodes)){
#          M<-matchNodes(tt,tree,method="distances",quiet=TRUE)
#          ii<-M[which(M[,2]==nodes[i]),1]
#          tt<-bind.tip(tt,nodes[i],edge.length=0,where=ii)
#        }
#        x<-c(x,anc.states)
#      } else tt<-tree
#      if(!is.binary(tt)) btree<-multi2di(tt)
#      else btree<-tt
#      M<-btree$Nnode
#      N<-length(btree$tip.label)
#      anc<-v<-vector()
#      for(i in 1:M+N){
#        a<-collapse.singles(multi2di(ape::root.phylo(btree,node=i)))
#          anc[i-N]<-ace(x,a,method="pic")$ace[1]
#          names(anc)[i-N]<-i
#        if(vars||CI){
#          picx<-pic(x,a,rescaled.tree=TRUE)
#          b<-picx$rescaled.tree
#          d<-which(b$edge[,1]==(length(b$tip.label)+1))
#          v[i-N]<-(1/b$edge.length[d[1]]+1/b$edge.length[d[2]])^(-1)*mean(picx$contr^2)
#          names(v)[i-N]<-names(anc)[i-N]
#        }
#      }
#      if(!is.binary(tree)||!is.null(anc.states)){
#        ancNames<-matchNodes(tree,btree,method="distances",quiet=TRUE)
#        anc<-anc[as.character(ancNames[,2])]
#        names(anc)<-ancNames[,1]
#        if(vars||CI){
#          v<-v[as.character(ancNames[,2])]
#          names(v)<-ancNames[,1]
#        }
#      }
#      obj<-list(ace=anc)
#      if(vars) obj$var<-v
#      if(CI){
#        obj$CI95<-cbind(anc-1.96*sqrt(v),anc+1.96*sqrt(v))
#        rownames(obj$CI95)<-names(anc)
#      }
#      if(length(obj)==1) obj<-obj$ace
#      class(obj)<-"fastAnc"
#      obj
#     }

#     ## print method for "fastAnc"
#     ## written by Liam J. Revell 2015
#     print.fastAnc<-function(x,digits=6,printlen=NULL,...){
#      cat("Ancestral character estimates using fastAnc:\n")
#      if(!is.list(x)){
#        if(is.null(printlen)||printlen>=length(x)) print(round(unclass(x),digits))
#        else printDotDot(unclass(x),digits,printlen)
#      } else {
#        Nnode<-length(x$ace)
#        if(is.null(printlen)||printlen>=Nnode) print(round(x$ace,digits))
#        else printDotDot(x$ace,digits,printlen)
#        if(!is.null(x$var)){
#          cat("\nVariances on ancestral states:\n")
#          if(is.null(printlen)||printlen>=Nnode) print(round(x$var,digits))
#          else printDotDot(x$var,digits,printlen)
#        }
#        if(!is.null(x$CI95)){
#          cat("\nLower & upper 95% CIs:\n")
#          colnames(x$CI95)<-c("lower","upper")
#          if(is.null(printlen)||printlen>=Nnode) print(round(x$CI95,digits))
#          else printDotDot(x$CI95,digits,printlen)
#        }
#      }
#      cat("\n")
#     }

#     ## internal function
#     ## written by Liam J. Revell 2015
#     printDotDot<-function(x,digits,printlen){
#      if(is.vector(x)){
#        x<-as.data.frame(t(as.matrix(unclass(round(x[1:printlen],digits)))))
#        x<-cbind(x,"....")
#        rownames(x)<-""
#        colnames(x)[printlen+1]<-""
#        print(x)
#      } else if(is.matrix(x)){
#        x<-as.data.frame(rbind(round(x[1:printlen,],digits),c("....","....")))
#        print(x)
#      }
#     }


# ################################################################################

# # # add multiple sequence alignment
# # t1 <- t0 +
# #   geom_fruit(
# #     data = tidy_msa(msa),
# #     geom = geom_msa,
# #     offset = 1,
# #   )
# #
# #     # panel = 'msa',
# #     # seq_name = TRUE
# #     # ) + xlim_tree(1.5)

# ################################################################################

# # # load multiple sequence alignment
# # seqfile <- paste0( projDir, '/data/phylogeny/dummy.fasta' )
# # msa <- readDNAStringSet(seqfile)

# ################################################################################

# # protein_sequences <- system.file("extdata", "sample.fasta", package = "ggmsa")
# # x <- readAAStringSet(protein_sequences)
# # d <- as.dist(stringDist(x, method = "hamming")/width(x)[1])
# # tree <- bionj(d)
# # p <- ggtree(tree) + geom_tiplab(size=2)
# #
# # data = tidy_msa(x, 164, 213)
# # p <- p +
# #      geom_facet(
# #          geom = geom_msa,
# #          data = data,
# #          panel = 'msa',
# #          #font = NULL,
# #          color = "Chemistry_AA") +
# #      xlim_tree(1.5)
# #
# # p <- facet_widths(p, width=c(1, 2))
# # p

# ################################################################################

# # jpeg('data/diamondAlingment.jpg', width = 3000, height = 1000)
# #
# # noColors <- 16
# # moreColors <- colorRampPalette(brewer.pal(8, "Set2"))(noColors)
# #
# # # plot
# # ggplot(data = toPlotDf, aes(x = Species, y = hits, fill = Suborder)) +
# #   geom_bar(stat = "identity", position = position_dodge()) +
# #   scale_fill_manual(values = moreColors) +
# #   theme_classic() +
# #   theme(axis.text.x = element_text(face = "bold", size = 14, angle = 90), legend.title = element_text(face = "bold", size = 14), legend.text = element_text(face = "bold", size = 14))
# #
# # dev.off()

# ################################################################################

# # carnivora
# trfile <- paste0( phylogenyDir, '/carnivoraBinominal.nwk' )
# syncytinTree <- read.tree(trfile)

# # load alignment hits
# dmfile <- paste0( statsDir, '/diamondHits.csv' )
# diamondHits <- read_csv(dmfile)

# ################################################################################

# # replace no hits
# diamondHits %<>% mutate(hits = na_if(hits, 0))

# ################################################################################

# # empty list
# gr <- list()

# # collect taxomonic names
# tb <- diamondHits %$% table(Suborder)

# # collect names
# getNames <- function(δ, τ) {
#   return(δ$Species[which(δ$Suborder == τ)])
# }

# # iteratate over groups
# for ( ι in seq_along(tb) ) {
#   gr[[ι]] <- getNames(diamondHits, names(tb)[ι])
# }

# # group by taxonomic unit
# syncytinTree <- groupOTU(syncytinTree, gr)

# ################################################################################

# # create tree plot
# φ <- ggtree(
#     syncytinTree,
#     aes(
#       color = group
#     ),
#     layout = 'rectangular'
#   )

# # add tip labels
# φ <- φ +
#   geom_tiplab(
#     aes(
#       label = label %>% str_replace(., '_', ' ')
#     ),
#     size = 5,
#   )

# # add bars
# φ <- φ +
#   geom_fruit(
#     data = diamondHits,
#     geom = geom_bar,
#     mapping = aes(
#       y = Species,
#       x = hits,
#       fill = Family,
#     ),
#     stat = 'identity',
#     orientation = 'y',
#     offset = 0.8,
#   )

# # plot
# φ %>% print

# ################################################################################
