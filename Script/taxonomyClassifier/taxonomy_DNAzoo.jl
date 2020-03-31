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
tax_df = DataFrame(
  scientific_name = String[],
  taxon_id = String[],
  biosample = String[],
  sample_lab = String[],
  sra = String[],
)

counter = 0
for i in child_elements(xroot)
  global counter
  counter += 1
  sam = find_element(i, "SAMPLE")
  sam_dict = attributes_dict(sam)
  samident = find_element(sam, "IDENTIFIERS")
  find_element(samident, "EXTERNAL_ID") |> content
  samnam = find_element(sam, "SAMPLE_NAME")
  push!(
    tax_df,
    [
      find_element(samnam, "SCIENTIFIC_NAME") |> content,
      find_element(samnam, "TAXON_ID") |> content,
      find_element(samident, "EXTERNAL_ID") |> content,
      sam_dict["alias"],
      sam_dict["accession"],
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
tax_df = DataFrame(
  scientific_name = String[],
  taxon_id = String[],
  biosample = String[],
  sample_lab = String[],
  sra = String[],
)

for i in 1:length(ces)
  tmp_elm = find_element(ces[i], "Ids")
  tmp_arr = get_elements_by_tagname(tmp_elm, "Id")
  tmp_ces = find_element(ces[i], "Description")
  tmp_org = find_element(tmp_ces, "Organism")
  org_dict = attributes_dict(tmp_org)

  if length(tmp_arr) == 3
    tmp_arg = tmp_arr[3] |> content
  else
    tmp_arg = ""
    println("Missing SRA Id: $(i)")
  end
  push!(
    tax_df,
    [
      org_dict["taxonomy_name"],
      org_dict["taxonomy_id"],
      tmp_arr[1] |> content,
      tmp_arr[2] |> content,
      tmp_arg,
    ]
  )
end

freqtable(tax_df, :scientific_name) |> sort

CSV.write("$(data_dir)$(csv_dir)$(biosample_csv)",  tax_df, writeheader = true)

################################################################################
