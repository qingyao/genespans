#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jul 31 12:29:36 2018

@author: pgweb
"""

import yaml
import pymongo
client = pymongo.MongoClient()

with open('genespans.yml','r') as ymlfile:
    gsdata = yaml.load(ymlfile)

gsdata = [gsdata[i] for i in gsdata]

db = client['progenetix']

db.drop_collection('genespans')
genespans = db.genespans

genespans.insert_many(gsdata)

genespans.create_index([('gene_symbol', pymongo.ASCENDING)])
genespans.create_index([('reference_name', pymongo.ASCENDING)])
genespans.create_index([('cds_start_min', pymongo.ASCENDING)])
genespans.create_index([('cds_end_max', pymongo.ASCENDING)])
genespans.create_index([('gene_entrez_id', pymongo.ASCENDING)]) 
