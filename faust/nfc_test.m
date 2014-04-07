clear all
close all
[nfcY,Fs] = audioread('nfc_coeffs_48k3.wav');

display(Fs/nfcY(1,1));
%%
nfc1c = nfc_init(Fs,1,0.0,2.0,1);
display(nfc1c(1));
display(nfc1c(2:end) ./ nfcY(1,2));

%%
nfc2c = nfc_init(Fs,2,0.0,2.0,1);
display(nfc2c(1));
display(nfc2c(2:end) ./ nfcY(1,3:4));

%%
nfc3c = nfc_init(Fs,3,0.0, 2.0, 1);
display(nfc3c(1));
display(nfc3c(2:end) ./ nfcY(1,5:7));

%%
nfc4c = nfc_init(Fs,4,0.0, 2.0, 1);
display(nfc4c(1));

display(nfc4c(2:end) ./ nfcY(1,8:11));

%%
nfc5c = nfc_init(Fs,5,0.0, 2.0, 1);
display(nfc5c(1));

display(nfc5c(2:end) ./ nfcY(1,12:16));

%%
in = zeros(Fs,1);
in(1) = 1;
%%
out = nfc_process(1, nfc1c(1),nfc1c(2:end), in);
%fft_plot(out,Fs,'foo')

fout1 = fft(out);
semilogx(1:(Fs/2), abs(fout1(1:Fs/2)));
hold

%%
out = nfc_process(2, nfc2c(1),nfc2c(2:end), in);
%fft_plot(out,Fs,'foo')

fout2 = fft(out);
semilogx(1:(Fs/2), abs(fout2(1:Fs/2)));

%%
out = nfc_process(3, nfc3c(1),nfc3c(2:end), in);
%fft_plot(out,Fs,'foo')

fout3 = fft(out);
semilogx(1:(Fs/2), abs(fout3(1:Fs/2)));

%%
out = nfc_process(4, nfc4c(1),nfc4c(2:end), in);
%fft_plot(out,Fs,'foo')

fout4 = fft(out);
semilogx(1:(Fs/2), abs(fout4(1:Fs/2)));


%%
out = nfc_process(5, nfc5c(1),nfc5c(2:end), in);
%fft_plot(out,Fs,'foo')

fout5 = fft(out);
semilogx(1:(Fs/2), abs(fout5(1:Fs/2)));
hold off

%%

close all;
clear all;

Fs_r = [44100,48000,96000,192000];
r  = 2.0;

for f = 1:4
    Fs = Fs_r(f);
    in = zeros(Fs,1);
    in(1) = 1;
    
    out = zeros(Fs,5);
    
    for o = 1:5
        nfc = nfc_init(Fs, o , 0.0, r, 1);
        out(:,o) = nfc_process(o, nfc(1), nfc(2:end), in);
    end
    
    fout = fft(out);
    
    figure(2)
    subplot(2,2,f)
    semilogx(1:(Fs/2), abs(fout(1:(Fs/2),:)), 'linewidth', 3);
    title(sprintf('Fs=%d Hz, r=%d meters', Fs, r), 'FontSize', 16);
    xlabel('Frequency (Hz)', 'FontSize', 14);
    ylabel('Gain', 'FontSize', 14);
    axis([1, 24000, 0, 1.1]);
    grid on
end

