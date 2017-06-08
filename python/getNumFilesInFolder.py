import logging
import os

def main():
    cwd = os.getcwd()
    files = os.listdir(dataDir)
    print str(len(files)) + ' files in ' + str(cwd)

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
