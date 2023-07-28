clc;
clear all;
close all;

Fs=20000;
b = [1 0 1 1 0];
t = 0:1/Fs:5*(1/Fs); 
m = zeros(1,length(t)); % initialize message signal as a row vector of zeros
for i = 1:length(b)
if b(i) == 1
m(1+(i-1)*10:10+(i-1)*10) = 1; % assign value of 1 to message signal for duration of 10 samples
end
end
m = reshape(repmat(b,10,1),1,[]) * 1;
fc=2000;
t = 0:1/Fs:5*(1/Fs); % generate time vector for 5 samples
s = zeros(1,length(t)); % initialize BASK signal as a row vector of zeros
for i = 1:length(b)
if b(i) == 1
s = s + 5*cos(2*pi*fc*t(1+(i-1)*10:10+(i-1)*10)); % add 5V cosine wave to BASK signal for duration of 10 samples
end
end

noise = randn(1,length(s))*sqrt(0.25); % generate noise vector with mean of 0 and variance of 0.25
r = s + noise; % received signal with awgn noise

ref = cos(2*pi*fc*t); % generate reference cosine wave at carrier frequency
[corr,lags] = xcorr(r,ref,0); % compute correlation between noisy BASK signal and reference cosine wave
demod = zeros(1,length(b)); % initialize demodulated signal as a row vector of zeros
Ith = 0.5;





for i = 1:length(b)
if corr(i) > Ith 
demod(i) = 1; 
else 
demod(i) = 0; 
end
end


subplot(4,1,1); 
plot(t,m);
xlabel('Time (s)'); 
ylabel('Amplitude'); 
title('Message Signal'); 

subplot(4,1,2); 
plot(t,s); 
xlabel('Time (s)'); 
ylabel('Amplitude'); 
title('BASK Signal'); 

subplot(4,1,3); 
plot(t,r); 
xlabel('Time (s)'); 
ylabel('Amplitude'); 
title('Noisy BASK Signal'); 

subplot(4,1,4); 
plot(t(1:10:end),demod); 
xlabel('Time (s)'); 
ylabel('Amplitude'); 
title('Demodulated Signal'); 







