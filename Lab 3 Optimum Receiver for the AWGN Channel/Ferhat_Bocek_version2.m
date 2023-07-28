clc;
close all;
clear all;
A = 1; 
Tb = 0.1; 
fs = 2000; 
Ts = 1/fs; 
N=5;
t = 0:(1/fs):0.5-1/fs;
t2 = 0:(1/fs):Tb-1/fs;

for i = 1:50
    s0(i) = 1;
    s1(i) = 1;
end

for i = 50:100
    s0(i) = 0;
    s1(i) = 1;
end

for i = 100:150
    s0(i) = 1;
    s1(i) = -1;
end

for i = 150:200
    s0(i) = 0;
    s1(i) = -1;
end

figure(1);
subplot(2,1,1);
plot(t2,s0);
xlabel("Time");
ylabel("Amplitude");
legend("s0(t)");
subplot(2,1,2);
plot(t2,s1);
xlabel("Time");
ylabel("Amplitude");
legend("s1(t)");

b = [0,1,1,0,1];
s = [];
for i = 1:N
    if b(i) == 0
        s = [s s0];
    else
        s = [s s1];
    end
end

figure(2);
plot(s);
xlabel("Time(s)");
ylabel("Amplitude");
legend("s(t)");

Ps = sum(abs(s.*s))/length(s);

SNRlin1 = 10 .^ (0.1 * 20);
SNRlin2 = 10 .^ (0.1 * -5);

var1 = Ps/SNRlin1;
var2 = Ps/SNRlin2;

n1 = sqrt(var1)*randn(1,length(s));
n2 = sqrt(var2)*randn(1,length(s));

for i = 1:1000
    r_1(i) = s(i) + n1(i);
    r_2(i) = s(i) + n2(i);
end

figure(3);
plot(t,r_1);
xlabel("Time");
ylabel("Amplitude");
legend("r(t) for 20dB SNR");

Wb = Tb/Ts;
sumr1_1 = 0;
sumr1_2 = 0;
sumr2_1 = 0;
sumr2_2 = 0;
r1_0 = [];
r1_1 = [];
r2_0 = [];
r2_1 = [];

for k = 1:N
    for n = ((k-1)*Wb)+1:k*Wb
        sumr1_1 = sumr1_1 + r_1(n).*(s0((n-(k-1)*Wb)));
        sumr1_2 = sumr1_2 + r_1(n).*(s1((n-(k-1)*Wb)));
        sumr2_1 = sumr2_1 + r_2(n).*(s0((n-(k-1)*Wb)));
        sumr2_2 = sumr2_2 + r_2(n).*(s1((n-(k-1)*Wb)));
    end   
    r1_0(k) = sumr1_1;
    r1_1(k) = sumr1_2;
    r2_0(k) = sumr2_1;
    r2_1(k) = sumr2_2;
    sumr1_1 = 0;
    sumr1_2 = 0;
    sumr2_1 = 0;
    sumr2_2 = 0;
end

x= [1 2 3 4 5];
figure(4);
scatter(x,r1_0);
hold on;
scatter(x,r1_1);
xlabel("k values");
ylabel("Amplitude");
legend("r0[k] for 20dB SNR", "r1[k] for 20dB SNR");

figure(5);
plot(t,r_2);
xlabel("Time");
ylabel("Amplitude");
legend("r(t) for -5dB SNR");

figure(6);
scatter(x,r2_0);
hold on;
scatter(x,r2_1);
xlabel("k values");
ylabel("Amplitude");
legend("r0[k] for -5dB SNR", "r1[k] for -5dB SNR");
        


