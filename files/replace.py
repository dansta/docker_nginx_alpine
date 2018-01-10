#!/usr/bin/env python3
""" python script to replace config parameters """

import os
import sys
import re


# read call parameters
FD = sys.argv[1]
KEYWORD = sys.argv[2]
REPLACEMENTDICT = {}
# open the config for reading, we replace in memory
try:
    with open(FD, 'r') as CONFIGFILE:
        CONFIGDATA = CONFIGFILE.read()
        CONFIGFILE.close()
# strip comments because they are not needed in containers
        CONFIGDATA = re.sub(r'#.*\n',
                            r'\n',
                            CONFIGDATA)
except IOError:
    exit(1)

# read the environment variables that match
for ENV_VAR in sorted(os.environ):
    if KEYWORD in ENV_VAR:
        KEY = re.sub(r'=.*\n',
                     r'',
                     ENV_VAR)
        VALUE = os.environ[ENV_VAR]
        REPLACEMENTDICT[KEY] = VALUE


# find and substitute env variables based on keyword prefix in the config file
for KEY, VALUE in REPLACEMENTDICT.items():
#    print(KEY, VALUE)
    if KEY in CONFIGDATA:
        CONFIGDATA = re.sub(KEY,
                            VALUE,
                            CONFIGDATA)

# open the config again for writing
try:
    with open(FD, 'w') as CONFIGFILE:
        CONFIGFILE.write(CONFIGDATA)
except IOError:
    exit(1)

# close politely
CONFIGFILE.close()
