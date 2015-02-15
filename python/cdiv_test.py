# -*- coding: utf-8 -*-
"""
Created on Mon Feb  9 18:32:07 2015

@author: heller
"""
# python 3 compatbility
from __future__ import print_function
from __future__ import division

import numpy as np


def cdiv_smith(x, y):
    """ACM Algorithm 116, Smith's Algorithm,
    http://cgi.di.uoa.gr/~ip/magic-sq.pdf
    see http://arxiv.org/pdf/1210.4539v2.pdf
    """
    a = np.real(x)
    b = np.imag(x)
    c = np.real(y)
    d = np.imag(y)

    if np.abs(c) >= np.abs(d):
        r = d/c
        den = c + r * d
        e = (a + b * r) / den
        f = (b - a * r) / den
    else:
        r = c/d
        den = d + r * c
        e = (a * r + b) / den
        f = (b * r - a) / den

    return complex(e, f)


"""
code from numpy git repo
  numpy/core/src/umath/loops.c.src
  bento.info says Version: 1.9.0
  I'm running 1.9.1 (why is git repo older???)

Heller: looks like Smith's, but we still get an error.  Is this the code that
actually running?  Looks like Harris is unconvinced.

  http://mail.scipy.org/pipermail/numpy-discussion/2006-February/018775.html


NPY_NO_EXPORT void
@TYPE@_divide(char **args, npy_intp *dimensions, npy_intp *steps, void *NPY_UNUSED(func))
{
    BINARY_LOOP {
        const @ftype@ in1r = ((@ftype@ *)ip1)[0];
        const @ftype@ in1i = ((@ftype@ *)ip1)[1];
        const @ftype@ in2r = ((@ftype@ *)ip2)[0];
        const @ftype@ in2i = ((@ftype@ *)ip2)[1];
        const @ftype@ in2r_abs = npy_fabs@c@(in2r);
        const @ftype@ in2i_abs = npy_fabs@c@(in2i);
        if (in2r_abs >= in2i_abs) {
            if (in2r_abs == 0 && in2i_abs == 0) {
                /* divide by zero should yield a complex inf or nan */
                ((@ftype@ *)op1)[0] = in1r/in2r_abs;
                ((@ftype@ *)op1)[1] = in1i/in2i_abs;
            }
            else {
                const @ftype@ rat = in2i/in2r;
                const @ftype@ scl = 1.0@c@/(in2r + in2i*rat);
                ((@ftype@ *)op1)[0] = (in1r + in1i*rat)*scl;
                ((@ftype@ *)op1)[1] = (in1i - in1r*rat)*scl;
            }
        }
        else {
            const @ftype@ rat = in2r/in2i;
            const @ftype@ scl = 1.0@c@/(in2i + in2r*rat);
            ((@ftype@ *)op1)[0] = (in1r*rat + in1i)*scl;
            ((@ftype@ *)op1)[1] = (in1i*rat - in1r)*scl;
        }
    }
}
"""


def cdiv_baudin(x, y):
    return robust_internal(x, y)


def robust_internal(x, y):
    """Baudin's algorithm"""

    def robust_subinternal(a, b, c, d):
        r = d/c
        t = 1/(c + c*r)
        e = internal_compreal(a, b, c, d, r, t)
        a = -a
        f = internal_compreal(b, a, c, d, r, t)
        return e, f

    def internal_compreal(a, b, c, d, r, t):
        if r != 0:
            br = b * r
            if br != 0:
                e = (a + br) * t
            else:
                e = a * t + (b * t) * r
        else:
            e = (a + d * (b/c)) * t
        return e

    a = np.real(x)
    b = np.imag(x)
    c = np.real(y)
    d = np.imag(y)

    if np.abs(d) <= np.abs(c):
        (e, f) = robust_subinternal(a, b, c, d)
    else:
        (e, f) = robust_subinternal(b, a, d, c)
        f = -f

    z = complex(e, f)
    return z


# [Numpy-discussion] get range of numpy type
#  http://www.mail-archive.com/numpy-discussion@scipy.org/msg09903.html


def cdiv_test():
    print(np.version.full_version)
    print(np.finfo('complex128').max)

    big = 1.0e160
    a = complex(big, big)

    q = a/a
    print(type(a), a,  type(q), q)

    a = np.cos(0)*a
    q = a/a
    print(type(a), a, type(q), q)

    q = cdiv_smith(a, a)
    print(type(a), a, type(q), q)

    q = robust_internal(a, a)
    print(type(a), a, type(q), q)


if __name__ == '__main__':
    cdiv_test()
