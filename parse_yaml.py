#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jul 31 10:41:08 2018

@author: pgweb
"""

import pandas as pd
import yaml

mytable = pd.read_table('table.tsv')
mydict = mytable.to_dict('index')
with open('genespans.yml', 'w') as outfile:
    yaml.dump(mydict, outfile, default_flow_style=False)


