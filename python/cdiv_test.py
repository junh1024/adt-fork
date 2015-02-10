# -*- coding: utf-8 -*-
"""
Created on Mon Feb  9 18:32:07 2015

@author: heller
"""
# python 3 compatbility
from __future__ import print_function
from __future__ import division

#from numba import jit, double, complex128, int32
import timeit   # study optimizations

import numpy as np
from numpy import pi

from joblib import Parallel, delayed

import scipy as sp
import scipy.constants as constants

# used to filter IRs to make prettier plots
import scipy.signal as sps

# used for writing impulses to RIF/WAV files
import scipy.io.wavfile as wav

from scipy.integrate import quad

# MATLAB style plotting
import matplotlib.pyplot as plt

import random


def cdiv_test(n=10000):
    for i in range(n):
        a = complex(random.randrange(1e149,1e151), - random.randrange(1e149,1e151))
        b = complex(random.randrange(1e158,1e160),   random.randrange(1e158,1e160))
        q = a/b
        print(q, a, b)
        if np.isnan(q):
            print("nan", a, b, q)
