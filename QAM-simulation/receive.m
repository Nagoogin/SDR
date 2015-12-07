function [bin] = receive(msg, n)
    fs = 100; % sampling frequency
    fb = 2; % Baud frequency
    fc = 10; % carrier frequency
    dt = 1/fs; % delta t
    Tb = 1/fb; % Baud period
    Nb = Tb/dt; 
    l = length(msg);
    t = (-l/(2*fs)):dt:(l/(2*fs))-dt;
    prx = NaN(1,length(t));
    
    for j = 1:length(t)
        prx(j) = sinc((2*t(j))/Tb)*exp(1i*2*pi*fc*t(j));
    end
    
    figure(1)
    plot3(t, real(prx), imag(prx));
    
    dec = conv(msg, prx, 'same');
    
    figure(2)
    plot3(t, real(dec), imag(dec));
    
    maxi = NaN(1,n);
    received = NaN(1,n);
    bin = NaN(1,n);
    
    for k = 1:n
        maxi(k) = dec(Nb*(k+2));
        received(k) = round((2/pi) * imag(log(maxi(k))) + 3/2);
    end
    
    for m = 1:n
        if received(m) == 3
            bin(m) = 1;
        elseif received(m) == 2
            bin(m) = 3;
        elseif received(m) == 1
            bin(m) = 2;
        else
            bin(m) = 0;
        end
                
    end
    
    figure(3)
    plot(maxi, 'o');
    
    disp(received);
    
end