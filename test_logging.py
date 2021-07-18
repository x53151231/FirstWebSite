#!/usr/local/bin/python
# -*- coding:utf-8 -*-
import sys
import logging
import logging.config

print(sys.version)
logging.config.fileConfig('logging.cnf')


logging.debug('debug message')
logging.info('info message')
logging.warn('warn message')
logging.error('error message')
logging.critical('critical message')
