# -*- coding: utf-8 -*-
"""
Created on Sat Jan 24 10:10:59 2015

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

c = constants.mach   # speed of sound in m/s at 15 C, 1 atm

_default_tolerance = 1e-10

_DEBUG = False


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

    orig_freq = freq
    freq = abs(freq)
    if freq < 1e-50:                # Series blows up for freq = 0
        return 1.0                  # H = 1.0 for DC

    x = np.cos(theta)
    mu = (2*pi * freq * radius) / c
    rho = source_range / radius

    if rho < 2:
        rho = np.longdouble(rho)
        mu = np.longdouble(mu)

    zr = 1 / (1j*mu*rho)
    za = 1 / (1j*mu)

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
        #term = term_num/term_dem
        # print(m, term, P, Qr, za, Qa, Qa1, term_num, term_dem)
        term = cdiv(term_num, term_dem)
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

def cdivs(a,b):
    q = a/b
    if np.isnan(q):
        print("simple NAN!!", q, a, b)
    return q

def ray_hrir(theta, source_range=None, radius=c/(2*pi),
             pad=1,
             advance=None,
             hf_cutoff=np.Inf):
    """
    ray_hrir(theta, [source_range, radius, advance])

    Computes the HRIR for an ideal sphere by inverting the HRTF

    Parameters
    ----------
    theta : float
        azimuth (radians)
    source_range : float, optional
        source to center (meters) [default = 100*radius]
    radius : float, optional
        head radius (m)           [default = c/(2*pi)]
    advance : float, optional
        left shift of waveform (sec) [default = 1.5 * (2*pi*radius/c)]

    Returns
    -------
    h : vector
        impulse response
    t : vector
        time of each sample in seconds
    fs : float
        sample rate in samples/second

    Notes
    -----
    The default range corresponds to the far-field solution.

    The default head radius results in the impulse response
    occurring in normalized time, tau = ( c t )/( 2 pi radius ).

    math:: \tau = (c t)/(2\pi radius)

    math:: X(e^{j\omega } ) = x(n)e^{ - j\omega n}

    Thus, in the impulse response plots, multiply the
    normalized time by ( 2000 pi radius ) / c to get the
    actual time in ms.
    For a = .09 m, this temporal scale factor is 1.65.

    Inverse FFT's are always periodic. Time delay in the impulse
    response causes wrap-around rather than loss. The program
    tries to get a nice looking graph by shifting the
    waveform to the left through the default value of "advance".
    If you don't want any shifting, use advance = 0, but be
    aware that for an azimuth less than 90 degrees, that will
    lead to a negative starting time, which wraps around and
    looks positive. As an alternative, you can apply the
    function numpy.roll(x,n) if you want to tinker.

    Since the effective duration of the impulse response
    (from the start of the pulse to its point of dying out)
    is well within the time for sound to go twice around the
    sphere, the program sets the observation period t_obs to be
    4 pi radius / c. (For a human head, this is about 3.7 ms;
    for the default head radius, it is exactly 2 units.)
    The program also uses N = 256 samples, which in turn
    determines the sampling rate, fs = N c / 4 pi radius
    This turns out to be about 70,000 samp/sec for a human head.
    Thus, the computed impulse response might reveal details
    that would not be seen experimentally at a lower sampling rate.
    However, you can always low-pass the results, if desired.
    """

    if radius is None:
        radius = c/(2*pi)  # default head radius for normalized frequency

    if advance is None:
        advance = 1.5 * (2*pi*radius/c)

    if source_range is None:
        source_range = 100*radius    # default source_range

    if source_range < radius:
        raise ValueError('range must be greater than radius')
    if pad < 1:
        raise ValueError('pad must be >=1')

    N = pad * 256                  # Compute H for N/2 positive frequencies
    t_obs = pad * (4*pi*radius)/c  # Duration of results, twice around the head

    fs = N/t_obs                    # Sampling frequency
    H = np.zeros(N, dtype=complex)  # HRTF
    t = np.arange(N)/fs             # Sampled times

    # Loop through positive frequencies and fill in HRTF
    if True:
        for k in range(N//2):
            freq = (k/N)*fs
            if freq > hf_cutoff:
                break
            H[k] = ray_hrtf(freq, theta, source_range, radius, 1e-16, 1000)
            # fill in negative frequencies
            H[N-k-1] = np.conj(H[k])
    else:
        # this is 3x slower than above!!
        H_list = Parallel(n_jobs=2) \
            (delayed(ray_hrtf)
             ((k/N)*fs, theta, source_range, radius, 1e-16, 1000)
             for k in range(N//2))
        H = np.append(H_list, np.conj(H_list[::-1]))

    # Find impulse response, HRIR is ifft of HRTF
    h = np.real(sp.ifft(H))

    # center impulse and advance
    h = np.roll(h, N//2 + int(np.round(advance*fs)))

    # low-pass filter IR to make better looking graphs
    if False:
        h = sps.lfilter((0.25, 0.5, 0.25), 1.0, h)

    return h, t, fs

#####


def head_to_sphere_radius(half_width, half_height, half_length):
    """
    Calculates optimal spherical model radius from head measurements
    using Eqn 3 in [1].

    Parameters
    ----------
    X1 : float
        head half-width (mm)
    X2 : float
        head half-height (mm)
    X3 : float
        head half-length (mm)

    Returns
    -------
    a_e : float
        sphere radius (meters)


    References
    ----------
    [1]	V. R. Algazi, C. Avendano, and R. O. Duda, “Estimation of a
    spherical-head model from anthropometry,” J. Audio Eng Soc, vol. 49, no. 6,
    pp. 472–479, Jun. 2001.
    """

    # cofficients are in paragraph following eqn 3
    w1 = 0.51
    w2 = 0.019
    w3 = 0.18
    b = 32.0   # mm.

    a_e = w1 * half_width + w2 * half_height, w3 * half_length + b

    # return value in meters
    return a_e/1000


def abs_sqr(x):
    return np.real(x * np.conjugate(x))


def random_incidence_response(source_range=2.0, sphere_radius=0.085,
                              low=20, high=20e3, nfreqs=50, plot=True):
    """
    Compute and plot the random incidence response for the spherical head
    model.
    """

    freqs = np.logspace(np.log10(low), np.log10(high), nfreqs)

    # normally we'd integrate over the full sphere, but ray_hrtf is radially
    # symmetric around theta=0, so we just integrate from in zenith angle
    def g(th):
        """ integrand """
        return np.sin(th) * abs_sqr(ray_hrtf(f, th, source_range, sphere_radius))
    # quad returns a tuple (result, abserr), use [0] to get result
    r = np.array([quad(g, 0, pi)[0] for f in freqs])/2

    # plot gain in dB vs freq
    if plot:
        plt.semilogx(freqs, 10*np.log10(r))  # 10 because it is energy (p^2)
        plt.xlim(low, high)
        plt.grid(True, which='both')
        plt.title("Random incidence response of spherical head model\n" +
                  ("range=%4g m, radius=%4g mm" %
                   (source_range, sphere_radius*1e3)))
        plt.xlabel('Frequency (Hz)')
        plt.ylabel('Gain (dB)')
    else:
        return r, freqs


def frequency_response(source_range=2.0, sphere_radius=0.085,
                       low=20, high=20e3, nfreqs=200, plot=True):

    freqs = np.logspace(np.log10(low), np.log10(high), nfreqs)

    thetas = np.linspace(0, pi, 7)

    r = np.array([[np.abs(ray_hrtf(f, th, source_range, sphere_radius))
                  for f in freqs]
                  for th in thetas])

    (r_diff, f_diff) = random_incidence_response(source_range, sphere_radius,
                                                 low, high, nfreqs, plot=False)
    #print(np.shape(r_diff), np.shape(freqs))

    if plot:
        fig = plt.figure(figsize=(8,5), dpi=300)
        plt.semilogx(freqs, 20*np.log10(np.transpose(r)))
        plt.semilogx(freqs, 10*np.log10(r_diff), lw=2, ls='--')

        plt.xlim(low, high)
        plt.legend(thetas * 180/pi, loc='upper left', bbox_to_anchor=(1.02, 1))
        plt.grid(True, which='both')
        plt.title("Frequency response for different incident angles\n" +
                  ("range=%4g m, radius=%4g mm" %
                   (source_range, sphere_radius*1e3)))
        plt.xlabel('Frequency (Hz)')
        plt.ylabel('Gain (dB)')
    else:
        return r, freqs, thetas, r_diff


def polar_response(source_range=2.0, sphere_radius=0.085,
                   low=20, high=20e3):

    freqs = np.logspace(np.log10(low), np.log10(high), 7)

    thetas = np.linspace(0, 2*pi, 180)
    r = np.array([[np.abs(ray_hrtf(f, th, source_range, sphere_radius))
                  for f in freqs]
                  for th in thetas])

    plt.polar(thetas, r)
    plt.legend(["%6.0f" % f for f in freqs], title="Freq. (Hz)", loc=(1.2, 0))
    plt.title("Polar response for different frequencies\n" +
              ("range=%4g m, radius=%4g mm" %
               (source_range, sphere_radius*1e3)))
    plt.show()

    #return r, freqs, thetas


def write_hrirs(hf_cutoff=np.Inf):
    sphere_radius = 85  # mm
    source_range = 2    # meters
    for theta in range(0, 181):
        h, t, fs = ray_hrir(theta*pi/180.0,
                            source_range, sphere_radius/1000,
                            pad=4, advance=0,
                            hf_cutoff=hf_cutoff)
        if np.isfinite(hf_cutoff):
            path = "/Users/heller/data/sh_hrir/hrir_%03dh_%02dr_%03dd_hf%04d.wav" \
                % (sphere_radius, source_range, theta, hf_cutoff)
        else:
            path = "/Users/heller/data/sh_hrir/hrir_%03dh_%02dr_%03dd.wav" \
                % (sphere_radius, source_range, theta)
        wav.write(path, fs, np.float32(h/4.0))


def waterfall_plot(thetas=np.linspace(0, 2*pi, 33),
                   source_range=2.0,
                   radius=0.085,
                   hf_cutoff=np.Inf,
                   peak_norm=None):
    for theta in thetas:
        start_time = timeit.default_timer()
        h, t, fs = ray_hrir(theta, source_range, radius,
                            pad=4, advance=0,
                            hf_cutoff=hf_cutoff)
        if _DEBUG:
            print(' execution time = %f sec\n' %
                  (timeit.default_timer() - start_time))
        peak_norm = peak_norm or np.max(abs(h))

        plt.plot(t*1000, 2*h/peak_norm + theta)
        plt.xlabel("time (ms)")
        plt.title(("HRIR, range = %4g meters, " % source_range) +
                  ("radius=%4g mm, " % (radius*1000)) +
                  ("HF cut=%5g Hz" % hf_cutoff))
        # print("sample rate = %f" % fs)


def itd_plot(thetas=np.linspace(0, 2*pi, 65),
             source_range=2.0, radius=0.085,
             hf_cutoff=300):
    h_max = np.zeros(np.shape(thetas), dtype=np.integer)
    for i in range(len(thetas)):
        h, t, fs = ray_hrir(thetas[i], source_range, radius, pad=4,
                            advance=0, hf_cutoff=hf_cutoff)
        # find peak of h
        h_max[i] = np.argmax(abs(h))

    times = t[h_max]
    plt.plot(thetas*180/pi, (times-times[0])*1e6)
    plt.xlabel("theta (deg)")
    plt.ylabel("ITD (usec)")
    plt.title("ITD (radius=%4g mm, range=%4g m, HF cut=%5g Hz)"
              % (radius*1e3, source_range, hf_cutoff))

    # return h_max, t[h_max], thetas


def dc_test(thetas=np.linspace(0, 2*pi, 33), source_range=2.0, radius=0.085):
    for theta in thetas:
        h, t, fs = ray_hrir(theta, source_range, radius, 2*pi*radius/c)
        hb = h
        hb[abs(hb) < 1e-4] = 0
        hb[abs(hb) >= 1e-4] = 1
        plt.plot(t*1000, h+theta)


def unit_test(choice=None):
    if choice is None:
        choice = input("1. write_hrirs\n" +
                       "2. waterfall\n" +
                       "3. itd_plot\n" +
                       "4. random incidence response\n" +
                       "5. free and diffuse response\n" +
                       "6. complex div test\n" +
                       " Selection: ")
    if choice in {1}:
        write_hrirs()
    elif choice in {2}:
        waterfall_plot()
    elif choice in {3}:
        itd_plot()
    elif choice in {4}:
        random_incidence_response()
    elif choice in {5}:
        frequency_response(source_range=2)
    elif choice in {6}:
        frequency_response(source_range=1.3*0.085)
    else:
        print("choice should be in [1..6] not %s\n!" % choice)


if __name__ == '__main__':
    unit_test()
