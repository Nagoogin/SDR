function [sym] = send(l)
    fs = 100;   % sampling frequency
    fb = 2;     % Baud rate
    fc = 10;    % carrier frequency
    
    Tb = 1/fb;  % Baud interval
    dt = 1/fs;  % delta t
    Nb = Tb/dt;                 % steps per Baud interval
    t = -l*Tb:dt:l*Tb;          % time interval array
    x = zeros(1,length(t));     % delta function array
    ptx = NaN(1, length(t));    % transmit filter array
    sym = NaN(1,l);             % symbols array
    
    
    for n = 1:l % assigns values to symbols array and delta function array
        sym(n) = randi([0,3]);
    end
    
    for n = 1:l; %add this possibly? %change the names of these
        if sym(n) == 0
            x(3 * Nb + (n - 1) * Nb) = exp(1i * (-3 * pi)/4);
        elseif sym(n) == 1
            x(3 * Nb + (n - 1) * Nb) = exp(1i * ( -pi )/4);
        elseif sym(n) == 2
            x(3 * Nb + (n - 1) * Nb) = exp(1i * ( pi )/4);
        elseif sym(n) == 3
            x(3 * Nb + (n - 1) * Nb) = exp(1i * (3 * pi)/4);
        end
    end
        % x(Nb*(n+2)) = exp(1i*(pi/2)*(sym(n) - (3/2)));
    
    for m = 1:length(t)
        ptx(m) = sinc((2*t(m))/Tb)*exp(1i*2*pi*fc*t(m));
    end
    
    msg = conv(x, ptx, 'same'); % convolution of the transmit 
                                % filter and complex symbols
                                
    figure(1)
    plot3(t, real(ptx), imag(ptx))
    
    figure(2)
    plot3(t, real(msg), imag(msg))
    
    save('sig', 'msg');
    
    disp(x);
    disp(length(x));
    disp(length(ptx));
    
end