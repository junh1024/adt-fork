# -*- coding: utf-8 -*-
"""
Created on Tue Sep  8 17:36:42 2015

@author: heller
"""

from __future__ import division, print_function

import symYlm as ssh

import faustcode as fc


def panner_gain_expressions(order, **kwargs):
    fc.print_faust_vector("pg",
                          (fc.faust_code(ssh.Ylm(l,m, **kwargs)) 
                           for l in range(order+1) 
                           for m in range(-l, l+1)))
    
    
def ambix_panner(order):
    panner_gain_expressions(order, normalization=ssh.Norm.SN3D, four_pi=True)
    
def ACN_N3D_panner(order):
    panner_gain_expressions(order, normalization=ssh.Norm.N3D, four_pi=True)
    
    
def unit_tests():
    pass

if __name__ == '__main__':
    unit_tests()
