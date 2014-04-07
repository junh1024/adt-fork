function [ out ] = nfc_init( Fs, o, rd1, rd2, g )
    %UNTITLED2 Summary of this function goes here
    %   Detailed explanation goes here
    
    % rd1 is radius forward (encoding)
    % rd2 is radius inverse (decoding)
    
    c = 340.29;
    %Fs = 48000;
    
    w1 = 0;
    w2 = c / (rd2 * Fs);
    
    switch o
        case 1
            roots = [1];
            [x1_d1,g2] = nfc_coeffs1(w2,roots);
            g = g / g2;
            out = [g, x1_d1];
            
        case 2
            roots = [ 3.0, 3.0 ];
            [x2_d1,x2_d2,g2] = nfc_coeffs2(w2,roots);
            g = g / g2;
            
            out = [g, x2_d1,x2_d2];
        case 3
            roots = [3.6778,6.4595];
            [x3_d1,x3_d2,g2] = nfc_coeffs2(w2,roots);
            g = g / g2;
            
            roots = [2.3222];
            [x3_d3,g1] = nfc_coeffs1(w2, roots);
            g = g / g1;
            
            x3_g = g;
            
            out = [x3_g, x3_d1,x3_d2,x3_d3] ; %x3_d4,x3_d5,x3_g};
            
        case 4
            %roots = [4.2076,11.4877];
            roots = [ 4.207578794359250  11.487800476871168];
            [x4_d1,x4_d2,g2] = nfc_coeffs2(w2, roots );
            g = g / g2;
            
            %roots = [5.7924, 9.1401];
            roots = [ 5.792421205640748   9.140130890277934];
            [x4_d3,x4_d4,g2] = nfc_coeffs2(w2, roots );
            g = g / g2;
            
            x4_g = g;
            
            out = [x4_g, x4_d1,x4_d2,x4_d3,x4_d4] ; %x3_d4,x3_d5,x3_g};
        case 5 %% FIXME FIXME
            %roots = [4.2076,11.4877];
            %roots = [ 4.207578794359250  11.487800476871168];
            
            roots = [4.649348606363304, 18.156315313452325, ...
                     6.703912798306966  14.272480513279568, ...
                     3.646738595329718];
            [x5_d1,x5_d2,g2] = nfc_coeffs2(w2, roots(1:2) );
            g = g / g2;
            
            %roots = [5.7924, 9.1401];
            %roots = [ 5.792421205640748   9.140130890277934];
            [x5_d3,x5_d4,g2] = nfc_coeffs2(w2, roots(3:4) );
            g = g / g2;
            
            [x5_d5,g1] = nfc_coeffs1(w2, roots(5));
            
            x5_g = g;
            
            out = [x5_g, x5_d1,x5_d2,x5_d3,x5_d4,x5_d5] ;
    end
    
end

function [d1,g1]    = nfc_coeffs1(w2, roots)
    r1 = 0.5 * w2;
    
    b1 = roots(1) * r1;
    g1 = 1 + b1;
    d1 = (2 * b1) / g1;
    %g = g / g1;
end

function [d1,d2,g2] = nfc_coeffs2(w2, roots)
    
    r1 = 0.5 * w2;
    r2 = r1 * r1;
    
    b1 = roots(1) * r1;
    b2 = roots(2) * r2;
    g2 = 1 + b1 + b2;
    d1 = (2 * b1 + 4 * b2) / g2;
    d2 = (4 * b2) / g2;
    %g = g / g2;
end

% w = c / (r * Fs);
%{
void NF_filt3::init (float w1, float w2, float g)
{
    float r1, r2, b1, b2, g1, g2;

    r1 = 0.5f * w1;
    r2 = r1 * r1;
    b1 = 3.6778f * r1;
    b2 = 6.4595f * r2;
    g2 = 1 + b1 + b2;
    _c1 = (2 * b1 + 4 * b2) / g2;
    _c2 = (4 * b2) / g2;
    g *= g2;
    b1 = 2.3222f * r1;
    g1 = 1 + b1;
    _c3 = (2 * b1) / g1;
    g *= g1;

    r1 = 0.5f * w2;
    r2 = r1 * r1;
    b1 = 3.6778f * r1;
    b2 = 6.4595f * r2;
    g2 = 1 + b1 + b2;
    _d1 = (2 * b1 + 4 * b2) / g2;
    _d2 = (4 * b2) / g2;
    g /= g2;
    b1 = 2.3222f * r1;
    g1 = 1 + b1;
    _d3 = (2 * b1) / g1;
    g /= g1;

    _g = g;
}

void NF_filt4::init (float w1, float w2, float g)
{
    float r1, r2, b1, b2, g2;

    r1 = 0.5f * w1;
    r2 = r1 * r1;
    b1 =  4.2076f * r1;
    b2 = 11.4877f * r2;
    g2 = 1 + b1 + b2;
    _c1 = (2 * b1 + 4 * b2) / g2;
    _c2 = (4 * b2) / g2;
    g *= g2;
    b1 = 5.7924f * r1;
    b2 = 9.1401f * r2;
    g2 = 1 + b1 + b2;
    _c3 = (2 * b1 + 4 * b2) / g2;
    _c4 = (4 * b2) / g2;
    g *= g2;

    r1 = 0.5f * w2;
    r2 = r1 * r1;
    b1 =  4.2076f * r1;
    b2 = 11.4877f * r2;
    g2 = 1 + b1 + b2;
    _d1 = (2 * b1 + 4 * b2) / g2;
    _d2 = (4 * b2) / g2;
    g /= g2;
    b1 = 5.7924f * r1;
    b2 = 9.1401f * r2;
    g2 = 1 + b1 + b2;
    _d3 = (2 * b1 + 4 * b2) / g2;
    _d4 = (4 * b2) / g2;
    g /= g2;

    _g = g;
%}
