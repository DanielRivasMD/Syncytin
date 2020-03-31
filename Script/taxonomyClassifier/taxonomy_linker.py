# import entrez module
import csv
import taxonomy_functions

from Bio import Entrez

# set variables
ncbi_csv = "ncbi-genome_stats.csv"

#     Fields extracted by Go assemblyStats
#     "Assembly",
#     "Organism",
#     "TaxonomicID",
#     "BioProject",
#     "Date",
#     "Level",
#     "AccessionNumber",
#     "ScaffoldCount",
#     "ScaffoldN50",
#     "ContigCount",
#     "ContigN50",
#     "TotalLength",

# set email
Entrez.email = "danielrivasmd@gmail.com"

# read file
with open("Data/csv/" + ncbi_csv, "r") as in_file:

  # use field names as dict keys
  reader = csv.DictReader(in_file)

  # collect taxonomy
  for row in reader:

    assembly = row["Assembly"]
    taxid = row["TaxonomicID"]
    accession = row["AccessionNumber"]

    try:
      # retrieve spp for file naming
      outval = taxonomy_functions.tax_extractor(taxid)

    except:
      print("An error ocurred with Assembly: " + assembly + "\tSpecies: " + taxid)

    else:
      # write as csv
      with open("Data/taxonomy/" + accession + ".csv", "w") as out_file:
        out_file.write("%s" % ("\n".join(outval)))
        out_file.write("\nAssembly" + ", " + assembly)
