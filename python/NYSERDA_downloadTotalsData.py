'''
This script finds and downloads all files in the NYSERDA DG Integrated Data
System that have data for Total Facility Demand (kW) and Total Facility Energy
(kWh).
Requires Firefox.
Requires that Downloads folder be emptied of all .csv files starting with
"Dat".
Requires that dataDir (defined below under imports) is completely empty

MAKE SURE THAT ON THE FIRST BUILDING DOWNLOAD, FIREFOX IS SET TO AUTOMATICALLY
DOWNLOAD TO DOWNLOADS FOLDER. IF NOT SET TO AUTOMATICALLY DOWNLOAD, BE SURE TO
CLICK "Save File" AND CHECK THE "Do this automatically for files like this
from now on." BOX.
'''

import logging
import os
import time
import shutil
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.keys import Keys
import pdb #temporary

NYSERDAhome = 'http://chp.nyserda.ny.gov/'
dnldPath = os.path.join('C:'+str(os.sep), 'Users', 'Admin', 'Downloads')
dataDir = os.path.join(dnldPath, 'NYSERDA_datafiles')
wait = 3 # seconds
longWait = 30 # seconds
delay = 0.5 # seconds
bldgStart = 468

def main():
    # set up directories
    os.chdir(dnldPath) # go to download directory
    if not os.path.exists(dataDir): # make sure data directory exists
        os.mkdir(dataDir)

    # set up webdriver
    driver = webdriver.Firefox()
    driver.get(NYSERDAhome)
    go = True
    try:
        elem = WebDriverWait(driver,wait).until( \
            EC.presence_of_element_located((By.NAME, 'Facilities')) \
            )
        elem.click()
    except Exception, e:
        logging.error('Failed to find element - ' + str(e))
        go = False
    # should now be seeing list of Facilities

    # begin probing database
    nIn = 0 # number of times must go back to get to Facilities page
    b = bldgStart # 1st row is category links
    logging.info('Begin data probing at b = ' + str(b))
    while go:
        cont = True
        try:
            # click next building
            elem = WebDriverWait(driver,wait).until( \
                EC.presence_of_element_located( \
                    (By.XPATH, '//tbody/tr[' + \
                     str(b) + ']/td[1]/a[1]')) \
                )
            elem.click()
            logging.info('Next building clicked.')
            nIn += 1
            # click Monitored Data
            try:
                elem = WebDriverWait(driver,wait).until( \
                    EC.presence_of_element_located( \
                        (By.LINK_TEXT, 'Monitored Data - Plots and Graphs'))
                    )
                elem.click()
                logging.info('Monitored Data clicked.')
                nIn += 1
                time.sleep(delay)
            except:
                logging.info('Monitored Data not found.')
                cont = False
            if cont:
                # click Additional Options
                elem = WebDriverWait(driver,wait).until( \
                    EC.presence_of_element_located( \
                        (By.LINK_TEXT, 'Additional Options'))
                    )
                elem.click()
                logging.info('Additional Options clicked.')
                nIn += 1
                time.sleep(delay)
                try:
                    # if Total Facility Energy and Total Facility Demand
                    # in list, select them, unselect first option,
                    # and click Continue
                    elem = WebDriverWait(driver,wait).until( \
                        EC.presence_of_element_located( \
                            (By.XPATH, '//select[@name="Data"]/option[1]'))
                        )
                    elem.click()
                    elem = WebDriverWait(driver,wait).until( \
                        EC.presence_of_element_located( \
                            (By.XPATH, '//option[@value="WB"]'))
                        )
                    elem.click()
                    elem = WebDriverWait(driver,wait).until( \
                        EC.presence_of_element_located( \
                            (By.XPATH, '//option[@value="WB_kW"]'))
                        )
                    elem.click()
                    logging.info('Total Facility Energy and Demand selected.')
                    elem = WebDriverWait(driver,wait).until( \
                        EC.presence_of_element_located( \
                            (By.XPATH, '//input[@value="Continue"]'))
                        )
                    elem.click()
                    logging.info('Continue clicked.')
                    nIn += 1
                    time.sleep(delay)
                except:
                    logging.info('Energy and Demand data not found.')
                    cont = False
            if cont:
                # continue again
                elem = WebDriverWait(driver,wait).until( \
                    EC.presence_of_element_located( \
                        (By.XPATH, '//input[@value="Continue"]'))
                    )
                elem.click()
                logging.info('Continue clicked again.')
                nIn += 1
                # create report
                elem = WebDriverWait(driver,wait).until( \
                    EC.presence_of_element_located( \
                        (By.XPATH, '//input[@value="Create Report"]'))
                    )
                elem.click()
                logging.info('Create Report clicked.')
                # new tab will be opened; wait for load, then switch tabs
                while len(driver.window_handles) < 2:
                    time.sleep(delay)
                newTab = driver.window_handles[1]
                driver.switch_to_window(newTab)
                logging.info('Switched to tab 2.')
                # get name of building
                elem = WebDriverWait(driver,longWait).until( \
                    EC.presence_of_element_located( \
                        (By.XPATH, '//td/table[@cellpadding="3"]/tbody/tr/' + \
                         'td[@align="left"]'))
                    )
                bldgName = elem.text
                logging.info('Building name acquired.')
                # Download Plot Data
                elem = WebDriverWait(driver,wait).until( \
                    EC.presence_of_element_located( \
                        (By.XPATH, '//input[@value="Download Plot Data"]'))
                    )
                elem.click()
                # new tab will be opened; wait for load, then switch tabs
                while len(driver.window_handles) < 3:
                    time.sleep(delay)
                newTab = driver.window_handles[2]
                driver.switch_to_window(newTab)
                logging.info('Switched to tab 3.')
                # wait until data is fully downloaded
                found = False
                fName = None
                hasSlept = False
                ptFileExists = False
                while not found:
                    lsdir = os.listdir(dnldPath)
                    ptFileExists = False
                    for f in lsdir:
                        if not hasSlept:
                            if '.csv' in f and f[:3] == 'Dat':
                                time.sleep(1)
                                hasSlept = True
                                msg = 'Downloading building on row ' + \
                                      str(b) + ' -- ' + str(bldgName)
                                print msg
                                logging.info(msg)
                        else:
                            if not ptFileExists and \
                               '.csv' in f and f[:3] == 'Dat':
                                fName = f
                                found = True
                                time.sleep(0.5)
                            if '.part' in f:
                                ptFileExists = True
                                found = False
                logging.info('Data file downloaded.')
                # rename .csv data file
                newName = str(bldgName) + '.csv'
                os.rename(fName, newName)
                logging.info('Data file renamed.')
                # move data file to other folder
                shutil.move(newName, dataDir)
                logging.info('Data file moved.')
                # close Tab 3
                elem = WebDriverWait(driver,wait).until( \
                    EC.presence_of_element_located( \
                        (By.XPATH, '//body'))
                    )
                driver.close()
                logging.info('Tab 3 closed.')
                # switch to Tab 2
                while len(driver.window_handles) > 2:
                    time.sleep(delay)
                newTab = driver.window_handles[1]
                driver.switch_to_window(newTab)
                logging.info('Switched to tab 2.')
                # close Tab 2
                elem = WebDriverWait(driver,wait).until( \
                    EC.presence_of_element_located( \
                        (By.XPATH, '//body'))
                    )
                driver.close()
                logging.info('Tab 2 closed.')
                # switch to Tab 1
                while len(driver.window_handles) > 1:
                    time.sleep(delay)
                newTab = driver.window_handles[0]
                driver.switch_to_window(newTab)
                logging.info('Switched to tab 1.')
            # go back to Facilities page
            if b % 10 == 0: # refresh every once in a while
                driver.get(NYSERDAhome)
                elem = WebDriverWait(driver,wait).until( \
                    EC.presence_of_element_located((By.NAME, 'Facilities')) \
                    )
                elem.click()
            else:
                for i in range(nIn):
                    driver.back()
                time.sleep(delay)
                logging.info('Went back ' + str(nIn) + ' times to Facilities.')
            nIn = 0
            logging.info('b = ' + str(b) + '. Moving to b = ' + str(b+1) + '.')
            b += 1
        except KeyboardInterrupt:
            logging.info('KeyboardInterrupt Exception')
            break
        except Exception, e:
            logging.info('Failed to find element. Assume last row reached. ' \
                         + 'b = ' + str(b) + '. - ' \
                         + str(e))
            break

def logStart():
    logging.basicConfig(filename='NYSERDA_log.txt', \
                        level=logging.INFO, \
                        format=' %(asctime)s - %(levelname)s - %(message)s')
    logging.info('START: ' + os.path.basename(__file__))

def logEnd():
    logging.info('END: ' + os.path.basename(__file__) + '\n\n')

if __name__ == '__main__':
    logStart()
    main()
    logEnd()
