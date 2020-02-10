import os
import re
import time
from csv import writer
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.common.keys import Keys


# turn NCBI search page
def page_turner(browser, ix):

  # get page value
  soup_source = BeautifulSoup(browser.page_source, 'html.parser')
  item_page = soup_source.find('h3', class_="page")
  page_value = item_page.input.get('value')

  # iterator control
  pagination = browser.find_element_by_class_name('pagination')
  input_value = "input[value='" + page_value + "']"

  # verbose
  print("Current page:", page_value)
  print("Turn to page:", ix)
  print("=========================")

  turn_page = pagination.find_element_by_css_selector(input_value)
  turn_page.clear()
  turn_page.send_keys(ix)
  turn_page.send_keys(Keys.RETURN)


# starts in chrome.driver to NCBI assembly search
def browser_starter(data_query):

  # change directory
  os.chdir("/Users/Daniel/Factorem/eSIV/")

  # ncbi address
  ncbi_adress = "https://www.ncbi.nlm.nih.gov/assembly/"

  # launch browser
  browser = webdriver.Chrome()

  # directing to ncbi
  browser.get(ncbi_adress + '?term=' + data_query)
  browser.maximize_window()

  # get query out
  return browser


# finds elements in a NCBI search & writes to file
def ncbi_scraper(soup, empty_details, csv_writer):

  # items in page loop
  for item in soup.find_all('div', class_="rslt"):

    # title
    title = item.find('p', class_="title").text

    # details
    tofill_details = empty_details.copy()

    for i, dt in enumerate(item.find_all('dl', class_="details")):
      for j, edt in enumerate(tofill_details):
        if re.match(edt, dt.text):
          tofill_details[j] = dt.text

    # ids
    ids = item.find('dl', class_="rprtid").text

    # write
    csv_writer.writerow([title, ids, tofill_details[0], tofill_details[1], tofill_details[2], tofill_details[3], tofill_details[4], tofill_details[5], tofill_details[6], tofill_details[7], tofill_details[8], tofill_details[9], tofill_details[10], tofill_details[11], tofill_details[12]])


# collects data from NCBI serach by navigating to link & writes to files
def assembly_collector(browser, empty_details, data_query):

  # get links
  link_list = browser.find_elements_by_class_name('rprt')

  # links loop
  for it in range(0, len(link_list)):

    # get link info
    text_click = link_list[it].text.split('\n')[1]
    to_clik = link_list[it].find_element_by_partial_link_text(text_click)
    to_clik.click()

    # extrac data from assembly
    soup_source = BeautifulSoup(browser.page_source, 'html.parser')

    # prepare output file
    output_file = text_click.replace(' ', '').replace('/', '')
    with open('Data/' + data_query + '/' + output_file + '.csv', 'w') as csv_file:
      csv_writer = writer(csv_file)

      # write headers
      csv_writer.writerow(['Feature', 'Value'])

      # summary
      tofill_details = empty_details.copy()
      time.sleep(1)
      item_summary = soup_source.find('div', id="summary")

      for _, dt in enumerate(item_summary.find_all('dt')):
        for j, edt in enumerate(tofill_details):
          edt = edt.replace("(", "").replace(")", "")
          if re.match(edt, dt.text):
            tofill_details[j] = dt.find_next().text

      # write summary
      for ix in range(0, len(empty_details)):
        if empty_details[ix] == tofill_details[ix]:
          csv_writer.writerow([empty_details[ix], ''])
        else:
          csv_writer.writerow([empty_details[ix], tofill_details[ix]])

      # global-stats
      item_table = soup_source.find('table', class_="margin_t0 jig-ncbigrid ui-ncbigrid")
      table_list = item_table.findAll('td')

      # write table
      for ix in range(0, len(table_list)):

        if (ix + 1) % 2 == 1:
          feature = table_list[ix].text

        elif (ix + 1) % 2 == 0:
          value = table_list[ix].text
          value = value.replace(',', '')
          csv_writer.writerow([feature, value])

    # back to page
    browser.back()

    # refresh links
    link_list = browser.find_elements_by_class_name('rprt')
