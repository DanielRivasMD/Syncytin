# import entrez module
from Bio import Entrez

import taxonomy_functions

# set variables
taxids = [7227, 9606, 9598, 9601, 10090]

# set email
Entrez.email = "youremail@gmail.com"

# # read taxonomy ids file
# with open('FILENAME', 'r') as csv_file:
#   # load into 'taxids'
#   print()

# traverse ids
for taxid in taxids:
  handle = Entrez.efetch(db="taxonomy", id=taxid, mode="text", rettype="xml")
  records = Entrez.read(handle)
  for taxon in records:
    # taxid = taxon["TaxId"]
    name = taxon["ScientificName"]
    tids = []
    # print()
    for t in taxon["LineageEx"]:
      if t["Rank"] != "no rank":
        # print(t["Rank"] + ": " + t["ScientificName"])
        tids.insert(0, t["Rank"] + ": " + t["ScientificName"])
    tids.insert(0, name)
    print("%s" % (", ".join(tids)))
    # print("%s\t|\t%s\t|\t%s" % (taxid, name, ", ".join(tids)))

# TODO: write a taxonomy link
