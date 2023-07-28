clc;
clear;
clear all;

Fs=24000;
Rb=12000;

N=1000; 
A=1;
Ts=1/Fs; 
Tb=1/Rb; 

m = randi(4,1,N); 

for i = 1:N
   if(m(i) == 1)
       m(i) = -3*A;
   elseif (m(i) == 2)
       m(i) = -1*A;
   elseif (m(i) == 3)
       m(i) = 1*A;
   else
       m(i) = 3*A;
   end
end


figure(1);
plot(m);
title('4-ary PAM Signal');

sps=Fs/Rb*2; 
Rs=Rb/2; 


rolloff=[0 0.5 1]; 
span=10; 

rcos1 = rcosdesign(rolloff(1),span,sps,'sqrt');
rcos2 = rcosdesign(rolloff(2),span,sps,'sqrt');
rcos3 = rcosdesign(rolloff(3),span,sps,'sqrt');

frec_vector=linspace(-Fs/2,Fs/2,N);

RCOS1 = abs(fftshift(fft(rcos1, N)))/N;
RCOS2 = abs(fftshift(fft(rcos2, N)))/N;
RCOS3 = abs(fftshift(fft(rcos3, N)))/N;


figure(2);
subplot(231);
plot(rcos1);
title('Square-Root Raised Cosine with roll-off=0');
xlabel('time (s)');
ylabel('Amplitude');

subplot(232);
plot(rcos2);
title('Square-Root Raised Cosine with roll-off=0.5');
xlabel('frequency (in Hz)');
ylabel('Amplitude');

subplot(233);
plot(rcos3);
title('Square-Root Raised Cosine with roll-off=1');
xlabel('frequency (in Hz)');
ylabel('Amplitude');

subplot(234);
plot(frec_vector, RCOS1);
title('Frec Spectrum Square Root Raised Cosine with roll-off=0');
xlabel('frequency (in Hz)');
ylabel('Amplitude');

subplot(235);
plot(frec_vector, RCOS2);
title('Frec Spectrum Square Root Raised Cosine with roll-off=0.5');
xlabel('frequency (in Hz)');
ylabel('Amplitude');

subplot(236);
plot(frec_vector, RCOS3);
title('Frec Spectrum Square Root Raised Cosine with roll-off=1');
xlabel('frequency (in Hz)');
ylabel('Amplitude');



trans1 = upfirdn(m, rcos1, sps, 1);
trans2 = upfirdn(m, rcos2, sps, 1);
trans3 = upfirdn(m, rcos3, sps, 1);

channel= [1 0.8 -0.2]; 
a=1

filtered1=filter(channel,a,trans1);
filtered2=filter(channel,a,trans2);
filtered3=filter(channel,a,trans3);



SNR = 20; 
trans_noise1 = awgn(filtered1, SNR);
trans_noise2 = awgn(filtered2, SNR);
trans_noise3 = awgn(filtered3, SNR);


y1 = upfirdn(trans_noise1, rcos1, 1, sps);
y2 = upfirdn(trans_noise2, rcos2, 1, sps);
y3 = upfirdn(trans_noise3, rcos3, 1, sps);


yout1 = y1(span:(end-span));
yout2 = y2(span:(end-span));
yout3 = y3(span:(end-span));



eyediagram(yout1,sps,1/Fs,0);
title('Eye Diagram Rolloff = 0');
eyediagram(yout2,sps,1/Fs,0);
title('Eye Diagram Rolloff = 0.5');
eyediagram(yout3,sps,Ts,0);
title('Eye Diagram Rolloff = 1');