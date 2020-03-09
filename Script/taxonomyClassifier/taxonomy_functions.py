# import entrez module
from Bio import Entrez


def tax_extractor(taxid):

  # use Entrez to extract id records
  handle = Entrez.efetch(db="taxonomy", id=taxid, mode="text", rettype="xml")
  records = Entrez.read(handle)

  for taxon in records:
    name = taxon["ScientificName"]
    tids = []

    # iterate over taxons
    for t in taxon["LineageEx"]:
      tids.insert(0, t["Rank"] + ", " + t["ScientificName"])

    # add binomial nomenclature manually
    tids.insert(0, "species, " + name)

    # add title for csv
    tids.insert(len(tids), "Rank, Scientific Name")

    # prepare list for output
    tids = reversed(tids)

    # return taxonomic list
    return tids
