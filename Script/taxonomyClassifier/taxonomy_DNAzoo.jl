################################################################################

# load packages
using LightXML
using DataFrames
using FreqTables

# using CSV
# using Plots
# using StatsPlots
# using RCall

################################################################################

# set variables
proj_dir = "/Users/drivas/Factorem/Syncytin"
script_dir = "Script/"
data_dir = "Data/"
dnazoo_dir = "DNAzoo/"
example = "ex1.xml"

################################################################################

# change directory
cd(proj_dir)

# read file
xdoc = parse_file("$(data_dir)$(dnazoo_dir)$(example)")

# get the root element
xroot = root(xdoc)  # an instance of XMLElement

# traverse all its child nodes and print element names
for c in child_nodes(xroot)  # c is an instance of XMLNode
  println(nodetype(c))
  if is_elementnode(c)
    e = XMLElement(c)  # this makes an XMLElement instance
    println(name(e))
  end
end

ces = collect(child_elements(xroot))  # get a list of all child elements

################################################################################
