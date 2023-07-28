clc;
clear all;
clear vars;

Fs = 2000;
Ts = 1/Fs;
t = 0:Ts:0.04-Ts;
mt = 5*sin(2*pi*50*t);


% DM Modulator
mt_drv=5*(2*pi*50)*cos(2*50*pi*t);
delta=max(mt_drv)*Ts

mstr=0

for i=1:length(mt)-1
    if mstr(i)<=mt(i)
        enc(i)=1;
        mstr(i+1)=mstr(i)+delta;
    else
        enc(i)=0;
        mstr(i+1)=mstr(i)-delta;
    end
end

figure(1)
plot(mt)
hold on
stairs(mstr);
hold on
title('Staircase approximation with min stepsize');


%For delta1=1.5708
delta1=1.5708;
mstr1=0;

for i=1:length(mt)-1
    if mstr1(i)<=mt(i)
        enc(i)=1;
        mstr1(i+1)=mstr1(i)+delta1;
    else
        enc(i)=0;
        mstr1(i+1)=mstr1(i)-delta1;
    end
end

figure(2)
plot(mt)
hold on
stairs(mstr1);
hold off
title('Staircase approximation with stepsize');

%For delta2=0.3927
delta2=0.3927;
mstr2=0;
for i=1:length(mt)-1
  if mstr2(i)<=mt(i)
    enc(i)=1;
    mstr2(i+1)=mstr2(i)+delta2;
  else
    enc(i)=0;
    mstr2(i+1)=mstr2(i)-delta2;
  end
end

figure(3)
plot(mt)
hold on
stairs(mstr2);
hold off
title('Staircase approximation with 0stepsize')

cf=0.1;
n=100;
b=fir1(n,cf);
out1=conv2(mstr1,b,'same');
out2=conv2(mstr2,b,'same');


figure;
subplot(2,1,1);
plot(t,mt); hold on;
plot(t,mstr1); hold off; legend('m(t)','demodulator output');
xlabel('t'); ylabel('amplitude'); title('for delta=1');

figure 
subplot(2,1,2)
plot(t,mt); hold on;
plot(t,out1); hold off; legend('m(t)','LPF output')
xlabel('t'); ylabel('amplitude');



figure;
subplot(2,1,1);
plot(t,mt); hold on;
plot(t,mstr2); hold off; legend('m(t)','demodulator output');
xlabel('t'); ylabel('amplitude'); title('for delta2');

subplot(2,1,2)
plot(t,mt); hold on;
plot(t,out2); hold off; legend('m(t)','LPF output')
xlabel('t'); ylabel('amplitude');







