Ambisonic Decoder Toolbox
=========================

The Ambisonic Decoder Toolbox is a collection of MATLAB and GNU Octave
functions for creating Ambisonic Decoders. Currently, it implements

1. the AllRAD design technique [1-3]
2. the inversion or mode-matching, Appendix 1 of [14]
3. truncated mode-matching
4. constant energy [15]
5. linear combinations of 2 and 3
6. Slepian function basis (EPAD) [16,17]

Details of these are described in our LAC2014 paper [20].

The toolbox takes loudspeaker locations as input and writes out
decoders in Faust [5] that can be compiled to VST, Supercollider, Pd,
MaxDSP, ...  (see http://faust.grame.fr/ for more about Faust), as
well as presets for Ambdec and Matthias Kronlachner's ambiX plugins
(http://www.matthiaskronlachner.com/?p=2015).  By default, decoders
are written into the directory ../decoders.  This can be changed by
editing the file `ambi_decoders_dir.m.`

The Faust implementation supports near-field correction (NFC) up to
fifth-order (this can be extended, if needed), level and distance
compensation, and phase-matched bandsplitting filters for two-band
decoding.  Three decoder topologies are supported, single band,
single-matrix with shelf filters, and dual-matrix (Vienna).  In the
two-band decoders, the crossover frequency and low/high frequency
balance can be adjusted interactively.

The toolbox supports all of the normalization and channel order 
conventions that we are aware of at the time of this writing. [10,11]. 
Two mixed-order schemes are supported, the one used in AMB files [12]
and the newer one proposed by Chris Travis [13] that is used in the 
preset files that are included with AmbDec. 

Speaker locations and names can be specified in CSV files, although
most users specify them directly in a top-level 'run-' file, using the
toolbox function `ambi_spkr_array()`.  There is also code to read them
from AmbDec presets.

To use the code you will need to add the ./matlab directory to your
loadpath.  One way to do this is to cd to the matlab directory and
execute:

    > addpath(pwd)
   
then cd to the examples directory

    > cd ../examples

See the files examples/run_*.m for sample invocations.  Most users
create a 'run' file for their specific speaker array.

*Note:* There are still a few loose ends -- the performance plots (rE,
directional error) work well only in MATLAB, and there needs to be bit
of sanity checking on the loudspeaker locations, but it is quite
usable.

The file format for AmbDec presets was reversed engineered from the
AmbDec source code and included presets.  If you encounter
difficulties with the AmbDec presets generated by this toolbox, please
contact me rather than Fons Adriaensen (author of AmbDec).

There is also some code to interface with the IDHOA optimizer [18,19],
which is available on GitHub (https://github.com/BarcelonaMedia-Audio/idhoa).

The ./doc directory has our Linux Audio Conference 2014 paper [20] and
slides from the talk given May 3, 2014.  Video of the talk is archived
[here](http://lac.linuxaudio.org/2014/video.php?id=12).

We are happy to answer any technical questions about the toolbox or
Ambisonics in general.

Please consult the
[FAQ](https://bitbucket.org/ambidecodertoolbox/adt/src/master/FAQ.md)
for answers to questions I have received from users.



Licenses
--------

The code in the Toolbox that has been written by me is licensed under
the Gnu Affero General Public License (see LICENSE or
http://www.gnu.org/licenses/ for a copy).  The Faust code generated by
the toolbox is covered by the BSD 3-Clause License, so that it may be
combined with other code without restriction. If these terms are an
impediment to your use of the toolbox, please contact me with details of
your application.

Some functions and data were downloaded from other sources and are
covered by other licenses.  These are listened in the AUTHORS file.

Please note that the Faust backend is capable of producing Ambisonic
decoders that may be covered by US Patent 5,757,927 and possibly
others. The AllRAD and EPAD design techniques were implemented from
published descriptions [1,2,3,16], which do not assert any
intellectural property rights.  Please consult your own legal council
with any intellectual property questions about your use is this
Toolbox.

Author
------
Aaron J. Heller <heller@ai.sri.com>


References
----------

[1] F. Zotter, M. Frank, and A. Sontacchi, "The Virtual T-Design
Ambisonics-Rig Using VBAP," presented at the 1st EAA-EuoRegio 2010
Congress on Sound and Vibration, Ljubljana, Slovenia, 2010, pp. 1-4.

[2] F. Kaiser, "A Hybrid Approach for Three-Dimensional Sound
Spatialization," Algorithmen in Akustik und Computermusik 2, SE, May
2011.

[3] F. Zotter and M. Frank, "All-Round Ambisonic Panning and
Decoding," J. Audio Eng Soc, vol. 60, no. 10, pp. 807–820, Nov. 2012.

[4] F. Adriaensen, "AmbDec - 0.4.2 User Manual,"
kokkinizita.linuxaudio.org, 05-Oct-2009.

[5] J. O. Smith, "Audio Signal Processing in FAUST," pp. 1–40,
Apr. 2013.  https://ccrma.stanford.edu/~jos/aspf/

[6] R. H. Hardin and N. J. A. Sloane, "McLaren's Improved Snub Cube
and Other New Spherical Designs in Three Dimensions," arXiv.org,
vol. math.CO. 23-Jul-2002.

[7] R. H. Hardin and N. J. A. Sloane, "Spherical Designs,"
http://www2.research.att.com/~njas/sphdesigns/

[8] V. Pulkki, "Virtual Sound Source Positioning Using Vector Base
Amplitude Panning," J. Audio Eng Soc, vol. 45, no. 6, pp. 456–466,
Jun. 1997.

[9] H. Choi, "An Alternative Implementation of VBAP with Graphical
Interface for Sound Motion Design," presented at the 18th
International Conference on Auditory Display, Atlanta, 2012, pp. 1–5.

[10] D. G. Malham, "Higher order Ambisonic systems," Mphil Thesis,
University at York, 2003.

[11] R. Furse, "3D Audio Links and Information," Available:
http://www.muse.demon.co.uk/3daudio.html.

[12] "File Format for B-Format; The '.amb' Format,"
http://members.tripod.com/martin_leese/Ambisonic/B-Format_file_format.html

[13] C. Travis, "A New Mixed-Order Scheme for Ambisonic Signals,"
presented at the Proc. 1st Ambisonics Symposium, 2009, pp. 1–6.

[14] A. Heller, R. Lee, and E. M. Benjamin, "Is My Decoder
Ambisonic?," AES 125th Convention, San Francisco, pp. 1–21, Dec. 2008.

[15] Pomberger, Hannes and Franz Zotter,  "Ambisonic panning with
constant energy constraint," in: DAGA 2012, 38th German Annual
Conference on Acoustics.

[16] Zotter, Franz, Hannes Pomberger, and Markus Noisternig,
"Energy-Preserving Ambisonic Decoding," in: Acta Acustica united with
Acustica 98.1, pp. 37–47.

[17] Simons, Frederik J., F. A. Dahlen, and Mark A. Wieczorek,
"Spatiospectral Concentration on a Sphere," in: SIAM review 48.3,
pp. 504–536.

[18] D. Arteaga, “An Ambisonics Decoder for Irregular 3-D Loudspeaker
Arrays,” presented at the AES 134th Convention, Rome, 2013.

[19] D. Scaini and D. Arteaga, “Decoding of High Order Ambisonics to
Irregular Periphonic Loudspeaker Arrays,” presented at the AES 55th
Conference, Helsinki, 2014, pp. 1–8.

[20] A. Heller and E. M. Benjamin, "The Ambisonic Decoder Toolbox:
Extensions for Partial-Coverage Loudspeaker Arrays," presented at the
Linux Audio Conference 2014, Karlsruhe, 2014.  http://lac.linuxaudio.org/2014/papers/17.pdf

[21] M. Graf and D. Potts, “On the computation of spherical designs by
a new optimization approach based on fast spherical Fourier
transforms,” Numerische Mathematik, vol. 119, no. 4, pp. 699–724,
Dec. 2011.

[22] D. M. Murillo, F. M. Fazi, and M. Shin, "Evaluation of Ambisonics
Decoding Methods with Experimental Measurements," presented at the
The EAA Joint Symposium on Auralization and Ambisonics, Berlin, 2014.
