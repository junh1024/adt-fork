# -*- coding: utf-8 -*-
"""
Created on Tue Feb 10 19:09:19 2015

@author: heller
"""
# python 3 compatbility
from __future__ import print_function
#from __future__ import division


import numpy as np
from numpy import pi

import scipy.constants as constants

c = constants.mach   # speed of sound in m/s at 15 C, 1 atm

_default_tolerance = 1e-10

# _DEBUG = False


# jit does not speed this up (why?)
# @jit(complex128(double, double, double, double, double, int32))
def ray_hrtf(freq, theta, source_range=None, radius=c/(2*pi),
             tolerance=_default_tolerance, iter_max=1000):
    """
    ray_hrtf(freq, theta, [source_range, radius tolerance, iter_max])

    Compute Lord Rayleigh's solution for the diffraction of a point sound
    source by a rigid sphere. Normalized to free-field.

    Parameters
    ----------

    freq : float
        frequency (Hz)
    theta : float
        azimuth (radians)
    source_range : float, optional
        source to center (m)      [default = 100*radius]
    radius : float, optional
        head radius (m)           [default = c/(2*pi)]
    tolerance : float, optional
        allowed fractional error  [default = 1e-16]
    iter_max : integer, optional
        maximum iterations        [default = 1000]

    Returns
    -------
    H : complex
        complex transfer function at specified frequency

    Notes
    -----
    Normalized frequency formula:
       mu = (2*pi*radius/lambda) = (2*pi*radius/c)*freq = wave_number*radius

    Thus, if radius = c/(2*pi), mu = freq

    Typical range for mu: .1 to 100.

    Normalized range formula:

       rho = range/radius

    Value must be greater than 1; converges slowly when near 1.
    Typical range for rho: 1.15 to 100.

    We follow physics conventions, and use exp(-jwt) for the source;
    the conjugate that is applied at the very end is needed to get the EE's
    transfer function

    References
    ----------

    [1] M. M. Morse and K. U. Ingard, 'Theoretical Acoustics' (Princeton
    University Press, 1968). Section 7.2 provides the core content. Watch out
    for the typo in Eq. 7.2.8: +m(m-1) should be -m(m+1).

    2. J. L. Bauch and D. H. Cooper, "On acoustical specification of natural
    stereo imaging," preprint 1649, 66th AES Convention, Los Angeles, 1980.
    Shows how to use the resursion formulas to compute H. Watch out for the
    typos in Eqs. A-9, A-1O and A13: the second j sub m-1 should be  j sub m+1.

    3. W. M. Rabinowitz, J. Maxwell, Y. Shao and M. Wei, "Sound localization
    cues for a magnified head: Implications from sound diffraction about a
    rigid sphere," Presence, Vol. 2, No. 2, pp. 125-129 (Spring 1993). This
    implementation essentially follows their Eq. 1, but normalized by their
    free-field solution, Eq. 2. However, they specify a source velocity when
    it should be a flow.

    4. R. 0. Duda and W. M. Martens, "Range dependence of the response of a
    spherical head model," J. Acoust. Soc. Am., Vol. 104, No. 5, pp. 3048-3058
    (November 1998). Gives the complete theory for this code.
    """

    if source_range is None:
        source_range = 100*radius

    if source_range < radius:
        print("Range must be greater than radius")

    freq = np.longdouble(freq)
    theta = np.longdouble(theta)

    orig_freq = freq
    freq = abs(freq)
    if freq < 1e-50:                # Series blows up for freq = 0
        return 1.0                  # H = 1.0 for DC

    x = np.cos(theta)
    mu = (2*pi * freq * radius) / c
    rho = source_range / radius
    zr = 1.0 / (1j*mu*rho)
    za = 1.0 / (1j*mu)

    # set up the first two terms of recurrence relationship
    Qr2 = zr                        # Q is the complex polynomial part
    Qr1 = zr * (1-zr)               # of the spherical Hankel function;
    Qa2 = za                        # "2" means back twice in time, "1" once
    Qa1 = za * (1-za)

    P2 = 1.0                        # P is the Legendre polynomial
    P1 = x                          # "2" means back twice in time, "1" once

    Sum = 0.0

    # the m = 0 term
    term = zr / (za * (za - 1))     # The m=0 term
    Sum += term

    # the m = 1 term
    term = (3 * x * zr * (zr-1)) / (za * (2 * za**2 - 2*za + 1))
    Sum += term               # The m=1 term added in

    oldratio = 1.0
    newratio = abs(term)/abs(Sum)

    m = 2                           # Index for the term in the Sum
    while oldratio > tolerance or newratio > tolerance:
        if m > iter_max:
            print("""
            ** Iteration limit exceeded in RayHRTF **
            \t freq         =  %11.5e
            \t theta        =  %11.5e
            \t source_range =  %11.5e
            \t radius       =  %11.5e
            \t tolerance    =  %11.5e
            \t iter_max     =  %11.5e
            """ % (freq, theta, source_range, radius, tolerance, iter_max))
            break

        Qr = -(2*m-1)*zr*Qr1+Qr2
        Qa = -(2*m-1)*za*Qa1+Qa2
        P = ((2*m-1)*x*P1-(m-1)*P2)/m

        term_num = (2*m+1) * P * Qr
        term_dem = (m + 1) * za * Qa - Qa1

        # term = ((2*m+1) * P * Qr) / ((m + 1) * za * Qa - Qa1)
        # term = term_num/term_dem
        print(m, term, P, Qr, za, Qa, Qa1, term_num, term_dem)
        term = cdivs(term_num, term_dem)
        if np.isnan(term):
            print("term is nan")
            print(m, term, P, Qr, za, Qa, Qa1, term_num, term_dem)
            break

        Sum += term

        # get ready for next iteration
        m += 1
        Qr2, Qr1 = Qr1, Qr
        Qa2, Qa1 = Qa1, Qa
        P2, P1 = P1, P
        oldratio, newratio = newratio, np.abs(term)/np.abs(Sum)

    H = (rho*np.exp(-1j*mu) * Sum) / (1j * mu)
    if orig_freq > 0:
        H = np.conj(H)                   # convert to EE style

    return H


def cdiv_wtf():
    return ((-2.30904201149e+151-1.97596452689e+151j)
            /
            (-6.85281000623e+156-3.74972445929e+156j))


def cdiv(a, b):
    f = 1/np.abs(b)
    a = a*f
    b = b*f

    q = a/b
    if np.isnan(q):
        print("normalzed NAN!!", q, f, a, b)
    return q


def cdivs(a, b):
    q = a/b
    if np.isnan(q):
        print("simple NAN!!", q, a, b, type(q), type(a), type(b))
    return q


def unit_test():
    print(ray_hrtf(20, 0, 1.1*0.085, 0.085))

if __name__ == '__main__':
    unit_test()
