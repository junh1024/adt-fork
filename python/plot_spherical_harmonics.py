# -*- coding: utf-8 -*-
"""
Created on Sat Mar 15 16:09:40 2014

@author: heller
"""

#from numba import jit

import sys

from pylab import *
from mpl_toolkits.mplot3d import Axes3D

from real_spherical_harmonics import real_sph_harm

#@jit
def sph_plot(l,m):

    theta_range = np.linspace(0,2*np.pi,90,endpoint=True)
    phi_range   = np.linspace(0,  np.pi,45,endpoint=True)
    
    theta,phi = np.meshgrid(theta_range,phi_range)
    
    Ylm = real_sph_harm(m,l,theta,phi)
    rho = abs(Ylm)
    
    X = rho * cos(theta) * sin(phi)
    Y = rho * sin(theta) * sin(phi)
    Z = rho *              cos(phi)

    if 0:
        Ylm_scaled = ( Ylm - np.amin(Ylm) )/(np.amax(Ylm) - np.amin(Ylm))
    else:
        Ylm_scaled = Ylm
    
    if len(sys.argv) > 3:
        # plain old mplot3d
        fig = figure()
        ax = Axes3D(fig)
        ax.plot_surface(X, Y, Z, 
                    facecolors=cm.jet(Ylm_scaled), 
                    rstride=1, cstride=1,
                    antialiased=True )
    
    
        gscale = [x * 0.5 for x in [-1, 1]]
        ax.auto_scale_xyz(gscale, gscale, gscale)
        show()
        
    else:
        # try fancy mayavi2 stuff
        from mayavi import mlab
        
        s = mlab.mesh(X, Y, Z, scalars=Ylm_scaled, vmax=1,vmin=-1) #, extent=[-1, 1, -1, 1, -1, 1])
        mlab.colorbar(s, orientation='vertical',nb_labels=5)
        mlab.title("Real Ylm, l="+str(l)+" m="+str(m),size=0.35,height=0.9)
        mlab.outline(s, extent=[-1, 1, -1, 1, -1, 1])
        mlab.axes(s, extent=[-1, 1, -1, 1, -1, 1],nb_labels=3)
        mlab.show()


    
def num (s):
    try:
        return int(s)
    except exceptions.ValueError:
        return float(s)
    
print 'Number of arguments:', len(sys.argv), 'arguments.'
print 'Argument List:', str(sys.argv)

if len(sys.argv) < 2:
    print "usage: degree order, with abs(order) <= degree"
    sys.exit(1)

degree = num(sys.argv[1]);
order  = num(sys.argv[2]);

if abs(order) > degree:
    print "error abs(order) > degree"
    sys.exit(1)
else:
    sph_plot(degree,order)


