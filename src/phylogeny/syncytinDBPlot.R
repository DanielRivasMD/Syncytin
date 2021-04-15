
library(tidyverse)
library(dendextend)

# distance matrix rlevAr to plot
# pdf(figName, width = 10, height = 9)
jpeg(figName, width = 1200, height = 1000)
defParMar <- par('mar')
syncytinColors <- c('darkred', 'yellow', 'lightyellow4', 'darkolivegreen', 'navyblue', 'violetred2', 'steelblue', 'slateblue', 'lawngreen', 'orange4', 'darksalmon', 'darkslateblue', 'cyan', 'blueviolet')

# matrix dimensions
di <- dim(rlevAr)
nr <- di[1L]
nc <- di[2L]

# default margins
margins = c(5, 5)

# default row & col dendrogram
Rowv <- rowMeans(rlevAr, na.rm = TRUE)
Colv <- colMeans(rlevAr, na.rm = TRUE)
doRdend <- !identical(Rowv, NA)
doCdend <- !identical(Colv, NA)

# row dendrogram
hcr <- hclust(as.dist(rlevAr), method = 'average')
ddr <- as.dendrogram(hcr)
ddr <- reorder(ddr, Rowv)

# column dendrogram
hcc <- hclust(as.dist(t(rlevAr)), method = 'average')
ddc <- as.dendrogram(hcc)
ddc <- reorder(ddc, Colv)

# layout
# lmat <- rbind(c(3, NA), 1:2)
lmat <- rbind(c(NA, 3), 2:1)
lwid <- c(1, 4)
lhei <- c(1, 4)

# side bars
# lmat <- rbind(lmat[1, ] + 1, c(1, NA), lmat[2, ] + 1)
lmat <- rbind(lmat[1, ] + 1, c(NA, 1), lmat[2, ] + 1)
lhei <- c(lhei[1L], 0.1, lhei[2L])

lmat <- cbind(lmat[, 1] + 1, c(rep(NA, nrow(lmat) - 1), 1), lmat[, 2] + 1)
# lwid <- c(lwid[2L], 0.1, lwid[1L])
lwid <- c(lwid[1L], 0.1, lwid[2L])

# layout
lmat[is.na(lmat)] <- 0
layout(lmat, widths = lwid, heights = lhei, respect = TRUE)

# side bars
par(mar = c(margins[1L], 0, 0, 0.5))
image(rbind(1L:nr), col = syncytinColors[rtagAr[hcr$order]], axes = FALSE)

par(mar = c(0.5, 0, 0, margins[2L]))
image(cbind(1L:nc), col = syncytinColors[rtagAr[hcc$order]], axes = FALSE)

# heatmap
par(mar = c(margins[1L], 0, 0, margins[2L]))
image(1L:nc, 1L:nr, rlevAr[hcr$order, hcc$order], xlim = 0.5 + c(0, nc), ylim = 0.5 + c(0, nr), axes = FALSE, xlab = '', ylab = '', )

# row dendrogram
par(mar = c(margins[1L], 0, 0, 0))
ddr %>% set("branches_lwd", 3) %>% plot(., horiz = TRUE, axes = FALSE, yaxs = 'i', leaflab = 'none')

# column dendrogram
par(mar = c(0, 0, 0, margins[2L]))
ddc %>% set("branches_lwd", 3) %>% plot(., axes = FALSE, xaxs = 'i', leaflab = 'none')

annotScale <- 1 / length(syncytinColors)

par(xpd = NA)

for ( colix in 1:length(syncytinColors) ) {
  rect(
    xleft = (par('usr')[2] * 1.04),                         #: a vector (or scalar) of left x positions.
    ybottom = (par('usr')[4] * (colix - 0.9) * annotScale), #: a vector (or scalar) of bottom y positions.
    xright = (par('usr')[2] * 1.07),                        #: a vector (or scalar) of right x positions.
    ytop = (par('usr')[4] * (colix) * annotScale),          #: a vector (or scalar) of top y positions.
    border = NA,
    col = syncytinColors[colix]
  )
  text(
    x = (par('usr')[2] * 1.08),
    y = (par('usr')[4] * (colix - 0.5) * annotScale),
    label = syngDf[colix, 2],
    cex = 2,
    lwd = 5,
    adj = 0
  )
}
par(mar = defParMar)

dev.off()
