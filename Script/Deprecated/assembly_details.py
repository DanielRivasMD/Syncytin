import os
import sys
from bs4 import BeautifulSoup

# from ncbi_scrap_functions import
import ncbi_scrap_functions

# arguments
data_query = sys.argv[1]
start_page = int(sys.argv[2])

# create directory
if data_query not in os.listdir('Data/'):
  os.mkdir('Data/' + data_query)

# start chrome.driver
browser = ncbi_scrap_functions.browser_starter(data_query)

# hardcoded ncbi fields
empty_details = ["Description", "Organism name", "Infraspecific name", "Isolate", "Sex", "BioSample", "BioProject", "Submitter", "Date", "Synonyms", "Assembly type", "Release type", "Assembly level", "Genome representation", "RefSeq category", "GenBank assembly accession", "RefSeq assembly accession", "WGS Project", "Assembly method", "Expected final version", "Genome coverage", "Sequencing technology"]

# load into bs4 from source
soup = BeautifulSoup(browser.page_source, 'html.parser')

try:
  pgs = int(soup.find('h3', class_="page").input['last'])
except AttributeError as e:
  pgs = 1

  # load into bs4 from selenium
  soup = BeautifulSoup(browser.page_source, 'html.parser')
  ncbi_scrap_functions.assembly_collector(browser, empty_details, data_query)
else:

  # page loop
  for ix in range(start_page, pgs + 1):

    # turn the page
    ncbi_scrap_functions.page_turner(browser, ix)

    # load into bs4 from selenium
    soup = BeautifulSoup(browser.page_source, 'html.parser')
    try:
      ncbi_scrap_functions.assembly_collector(browser, empty_details, data_query)
    except AttributeError as e:

      print()
      print("Capture has failed due to:", e)
      print("Aborting...")
      sys.exit()

finally:

  # last page
  print("Last page:", pgs)

# close
browser.quit()
