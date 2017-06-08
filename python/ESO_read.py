"""
This program runs ReadVarsESO.exe for all eplusout.eso files in the directories
..\\dataPointx\\xx-EnergyPlus-0\\
ReadVarsESO.exe and RunReadESO.bat (both needed) can be found in
C:\\EnergyPlusV8-6-0\\PostProcess\\
"""

import os
import shutil
import subprocess
import shelve
import logging

shelfFile = 'shelf'
csvDir = os.path.join('..', 'csv_files')

def main():
    # get number of data points
    dirsAbove = os.listdir('..')
    nPts = 0
    for d in dirsAbove:
        if 'dataPoint' in d and int(d[9:]) > nPts:
            nPts = int(d[9:])
    logging.debug(str(nPts) + ' data points to loop through')

    # for each point:
    # 01. execute ReadVarsESO on the .eso file
    # 02. rename the .csv file according to the data point number
    # 03. move the .csv file to the folder csv_files
    if not os.path.exists(os.path.join('..', 'csv_files')):
        os.mkdir(os.path.join('..', 'csv_files'))
    for i in range(1, nPts+1):
        logPoint(i, nPts)
        dirsDP = os.listdir(os.path.join('..', 'dataPoint'+str(i)))
        fPath = None
        for j, s in enumerate(dirsDP):
            if '-EnergyPlus-0' in s:
                fPath = os.path.join('..', 'dataPoint'+str(i), s, 'eplusout.eso')
                break
        newPath = os.path.join('.','eplusout.eso')
        shutil.copyfile(fPath, newPath)
        readESOs()
        newName = 'eplusout_' + str(i) + '.csv'
        rename('eplusout.csv', newName)
        move(newName, csvDir)

    # clean up extraneous files
    cleanUp()

    # save number of data points in a shelf file
    save(nPts, 'nPts')

def logPoint(p, final):
    if p <= 5 or p%10 == 0 or p == final:
        logging.debug('point ' + str(p) + '...')

def readESOs():
    try:
        subprocess.check_call('ReadVarsESO.exe')
    except Exception, e:
        logging.error('Failed subprocess call of ReadVarsESO.exe - ' + str(e))

def rename(old, new):
    if not os.path.exists(new):
        try:
            os.rename(old, new)
        except Exception, e:
            logging.error('Failed to rename ' + old + ' - ' + str(e))
    else:
        logging.error('File ' + name + ' already exists')

def move(name, movePath):
    if not os.path.exists(os.path.join(movePath, name)):
        try:
            shutil.move(name, movePath)
            logging.debug('Moved ' + name + ' to ' + movePath)
        except Exception, e:
            logging.error('Failed to move ' + name + ' to ' + movePath + \
                          ' - ' + str(e))
    else:
        logging.error('File ' + name + ' already exists in ' + movePath)
        delete(name)

def cleanUp():
    delete('eplusout.eso')
    delete('readvars.audit')
    if os.path.exists('eplusout.csv'):
        delete('eplusout.csv')

def delete(name):
    logging.debug('Unlink: ' + name)
    try:
        os.unlink(name)
    except Exception, e:
        logging.error('Failed to unlink ' + name + ' - ' + str(e))

def save(var, key):
    try:
        sFile = shelve.open(shelfFile)
        sFile[key] = var
        sFile.close()
        logging.debug('Saved ' + key + ' to ' + shelfFile)
    except Exception, e:
        logging.error('Failed to shelf var ' + key + ' to ' + shelfFile + \
                      ' - ' + str(e))

def logStart():
    logging.basicConfig(filename='ESO_log.txt', \
                        level=logging.DEBUG, \
                        format=' %(asctime)s - %(levelname)s - %(message)s')
    logging.info('START: ' + os.path.basename(__file__))

def logEnd():
    logging.info('END: ' + os.path.basename(__file__) + '\n')

if __name__ == '__main__':
    logStart()
    main()
    logEnd()
