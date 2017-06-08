import logging
import os

dnldPath = os.path.join('C:'+str(os.sep), 'Users', 'Admin', 'Downloads')
dataDir = os.path.join(dnldPath, 'NYSERDA_datafiles')

def main():
    dataFiles = os.listdir(dataDir)
    if not len(dataFiles) == 0:
        # delete all files in dataDir
        for f in dataFiles:
            print f
            os.unlink(os.path.join(dataDir, f))

def logStart():
    logging.basicConfig(filename='NYSERDA_log.txt', \
                        level=logging.DEBUG, \
                        format=' %(asctime)s - %(levelname)s - %(message)s')
    logging.info('START: ' + os.path.basename(__file__))

def logEnd():
    logging.info('END: ' + os.path.basename(__file__) + '\n\n')

if __name__ == '__main__':
    logStart()
    main()
    logEnd()
