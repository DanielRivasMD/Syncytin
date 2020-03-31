################################################################################

# load packages
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
tax_stats = "taxonomy.csv"

################################################################################

# change directory
cd(proj_dir)

# read file
ftax = CSV.read("$(data_dir)$(csv_dir)$(tax_stats)", copycols = true)

# expected cols with missing values
colsMiss = names(ftax)

# replace with empty
for it in colsMiss

	# patch col type
	replace!(ftax[!, Symbol(it)], missing => "")
	disallowmissing!(ftax, Symbol(it))
end

################################################################################

# FreqTables
freqtable(ftax.species)

# subset chordata
chordata = ftax[ftax.phylum .== "Chordata", :]
freqtable(chordata.species)

# subset mammalia
mammalia = ftax[ftax.class .== "Mammalia", :]
freqtable(mammalia.species)

################################################################################

# use to estimate the frecuency of occurences in vector array
# freqtable()

################################################################################
