//declare name		"ambix2fuma";
declare version 	"1.0";
declare author 		"AmbisonicDecoderToolkit";
declare license 	"BSD 3-Clause License";
declare copyright	"(c) Aaron J. Heller 2014";

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


// bus with gains
gain(c) = R(c) with {
  R((c,cl)) = R(c),R(cl);
  R(1)      = _;
  R(0)      = !;
  //R(0)      = !:0; // if you need to preserve the number of outputs
  R(float(0)) = R(0);
  R(float(1)) = R(1);
  R(c)      = *(c);
};

// n = number of inputs
// m = number of output
A2F_matrix(n,m) = par(i,n,_) <: par(i,m,gain(A2F(i)):>_);
F2A_matrix(n,m) = par(i,n,_) <: par(i,m,gain(F2A(i)):>_);

order_in(1) = (_,_,_,_,0,0,0,0,0,0,0,0,0,0,0,0);
order_in(2) = (_,_,_,_,_,_,_,_,_,0,0,0,0,0,0,0);
order_in(3) = (_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_);

order_out(1) = (_,_,_,_,!,!,!,!,!,!,!,!,!,!,!,!);
order_out(2) = (_,_,_,_,_,_,_,_,_,!,!,!,!,!,!,!);
order_out(3) = (_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_);

process = order_in(ambi_order):F2A_matrix(n_inputs, n_outputs):order_out(ambi_order);
//process = order_in(ambi_order):A2F_matrix(n_inputs, n_outputs):order_out(ambi_order);

// ==== no user servicible parts above here =====

//declare name		"ambix2fuma";
declare name		"fuma2ambix";

ambi_order = 3;

n_inputs = 16;
n_outputs = 16;

A2F(00) = (0.7071067812,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0);
A2F(01) = (           0,            0,            0,            1,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0);
A2F(02) = (           0,            1,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0);
A2F(03) = (           0,            0,            1,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0);
A2F(04) = (           0,            0,            0,            0,            0,            0,            1,            0,            0,            0,            0,            0,            0,            0,            0,            0);
A2F(05) = (           0,            0,            0,            0,            0,            0,            0,  1.154700538,            0,            0,            0,            0,            0,            0,            0,            0);
A2F(06) = (           0,            0,            0,            0,            0,  1.154700538,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0);
A2F(07) = (           0,            0,            0,            0,            0,            0,            0,            0,  1.154700538,            0,            0,            0,            0,            0,            0,            0);
A2F(08) = (           0,            0,            0,            0,  1.154700538,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0);
A2F(09) = (           0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            1,            0,            0,            0);
A2F(10) = (           0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,  1.185854123,            0,            0);
A2F(11) = (           0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,  1.185854123,            0,            0,            0,            0);
A2F(12) = (           0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,  1.341640786,            0);
A2F(13) = (           0,            0,            0,            0,            0,            0,            0,            0,            0,            0,  1.341640786,            0,            0,            0,            0,            0);
A2F(14) = (           0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,  1.264911064);
A2F(15) = (           0,            0,            0,            0,            0,            0,            0,            0,            0,  1.264911064,            0,            0,            0,            0,            0,            0);


F2A(00) = (1.414213562,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0);
F2A(01) = (0,            0,            1,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0);
F2A(02) = (0,            0,            0,            1,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0);
F2A(03) = (0,            1,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0);
F2A(04) = (0,            0,            0,            0,            0,            0,            0,            0, 0.8660254038,            0,            0,            0,            0,            0,            0,            0);
F2A(05) = (0,            0,            0,            0,            0,            0, 0.8660254038,            0,            0,            0,            0,            0,            0,            0,            0,            0);
F2A(06) = (0,            0,            0,            0,            1,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0);
F2A(07) = (0,            0,            0,            0,            0, 0.8660254038,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0);
F2A(08) = (0,            0,            0,            0,            0,            0,            0, 0.8660254038,            0,            0,            0,            0,            0,            0,            0,            0);
F2A(09) = (0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,  0.790569415);
F2A(10) = (0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0, 0.7453559925,            0,            0);
F2A(11) = (0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0, 0.8432740427,            0,            0,            0,            0);
F2A(12) = (0,            0,            0,            0,            0,            0,            0,            0,            0,            1,            0,            0,            0,            0,            0,            0);
F2A(13) = (0,            0,            0,            0,            0,            0,            0,            0,            0,            0, 0.8432740427,            0,            0,            0,            0,            0);
F2A(14) = (0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0, 0.7453559925,            0,            0,            0);
F2A(15) = (0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,            0,  0.790569415,            0);
