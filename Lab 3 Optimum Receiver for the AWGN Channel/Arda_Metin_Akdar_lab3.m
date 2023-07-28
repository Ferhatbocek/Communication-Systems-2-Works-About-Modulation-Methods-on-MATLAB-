clc;
clear all;
close all;

%% a,b,c
Tb = 0.1; 
Fs = 2e3; 
Ts = 1/Fs;  
N=5;

t = 0:Ts:0.5-Ts; 
Tb = 0.1;
t_n = 0:Ts:Tb-Ts;


s0 = [ones([1,49]), zeros([1,50]), ones([1,50]), zeros([1,51])];
s1 = [ones([1,99]), -ones([1,101])];


for i=1:200
t1(i) = t(i);
end

figure
subplot(211)
plot(t1,s0);
legend('s_{0}(t)')
xlabel('Time(s)')
ylabel('amplitude')
subplot(212)
plot(t1,s1);
legend('s_{1}(t)')
xlabel('Time(s)')
ylabel('amplitude')
%% d
b = [0,1,1,0,1];

s = [s0,s1,s1,s0,s1];
figure
plot(t,s)
legend('s(t)')
xlabel('Time(s)')
ylabel('amplitude')
%% e

P = sum(abs(s.^2))/length(s)

%% f g h i
SNR_dBi = [20,-5];

for i=1:2
SNR_lin(i) = 10 ^( 0.1 * SNR_dBi(i));
var(i) = P / SNR_lin(i);
end

n_1 = sqrt(var(1)) .* randn(1,length(s));
r_1 = s + n_1;

n_2 = sqrt(var(2)) .* randn(1,length(s));
r_2 = s + n_2;

%% j

Wb = Tb/Ts;
temp = 0;
temp1 = 0;
for k=1:N
    for n = (k-1) * Wb + 1 : k * Wb
        temp = temp + r_1(n) * s0((n -(k-1) * Wb));
        temp1 = temp1 + r_1(n) * s1((n -(k-1) * Wb));
    end
        r_0_1(k) = temp;
        r_1_1(k) = temp1;
        temp1 = 0;
        temp = 0;
end

for k=1:N
    for n = (k-1) * Wb + 1 : k * Wb
        temp = temp + r_2(n) * s0((n -(k-1) * Wb));
        temp1 = temp1 + r_2(n) * s1((n -(k-1) * Wb));
    end
        r_0_2(k) = temp;
        r_1_2(k) = temp1;
        temp1 = 0;
        temp = 0;
end

figure
scatter(1:N,r_0_1);
hold on;
scatter(1:N,r_1_1);
title('SNR = 20')
legend('zeros','ones');

figure
scatter(1:N,r_0_2);
hold on;
scatter(1:N,r_1_2);
title('SNR = -5')
legend('zeros','ones');
