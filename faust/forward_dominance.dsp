// B-format Ambisonic Dominance

declare name		"Dominance";
declare version 	"1.0";
declare author 		"AmbisonicDecoderToolkit";
declare license 	"BSD 3-Clause License";
declare copyright	"(c) Aaron J. Heller, 2013";

/*
Copyright (c) 2013, Aaron J. Heller
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

1. Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
contributors may be used to endorse or promote products derived from
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

mu = library("music.lib");  // for db2linear

process = fd:vd;

// based on equations 3 and 4 from 
// M. A. Gerzon and G. J. Barton, “Ambisonic Decoders for HDTV,” Preprints from the 92nd Convention, Vienna, no. 3345, p. 42, 1992.

fd(W,X,Y,Z) = (1/2*a*W + sqrt(1/8)*b*X),  // new W
	      (1/2*a*X + sqrt(1/2)*b*W),  // new X
	      Y,                          // same Y
	      Z                           // same Z
 with {
  a = (L + 1/L);
  b = (L - 1/L);
  L = sqrt( fLsqr );
};

// +/- 12 dB slider with dezipping
fLsqr = hslider("Forward Dom [unit:dB]", 0, -12, +12, 0.1) : mu.db2linear : dezipper;

vd(W,X,Y,Z) = (1/2*a*W + sqrt(1/8)*b*Y),  // new W
	      X,                          // same X
	      Y,                          // same Y
	      (1/2*a*Z + sqrt(1/2)*b*W)   // new Z
 with {
  a = (L + 1/L);
  b = (L - 1/L);
  L = sqrt( vLsqr );
};

vLsqr = hslider("Vertical Dom [unit:dB]", 0, -12, +12, 0.1) : mu.db2linear : dezipper;


// UI "dezipper"
smooth(c) = *(1-c) : +~*(c);
dezipper = smooth(0.999);

