# -*- coding: utf-8 -*-
"""
Created on Tue Sep  8 17:36:42 2015

@author: heller
"""

from __future__ import division, print_function

import symYlm as ssh

import faustcode as fc


def panner_gain_expressions(order, varname="panner_gains", **kwargs):
    fc.print_faust_vector(varname,
                          (fc.faust_code(ssh.Ylm(l,m, **kwargs)) 
                           for l in range(order+1) 
                           for m in range(-l, l+1)))
    
    
def ambix_panner(order, sph=False):
    panner_gain_expressions(order, "gains_ACN_SN3D", sph=sph, normalization=ssh.Norm.SN3D, four_pi=True)
    
def ACN_N3D_panner(order, sph=False):
    panner_gain_expressions(order, "gains_ACN_N3D", sph=sph, normalization=ssh.Norm.N3D, four_pi=True)
    
    
def unit_tests():
    max_order = 5;
    ambix_panner(max_order)
    ambix_panner(max_order, sph=True)
    ACN_N3D_panner(max_order)
    ACN_N3D_panner(max_order, sph=True)

if __name__ == '__main__':
    unit_tests()
