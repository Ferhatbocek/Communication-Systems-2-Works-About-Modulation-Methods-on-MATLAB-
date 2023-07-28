clc;
clear all;
close all;

%% Part 1
Fs = 24e3;
Rb = 12e3;
M = 4;

messagelength = 1000; M=4;

randomnumbers = randi([0,(M-1)],1,messagelength);
%modulated_signal = pammod(randomnumbers,M);

%% Part 2
for i = 1:length(randomnumbers)
    if randomnumbers(i) == 0
        pam(i) = -3;
    elseif randomnumbers(i) == 1
        pam(i) = -1;
    elseif randomnumbers(i) == 2
        pam(i) = 1;
    else 
        pam(i) = 3;
    end
end

%% Part 3

Rs = Rb/2;
sps = Fs/Rs;

%% Part 4

rolloff1 = 0;
rolloff2 = 0.5;
rolloff3 = 1;
span = 10;

h0=rcosdesign(rolloff1,span,sps,'sqrt');
h1=rcosdesign(rolloff2,span,sps,'sqrt');
h2=rcosdesign(rolloff3,span,sps,'sqrt');

%% Part 5

% figure;

H0 = abs(fftshift((fft(h0,length(h0)))/length(h0)));
H1 = abs(fftshift((fft(h1,length(h1)))/length(h1)));
H2 = abs(fftshift((fft(h2,length(h2)))/length(h2)));

f=linspace(-Fs/2,Fs/2,length(h0));

figure;
subplot(2,3,1)
plot(h0); title('time domain for roll-off=0'); xlabel('t'); ylabel('magnitude');
subplot(2,3,2)
plot(h1); title('time domain for roll-off=0.5'); xlabel('t'); ylabel('magnitude');
subplot(2,3,3)
plot(h2); title('time domain for roll-off=1'); xlabel('t'); ylabel('magnitude');

subplot(2,3,4)
plot(f,(H0)); title('frequency domain'); xlabel('f'); ylabel('magnitude');
subplot(2,3,5)
plot(f,(H1)); title('frequency domain'); xlabel('f'); ylabel('magnitude');
subplot(2,3,6)
plot(f,(H2)); title('frequency domain'); xlabel('f'); ylabel('magnitude');

%% Part 6

y0transmitted = upfirdn(pam,h0,sps,1);
y1transmitted = upfirdn(pam,h1,sps,1);
y2transmitted = upfirdn(pam,h2,sps,1);

%% Part 7 

b = [1 0.8 -0.2];
a = [1 0 0];

%% Part 8
y0transmitted = filter(b,a,y0transmitted);
y1transmitted = filter(b,a,y1transmitted);
y2transmitted = filter(b,a,y2transmitted);

%% Part 9
y0received = awgn(y0transmitted,20);
y1received = awgn(y1transmitted,20);
y2received = awgn(y2transmitted,20);

%% Part 10

yout0 = upfirdn(y0received,h0,1,sps);
yout1 = upfirdn(y1received,h1,1,sps);
yout2 = upfirdn(y2received,h2,1,sps);

%% Part 11
yout0 = yout0(6+1:end-6);
yout1 = yout1(6+1:end-6);
yout2 = yout2(6+1:end-6);

%% Part 12
eyediagram(yout0,sps,1/Fs,0); title('roll-off=0');
eyediagram(yout1,sps,1/Fs,0); title('roll-off=0.5');
eyediagram(yout2,sps,1/Fs,0); title('roll-off=1');