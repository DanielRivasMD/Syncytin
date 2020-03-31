# import entrez module
import csv
import taxonomy_functions

from Bio import Entrez

# set variables
bio_csv = "biosample_result.csv"

#     Fields extracted by Julia
#     "scientific_name"
#     "taxon_id"
#     "biosample"
#     "sample_lab"
#     "sra"

# set email
Entrez.email = "danielrivasmd@gmail.com"

# read file
with open("Data/csv/" + bio_csv, "r") as in_file:

  # use field names as dict keys
  reader = csv.DictReader(in_file)

  # collect taxonomy
  for row in reader:

    organism = row["scientific_name"]
    taxid = row["taxon_id"]
    accession = row["sra"]

    try:
      # retrieve spp for file naming
      outval = taxonomy_functions.tax_extractor(taxid)

    except:
      print("An error ocurred with Assembly: " + organism + "\tSpecies: " + taxid)

    else:
      # write as csv
      with open("Data/DNAzoo/taxonomy/" + accession + ".csv", "w") as out_file:
        out_file.write("%s" % ("\n".join(outval)))
