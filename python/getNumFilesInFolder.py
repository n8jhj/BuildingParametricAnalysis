import logging
import os

def main():
    thisFile = os.path.basename(__file__)
    cwd = os.getcwd()
    files = os.listdir(cwd)
    nFiles = len(files)
    msg = str(nFiles) + ' files (including ' + thisFile + ' and log) in ' + \
          str(cwd)
    print msg
    logging.info(msg)

def logStart():
    logging.basicConfig(filename='log.txt', \
                        level=logging.DEBUG, \
                        format=' %(asctime)s - %(levelname)s - %(message)s')
    logging.info('START: ' + os.path.basename(__file__))

def logEnd():
    logging.info('END: ' + os.path.basename(__file__) + '\n\n')

if __name__ == '__main__':
    logStart()
    main()
    logEnd()
