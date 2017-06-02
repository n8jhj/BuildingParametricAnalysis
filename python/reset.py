"""
This program deletes all eplusout_x.csv files in the current directory.
"""

import os
import shelve
import logging

shelfFile = 'shelf'
csvDir = os.path.join('..', 'csv_files')

def main():
    # get number of data points
    nPts = getNumDataPts()
    
    # delete .csv files and shelf file
    if not nPts == None and os.path.exists(csvDir):
        for i in range(1, nPts+1):
            delete(os.path.join(csvDir, 'eplusout_' + str(i) + '.csv'))
    if os.path.exists(shelfFile):
        delete(shelfFile)

def getNumDataPts():
    key = 'nPts'
    try:
        sFile = shelve.open(shelfFile)
        nPts = sFile[key]
        sFile.close()
        logging.debug(str(nPts) + ' .csv files to delete')
        return nPts
    except Exception, e:
        logging.error('Failed to extract ' + key + ' from ' + shelfFile + \
                      ' - ' + str(e))
        if os.path.exists(shelfFile):
            delete(shelfFile)

def delete(name):
    try:
        os.unlink(name)
        logging.debug('Unlinked ' + name)
    except Exception, e:
        logging.error('Failed to unlink ' + name + ' - ' + str(e))

def logStart():
    logging.basicConfig(filename='log.txt', \
                        level=logging.DEBUG, \
                        format=' %(asctime)s - %(levelname)s - %(message)s')
    logging.info('START: ' + os.path.basename(__file__))

def logEnd():
    logging.info('END: ' + os.path.basename(__file__) + '\n')

if __name__ == '__main__':
    logStart()
    main()
    logEnd()
