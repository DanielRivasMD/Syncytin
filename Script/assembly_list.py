import os
import sys
from csv import writer
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
empty_details = ["Organism", "Infraspecific name", "Sex", "Submitter", "Date", "Assembly type", "Assembly level", "Genome representation", "RefSeq category", "GenBank assembly accession", "RefSeq assembly accession", "Excluded from RefSeq", "Release type"]

# prepare output file
output_file = data_query + "_assembly_report"
with open('Data/' + data_query + '/' + output_file + '.csv', 'w') as csv_file:
  csv_writer = writer(csv_file)

  # write headers
  csv_writer.writerow(["Title", "IDs", empty_details[0], empty_details[1], empty_details[2], empty_details[3], empty_details[4], empty_details[5], empty_details[6], empty_details[7], empty_details[8], empty_details[9], empty_details[10], empty_details[11], empty_details[12]])

  # load into bs4 from source
  soup = BeautifulSoup(browser.page_source, 'html.parser')

  # handle one page search
  try:
    pgs = int(soup.find('h3', class_="page").input['last'])
  except AttributeError as e:
    pgs = 1

    # load into bs4 from selenium
    soup = BeautifulSoup(browser.page_source, 'html.parser')
    ncbi_scrap_functions.ncbi_scraper(soup, empty_details, csv_writer)
  else:

    # page loop
    for ix in range(start_page, pgs + 1):

      # turn the page
      ncbi_scrap_functions.page_turner(browser, ix)

      # load into bs4 from selenium
      soup = BeautifulSoup(browser.page_source, 'html.parser')
      ncbi_scrap_functions.ncbi_scraper(soup, empty_details, csv_writer)
  finally:

    # last page
    print("Last page:", pgs)

# close
browser.quit()
