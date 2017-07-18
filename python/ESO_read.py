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
    ptMin, ptMax = getMinAndMax(dirsAbove)
    nPts = ptMax - ptMin + 1
    logging.debug(str(nPts) + ' data points to loop through')
    nZfill = len(str(ptMax))
    # be sure csv_files directory exists
    if not os.path.exists(os.path.join('..', 'csv_files')):
        os.mkdir(os.path.join('..', 'csv_files'))
    # for each point:
    for i in range(ptMin, ptMax+1):
        logPoint(i, ptMin, ptMax, nPts)
        pathDP = os.path.join('..', 'dataPoint'+str(i))
        dirsDP = listDirOrdered(pathDP)
        bpSearch = True
        bPath = None
        fPath = None
        for j, s in enumerate(dirsDP):
            if '-UserScript-0' in s and bpSearch:
                bpSearch = False
                pathOpt1 = os.path.join(pathDP, s, 'output')
                pathOpt2 = os.path.join(pathDP, s, 'mergedjob-0', 'output')
                if os.path.exists(pathOpt1):
                    bPath = pathOpt1
                else:
                    logging.debug('Path option 1 nonexistent. Trying path' \
                                  ' option 2...')
                    bPath = pathOpt2
            elif '-EnergyPlus-0' in s:
                fPath = os.path.join(pathDP, s, 'eplusout.eso')
                break
        # 01. execute ReadVarsESO on the .eso file
        copyESO(fPath)
        readESO()
        # 02. rename the .csv file according to building name
        newName = buildingName(bPath, i, nZfill)
        rename('eplusout.csv', newName)
        # 03. move the .csv file to the folder csv_files
        move(newName, csvDir)
    # clean up extraneous files
    cleanUp()
    # save number of data points in a shelf file
    save(nPts, 'nPts')

def getMinAndMax(dirsAbove):
    ptMin = 0
    ptMax = 0
    for d in dirsAbove:
        if 'dataPoint' in d:
            if int(d[9:]) > ptMax:
                ptMax = int(d[9:])
            if int(d[9:]) < ptMin or ptMin == 0:
                ptMin = int(d[9:])
    return ptMin, ptMax

def logPoint(p, ptMin, ptMax, nPts):
    pRel = p - ptMin + 1
    if pRel <= 5 or pRel%10 == 0 or p == ptMax:
        logging.debug('dataPoint' + str(p) + ' (' + str(pRel) + ' of ' + \
                      str(nPts) + ')...')

def listDirOrdered(dirPath):
    dirsList = os.listdir(dirPath)
    # find out whether there is a change in the number of digits
    indFirst = dirsList[0].find('-')
    indLast = dirsList[-1].find('-')
    if indFirst > indLast:
        # if so, return a re-ordered list
        orderedA = filter(lambda x: x.find('-')==indLast, dirsList)
        orderedB = filter(lambda x: x.find('-')>indLast, dirsList)
        orderedList = orderedA + orderedB
        return orderedList
    else:
        # if not, return the original list
        return dirsList

def copyESO(fPath):
    try:
        newPath = os.path.join('.','eplusout.eso')
        shutil.copyfile(fPath, newPath)
    except Exception, e:
        logging.error('Failed to copy eplusout.eso - ' + str(e))

def readESO():
    try:
        subprocess.check_call('ReadVarsESO.exe')
    except Exception, e:
        logging.error('Failed subprocess call of ReadVarsESO.exe - ' + str(e))

def buildingName(bPath, i, nZfill):
    try:
        newName = None
        dirsBP = os.listdir(bPath)
        if len(dirsBP) > 3:
            logging.warning('There is more than one directory in ' + bPath)
        for el in dirsBP:
            if not el == '.' and not el == '..':
                newName = el + '.csv'
        assert not newName == None
        return newName
    except Exception, e:
        logging.error('Failed to get building name from ' + bPath + ' - ' + \
                      str(e))
        return 'eplusout_' + str(i).zfill(nZfill) + '.csv'

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
