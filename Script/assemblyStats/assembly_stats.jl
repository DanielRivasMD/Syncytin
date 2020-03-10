################################################################################

# load packages
using Dates
using CSV
using DataFrames
using Plots
using StatsPlots
using RCall
using FreqTables

################################################################################

# set variables
proj_dir = "/Users/drivas/Factorem/Syncytin"
script_dir = "Script/"
data_dir = "Data/"
csv_dir = "csv/"
primate_stats = "ncbi-genome_stats.csv"

thres = 1000000

################################################################################

# change directory
cd(proj_dir)

# read file
fstats = CSV.read("$(data_dir)$(csv_dir)$(primate_stats)", copycols = true)

# expected cols with missing values
colsMiss = names(fstats)

# replace with zeros
for it in colsMiss

	# patch col type
	if it == :Date
		replace!(fstats[!, Symbol(it)], missing => Dates.Date(2000, 01, 01))
	else
		replace!(fstats[!, Symbol(it)], missing => 0)
	end

	disallowmissing!(fstats, Symbol(it))
end

################################################################################

# plot by date


################################################################################

# group by level
glevel = groupby(fstats, :Level)

dcLevel = Dict()
for i in 1:length(glevel)
	dcLevel[glevel[i][1, :Level]] = glevel[i]
end

################################################################################

# group records by organism -> dictionary
gstats = groupby(fstats, :Organism)

dcFull = Dict()
for i in 1:length(gstats)
	dcFull[gstats[i][1, :Organism]] = gstats[i]
end

# plot
@df gstats[1] scatter(
	title = gstats[1].Organism[1],
	:ScaffoldN50, :ScaffoldCount,
	xlab = "ScaffoldN50", ylab = "ScaffoldCount"
)

################################################################################

# set ScaffoldN50 threshold
substatSN50 = fstats[fstats.ScaffoldN50 .> thres, :]
gstatsSN50 = groupby(substatSN50, :Organism)

dcSN50 = Dict()
for i in 1:length(gstatsSN50)
	dcSN50[gstatsSN50[i][1, :Organism]] = gstatsSN50[i]
end

# plot
@df substatSN50 scatter(
	:ScaffoldN50, :ScaffoldCount,
	xlab = "ScaffoldN50", ylab = "ScaffoldCount"
)

# histogram
histogram(
	substatSN50.TotalLength,
	nbins = 100
)

histogram(
	substatSN50.ScaffoldN50,
	nbins = 25
)

################################################################################

# set ContigN50 threshold
substatCN50 = fstats[fstats.ContigN50 .> thres, :]
gstatsCN50 = groupby(substatCN50, :Organism)

dcCN50 = Dict()
for i in 1:length(gstatsCN50)
	dcCN50[gstatsCN50[i][1, :Organism]] = gstatsCN50[i]
end

# plot
@df substatCN50 scatter(
	:ContigN50, :ScaffoldCount,
	xlab = "ContigN50", ylab = "ScaffoldCount"
)

# histogram
histogram(
	substatCN50.TotalLength,
	nbins = 100
)

histogram(
	substatCN50.ContigN50,
	nbins = 25
)

################################################################################

# # RCall
#
# # aggregate max SN50 values R
# Tsnaggr = fstats[:, [:Organism, :ScaffoldN50]]
# @rput Tsnaggr
# R"faggr <- aggregate(ScaffoldN50 ~ Organism , data = Tsnaggr, FUN = max)"
# @rget snaggr
#
# # aggregate max CN50 values R
# Tcnaggr = fstats[:, [:Organism, :ContigN50]]
# @rput Tcnaggr
# R"faggr <- aggregate(ContigN50 ~ Organism , data = Tcnaggr, FUN = max)"
# @rget cnaggr
#
#
# Taggr = fstats[:, [:Organism, :Level]]
# @rput Taggr
# table(Taggr[, 1:2])

################################################################################
