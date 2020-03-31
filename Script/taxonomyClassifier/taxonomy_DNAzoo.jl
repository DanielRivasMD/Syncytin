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
dnazoo_xml = "SraExperimentPackage.xml"

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

# change directory
cd(proj_dir)

# read file
xdoc = parse_file("$(data_dir)$(dnazoo_dir)$(dnazoo_xml)")

# get the root element
xroot = root(xdoc)  # an instance of XMLElement

# create an empty dataframe
tax_df = DataFrame(scientific_name = String[], taxon_id = String[])

counter = 0
for i in child_elements(xroot)
  global counter
  counter += 1
  sam = find_element(i, "SAMPLE")
  samnam = find_element(sam, "SAMPLE_NAME")
  println()
  @show counter
  content(find_element(samnam, "TAXON_ID")) |> println
  content(find_element(samnam, "SCIENTIFIC_NAME")) |> println
  push!(
    tax_df,
    [
      content(find_element(samnam, "SCIENTIFIC_NAME")),
      content(find_element(samnam, "TAXON_ID"))
    ]
  )
end

freqtable(tax_df, :scientific_name) |> sort

################################################################################
