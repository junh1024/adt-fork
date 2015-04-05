declare name		"Rotate";
declare version 	"1.0";
declare author 		"AmbisonicDecoderToolkit";
declare license 	"BSD 3-Clause License";
declare copyright	"(c) Aaron J. Heller 2013";

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

/*
  Author: Aaron J. Heller <heller@ai.sri.com>
  $Id$
*/

m = library("math.lib");

// this order corresponds to moving a forward source at along lines of
// constant longitude (meridians) and latitude (parallels), and
// finally a twist: roll, pitch, yaw

process = rotx : roty : rotz;

// yaw
rotz(W,X,Y,Z) = W,
                cos(th)*X - sin(th)*Y,
                sin(th)*X + cos(th)*Y,
                Z
 with {
  th = hslider("Z Rotation [unit:Degrees]", 0, -180, 180, 1) : deg2rad : dezipper;
};

// pitch
roty(W,X,Y,Z) = W,
                cos(th)*X - sin(th)*Z,
		Y,
                sin(th)*X + cos(th)*Z
 with {
  th = vslider("Y Rotation [unit:Degrees]", 0, -90, 90, 1) : deg2rad : dezipper;
};

// roll
rotx(W,X,Y,Z) = W,
		X,
                cos(th)*Y - sin(th)*Z,
                sin(th)*Y + cos(th)*Z
 with {
  th = vslider("X Rotation [unit:Degrees]", 0, -180, 180, 1) : deg2rad : dezipper;
};

deg2rad = *(m.PI/180.0);

// UI "dezipper"
smooth(c) = *(1-c) : +~*(c);
dezipper = smooth(0.999);