Ambisonic Decoder Toolbox Frequently Asked Questions (and answers!)
===================================================================

**Q) Can I use the ADT to create my own presets for AmbDec / Ambix
  with Matlab, based on specific azimuth, elevation and distance from
  the center to each of the speakers in a custom speakers layout?**

A) Yes, that is exactly what it was designed to do.  Besides Ambdec
and AmbiX presets, it also creates decoders in the Faust DSP language
that can be compiled into a number of different plugin formats and
OSes.  But... it can't work miracles -- the speaker layout needs to be
reasonable; the more uniform the better.  It produces a number of
performance plots that can be used to get a quick idea of how well a
particular design technique works for a given speaker layout.

Note that Fons Adriaensen (author of AmbDec) will make Ambdec presets
for custom loudspeaker layouts.  He says that the decoder design
techniques he uses are superior to what is available in the ADT.
Consult the Ambdec document for contact information.

---

**Q) How do I interpret the performance plots?  What can I adjust?**

A) The key thing I look at are the grid plots and the direction
difference between rE and rV, as well as performance at the horizon
for partial coverage arrays, such as domes.

As for adjustments...

* with the PINV decoders, you can adjust ‘alpha’ which trades between
  directional accuracy and uniform loudness.

* with the AllRAD, you can play with the location of the virtual
  speaker(s).

* with SSF, you can adjust how far the region of interest extends
  beyond the speaker area.  The defaults are values computed by Franz
  Zotter.

Some further details...the grid plots show the directional fidelity
of the decoder.  A perfect decoder would have evenly-spaced horizontal
and vertical lines.  The velocity localization vector (rV) is for low
frequencies (< ~800Hz), the energy localization vector (rE) is for mid
and high frequencies (> ~1200 Hz).  If the lines pull together around
the loudspeakers, that shows a "speaker detent" effect, which is often
due to using an ambisonic order higher than the array will support.
The 2x3 array of plots show the same vectors but both magnitude and
direction.  The lefthand column shows the magnitude of the vector,
which indicated the quality or compactness of the phantom images in a
particular direction.  The middle column shows angular error;
basically the same information and the grid plots, and the righthand
column shows the Pressure and Energy gains, which correspond to
perceived loudness at low and mid/high frequencies.






---
**Q) Is it possible to create a decoder that takes N3D or SN3D input?**

A) The toolbox defaults to Furse-Malham (aka FuMa) order and
normalization for 3rd-order or less, and AmbiX (ACN/SN3D) for 4th and
above.  To make other combinations, pass a full channel struct as the
`order` argument to the `ambi_run*` function, for example, a channel
struct for 4th-order horizontal, 3rd-order vertical, 'HP' mixed-order,
ACN channel order and N3D normalization can be specified as:

    C = ambi_channel_definitions(4, 3, 'HP', 'ACN', 'N3D');  % <--- new thing 

load a speaker array...

    S = SPKR_ARRAY_CCRMA_LISTENING_ROOM('dome');  % <-- or however you define the speaker array

then make a decoder ...

    ambi_run_*(S, C, ...)


The last three arguments for `ambi_channel_definitions()` are:

    % mixed_order_scheme = 'amb'|'hp'|'hv'|'travis'
    % orderingRule       = 'amb'|'fuma'|'sid'|'daniel'|'mpeg'|'acn'|'ambix'
    % encodingConvention = 'amb'|'fuma'|'sn3d'|'n3d'|'sn2d'|'n2d'|'ambix'|'icst'|'courville'|'ambix2009'

Some of these are synonyms, like amb and fuma, sid and daniel


There is also a function, `ambi_channel_definitions_convention()`, that
has the names of the format conventions I'm aware of (and a few I made
up).

    C = ambi_channel_definitions_convention(ambi_order, 'ambix')

Please refer to the source code files for further information and
references.


---

**Q) I'm using the AmbiX plugins, how do I create a dual band decoder
(rV/rE) and set the cross over frequency?**

A) The Ambix plugins do not support dual-band decoding (or NFC), just
a single decoder matrix.  The IEM folks do everything single band and
without NFC.  All the config files I generate for the AmbiX plugins
are $$rE_max$$.

For dual-band encoding you can use Ambdec or the decoders the ADT
creates in Faust.  Ambdec is limited to third order and the Faust ones
are limited to fifth order currently.  If there is a need, I could
extend the Faust implementation, which is simply a matter of adding
higher-order NFC filters.

Currently, the ADT is hardcoded to make 2-band decoders for 'pinv' and
1-band for 'allrad' and 'ssf'.  I did that because at the time, no one
had tried making 2-band encoders with those design techniques and
didn't want to enable that until I had a chance to audition them.  We
did do that year at CCRMA, but I haven't updated the code yet.

Exposing the 1 or 2 band option for all the design techniques and the
default crossover frequency is on my to do list. I've been putting it
off because I feel the argument lists to those functions are getting
unwieldy.

If you're willing to edit some MATLAB code, look in 

    ambi_run_allrad.m and ambi_run_SSF.m

and change 

    D.decoder_type = 1;
to 

    D.decoder_type = 2;

As for the crossover frequency...

In Ambdec presets, you can edit the .ambdec presets produced or edit `write_ambdec_config.m`:

    D.delay_comp  = 'on';        % on off
    D.level_comp  = 'on';        % on off
    D.xover_freq  = 400;         % in Hz
    D.xover_ratio = 0.0;         % in dB (!)

For the ADT/Faust decoders, it defaults to 400 Hz, but the plugin
created will have a slider letting you adjust it between 200 and 800
Hz in 20 Hz increments.  You can also edit the Faust source (`.dsp`)
file)

    // crossover frequency in Hz
    xover_freq = hslider("xover [unit:Hz]",400,200,800,20): dezipper;

Or the MATLAB file that creates the DSP file, `write_faust_config.m`

    fprintf(fid, ...
        ['\n// crossover frequency in Hz\n'...
        'xover_freq = hslider(\"xover [unit:Hz]\",400,200,800,20)'...
        ': dezipper;\n'] ...
        );

---

**Q) How do I make a format adapter plugin?**

A) Use the function `write_faust_adapter()`, with channel stucts for
the desired input and output format, for example

    C_in = ambi_channel_definitions(3,3,'HV','FuMa','FuMa')
    C_out = ambi_channel_definitions(3,3,'HV','ACN','SN3D')
    write_faust_adapter(C_in, C_out, 'fuma2ambix3.dsp', 'fuma2ambix3')

---
**Q) I get the follwing error when running the ADT.  What does it mean?**

    Error using mkdir
    Permission denied

    Error in ambi_decoders_dir (line 10)
        mkdir(outdir);

    Error in ambi_plot_dir_error_grid (line 74)
       fullfile(ambi_decoders_dir(true), ...

    Error in ambi_plot_rE (line 102)
       ambi_plot_dir_error_grid([], rE, geo, S, V, 'rE', fig_title, fig_title_sanitized);

    Error in ambi_run_allrad (line 135)
       ambi_plot_rE(S, V, ambi_apply_gamma(M_mm, Gamma, C), C, name);

    Error in run_dec_interactive (line 58)
       D = ambi_run_allrad(...

A) The ADT tries to make a directory to hold the decoders, plots, and
other files.  By default, it is called 'decoders' and will be created
in the directory above where you are invoking `run_dec_*`.  The error is
because you don't have permission to create a directory there.  You
can change decoders directory by editing `ambi_decoders_dir.m`

---
**Q) How do you I make an offline command line version of one of the
decoders in Faust that the ADT produces?**

A) Instructions for creating offline processing programs from Faust dsp
files can be found at

   <https://ccrma.stanford.edu/~jos/aspf/Offline_Processing_Soundfiles_FAUST.html>
