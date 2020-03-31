################################################################################

# load packages
using LightXML
using DataFrames
using FreqTables
using CSV

# using Plots
# using StatsPlots
# using RCall

################################################################################

# set variables
proj_dir = "/Users/drivas/Factorem/Syncytin"
script_dir = "Script/"
data_dir = "Data/"
csv_dir = "csv/"
sraex_csv = "SraExperimentPackage.csv"
biosample_csv = "biosample_result.csv"
dnazoo_dir = "DNAzoo/"
example = "ex1.xml"
dnazoo_xml = "SraExperimentPackage.xml"
biosample_xml = "biosample_result.xml"

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
  push!(
    tax_df,
    [
      content(find_element(samnam, "SCIENTIFIC_NAME")),
      content(find_element(samnam, "TAXON_ID"))
    ]
  )
end

freqtable(tax_df, :scientific_name) |> sort

CSV.write("$(data_dir)$(csv_dir)$(sraex_csv)",  tax_df, writeheader = true)

################################################################################

# change directory
cd(proj_dir)

# read file
xdoc = parse_file("$(data_dir)$(dnazoo_dir)$(biosample_xml)")

# get the root element
xroot = root(xdoc)  # an instance of XMLElement

ces = collect(child_elements(xroot))  # get a list of all child elements

# create an empty dataframe
tax_df = DataFrame(scientific_name = String[], taxon_id = String[])

for i in 1:length(ces)
  tmp_ces = find_element(ces[i], "Description")
  tmp_org = find_element(tmp_ces, "Organism")
  org_dict = attributes_dict(tmp_org)
  push!(
    tax_df,
    [
      org_dict["taxonomy_name"],
      org_dict["taxonomy_id"],
    ]
  )
end

freqtable(tax_df, :scientific_name) |> sort

CSV.write("$(data_dir)$(csv_dir)$(biosample_csv)",  tax_df, writeheader = true)

################################################################################
