# -*- coding: utf-8 -*-
"""
Created on Fri Mar 14 09:21:47 2014

@author: heller
"""
#import scipy
from scipy import integrate, special, pi, sin, cos, sqrt

from numpy import ma

#print scipy.special.sph_harm(0,1,0,scipy.pi/2)

#(q,e) = dblquad(lambda y,x: sin(y), 0,2*pi, lambda x: 0, lambda y:pi)

#print q/(4*scipy.pi)
#print e

def dblquad_test():
    (qq,ee) = integrate.dblquad(lambda y,x: cos(y)**2 * sin(y), 0,2*pi, lambda x: 0, lambda y:pi)
    print qq


def check_sph_ortho(l1,m1,l2,m2):
    q,_ = integrate.dblquad(
                # arguments to lambda need to be reversed from args to dblquad (wtf?)
                lambda phi,theta:
                    # scipy sph_harm takes order/degree  (wtf?)
                    special.sph_harm(m1,l1,theta,phi)*
                    ma.conjugate(special.sph_harm(m2,l2,theta,phi))*
                    sin(phi),
                0, 2*pi,  # range of theta
                lambda x:0, lambda y:pi # range of phi
                )
    return q

def ortho_test_complex():
    for l1 in range(0,4):
        for m1 in range(0,l1+1):
            for l2 in range(0,4):
                for m2 in range(0,l2+1):
                    print l1,m1,l2,m2, round(check_sph_ortho(l1,m1,l2,m2),8)

def real_sph_harm(m,l,theta,phi):
    Y = special.sph_harm(abs(m),l,theta,phi)
    if m < 0:
        return (-1)**abs(m) * sqrt(2) * Y.imag
    elif m > 0:
        return (-1)**abs(m) * sqrt(2) * Y.real
    else:
        return Y.real

def check_real_sph_ortho(l1,m1, l2,m2):
    q,_ = integrate.dblquad(
                # arguments to lambda need to be reversed from args to dblquad (wtf?)
                lambda phi,theta:
                    # scipy sph_harm takes order/degree  (wtf?)
                    real_sph_harm(m1,l1,theta,phi)*
                    real_sph_harm(m2,l2,theta,phi)*
                    sin(phi),
                0, 2*pi,  # range of theta
                lambda x:0, lambda y:pi # range of phi
                )
    return q

def ortho_test_real(max_degree=3):
    for l1 in range(0,max_degree):
        for m1 in range(-l1,l1+1):
            for l2 in range(0,4):
                for m2 in range(-l2,l2+1):
                    print l1,m1,l2,m2, round(check_real_sph_ortho(l1,m1,l2,m2),8)

