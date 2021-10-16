import os
import re
import time
from csv import writer
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.common.keys import Keys

# ignore warnings
import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning)

# declarations
projDir = '/Users/drivas/Factorem/Syncytin'
outDir = projDir + '/' + 'data/wasabi'
wasabi = 'https://dnazoo.s3.wasabisys.com/'
dnaAddress = wasabi + 'index.html'

# regex
ixRx = re.compile('.*index.*')

# navigate
browser = webdriver.Chrome()
browser.get(dnaAddress)

# wait for page to load
time.sleep(3)

# collect html data
dnaHome = BeautifulSoup(browser.page_source, 'html.parser')
dnaItems = dnaHome.findAll('a')

# iterate on DNAzoo species
for _, υ in enumerate(dnaItems):

  # log
  print(υ.text)

  # wait to go next link
  time.sleep(10)

  # match on indexed spp
  if re.match(ixRx, υ.get_attribute_list('href')[0]):

    # regex
    collectRx = re.compile(wasabi + υ.text + '[a-zA-Z0-9]+')

    # nagivate
    link = browser.find_element_by_partial_link_text(υ.text)
    link.click()

    # wait for page to load
    time.sleep(3)

    # collect html data
    spp = BeautifulSoup(browser.page_source, 'html.parser')
    sppItems = spp.findAll('a')

    # prepare output file
    outFile = υ.text.replace('/', '')
    with open(outDir + '/' + outFile + '.csv', 'w') as csvFile:
      csvWriter = writer(csvFile)

      # write headers
      csvWriter.writerow(['File', 'Link'])

      for _, ι in enumerate(sppItems):

        # match on linked files
        if re.match(collectRx, ι.attrs['href']):

          # write rows
          csvWriter.writerow([ι.text, ι.attrs['href']])

    # return to home page
    browser.back()
