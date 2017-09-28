Ambisonic Decoder Toolbox-fork
=========================

This is my fork of the "Ambisonic Decoder Toolbox" found at https://bitbucket.org/ambidecodertoolbox/adt originally by Aaron J. Heller.

This fork is intended to be for practical audio use, not for academic use.

Aim is to make it more usable & compact.

Changes so far
----
* Space reductions: removing large uneeded files & compressing PDFs (The upshot is that it is now only takes up ~10M.)
* Auro & ITU decoder channels are now in SMPTE-ish order
* 7.0 ITU decoder completed, with implementable info for additional ITU configs
* Auro decoder is 9.0 instead of 10.1 to support AMBEO
* Removed some info during config generation
* Plots off by default for faster, error-free generation

Useful info
----
If you're hacking/building your own decoders, if your vertical plane is irregular, say, Auro 3D 9.0, the height later takes from expected, but the ELL layer is partway between ELL & bottom to take the sound of ELL & the non-existent bottom layer. At least, this is true for 1oA. If you're making oA *encoders* instead, the coefficients can be very different to decoders, especially for irregular configs. Try to pad to regular shapes, make a decoder, then base your encoder off that.

Tips
----
* If you have >2 vertical speaker layers, you should use 2oA+ v
* If you have >4 horizontal speakers, you should use 2oA+ h
* If you have an irregular config, you should use 2oA +
* You should be using >1oA anyway, as 1oA is blurry.
* If you're playing back 2D 1oA or 1oA mixes with major content on the horizontal plane on >2 vertical speaker layers, the R channel from 2oA is important for Z resolution, otherwise ELL will be smeared over the height
