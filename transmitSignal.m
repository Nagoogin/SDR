function transmitSignal(file, savefile)
    data = real(abs(read_complex_binary(file)));
    N = length(data);
    ndata = NaN(1,N);
    cutoff = max(data)/2;
    
    fs = 5e6; % sample rate
    M = 1:length(data);
    t = M./fs; % time
    fc = 320e3; % carrier/sampling frequency
    carrier = NaN(1,length(t));
    
    % cleans up the signal
    for n = 1:length(data)
        if data(n) > cutoff
            ndata(n) = 1;
        else
            ndata(n) = 0;
        end
    end

    for n = 1:length(t)
        carrier(n) = exp((1i)*2*pi*fc*t(n));
    end

    trans = ndata.*carrier;
    
    figure(1)
    plot(real(trans));
    
    write_complex_binary(trans, savefile);
end