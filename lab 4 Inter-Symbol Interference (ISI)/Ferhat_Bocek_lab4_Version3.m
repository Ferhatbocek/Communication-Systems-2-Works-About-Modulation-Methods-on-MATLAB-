clc;
clear all;
close all;

Fs = 24000;
Rb = 12000;
M = 4;

mlength = 1000;

randomnb= randi([0,(M-1)],1,mlength);



for i = 1:length(randomnb)
    if randomnb(i) == 0
        pam(i) = -3;
    elseif randomnb(i) == 1
        pam(i) = -1;
    elseif randomnb(i) == 2
        pam(i) = 1;
    else 
        pam(i) = 3;
    end
end

%% Part 3

Rs = Rb/2;
sps = Fs/Rs;

%% Part 4

rllof1 = 0;
rllof2 = 0.5;
rllof3 = 1;
span = 10;

h0=rcosdesign(rllof1,span,sps,'sqrt');
h1=rcosdesign(rllof2,span,sps,'sqrt');
h2=rcosdesign(rllof3,span,sps,'sqrt');

%% Part 5

% figure;

H0 = abs(fftshift((fft(h0,length(h0)))/length(h0)));
H1 = abs(fftshift((fft(h1,length(h1)))/length(h1)));
H2 = abs(fftshift((fft(h2,length(h2)))/length(h2)));

f=linspace(-Fs/2,Fs/2,length(h0));

figure;
subplot(2,3,1)
plot(h0); title('time domain for roll-off=0'); 
xlabel('t'); ylabel('magnitude');
subplot(2,3,2)
plot(h1); 
title('time domain for roll-off=0.5'); 
xlabel('t'); 
ylabel('magnitude');
subplot(2,3,3)
plot(h2); 
title('time domain for roll-off=1'); 
xlabel('t'); 
ylabel('magnitude');

subplot(2,3,4)
plot(f,(H0)); 
title('frequency domain'); 
xlabel('f'); ylabel('magnitude');
subplot(2,3,5)
plot(f,(H1)); 
title('frequency domain'); 
xlabel('f'); 
ylabel('magnitude');
subplot(2,3,6)
plot(f,(H2)); 
title('frequency domain'); 
xlabel('f'); 
ylabel('magnitude');

%% Part 6

y0trns = upfirdn(pam,h0,sps,1);
y1trns = upfirdn(pam,h1,sps,1);
y2trns = upfirdn(pam,h2,sps,1);

%% Part 7 

b = [1 0.8 -0.2];
a = [1 0 0];

%% Part 8
y0trns = filter(b,a,y0trns);
y1trns = filter(b,a,y1trns);
y2trns = filter(b,a,y2trns);

%% Part 9
y0rcv = awgn(y0trns,20);
y1rcv = awgn(y1trns,20);
y2rcv = awgn(y2trns,20);

%% Part 10

yto0 = upfirdn(y0rcv,h0,1,sps);
yto1 = upfirdn(y1rcv,h1,1,sps);
yto2 = upfirdn(y2rcv,h2,1,sps);

%% Part 11
yto0 = yto0(6+1:end-6);
yto1 = yto1(6+1:end-6);
yto2 = yto2(6+1:end-6);

%% Part 12
eyediagram(yto0,sps,1/Fs,0); title('roll-off=0');
eyediagram(yto1,sps,1/Fs,0); title('roll-off=0.5');
eyediagram(yto2,sps,1/Fs,0); title('roll-off=1');