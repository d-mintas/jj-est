# -*- coding: utf-8 -*-
"""
Created on Thu Aug  4 17:16:31 2016

@author: Dino
"""

import os

import json
from pprint import pprint

import numpy as np
import pandas as pd


os.chdir('/Users/Dino/Downloads')

with open('steph_curry.json', 'r') as f:
    jd = json.load(f)

col_names = jd['resultSets'][0]['headers']

dlist = ([jd['resultSets'][0]['rowSet'][i] for i in
         range(len(jd['resultSets'][0]['rowSet']))])

dz = []

for a in dlist:
    dz.append(dict(zip(col_names, a)))

df = pd.io.json.json_normalize(dz)

with open('sc2.csv', 'x') as out:
    df.to_csv(out)
