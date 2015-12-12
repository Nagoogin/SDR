function [symbols] = decodeSignal(file)
    data = real(abs(read_complex_binary(file)));
    chunk = data(1.35e5:3.3e5);
    % takes the portion of the signal following
    % the initial handshake
    N = length(chunk);
    ndata = NaN(1, N);
    cutoff = max(chunk)/2;

    % clean the signal
    for n = 1:N
        if chunk(n) > cutoff
            ndata(n) = 1;
        else
            ndata(n) = 0;
        end
    end

    plot(ndata);
    rise = NaN(1, 66);
    fall = NaN(1, 66);

    x = 1;
    y = 1;

    % gets the rise and fall indexes within the chunk array
    for n = 1:N-1
        if ndata(n) == 0 && ndata(n+1) == 1
            rise(x) = n;
            x = x + 1;
        end
        if ndata(n) == 1 && ndata(n+1) == 0
            fall(y) = n;
            y = y + 1;
        end
    end

    % disp(rise);
    % disp(length(rise));

    diff = NaN(1, length(rise));

    for n = 1:length(rise)
        diff(n) = fall(n) - rise(n);
    end

    symbols = NaN(1, length(diff));
    avg = mean(diff);

    for n = 1:length(diff)
        if diff(n) > avg
            symbols(n) = 0;
        else
            symbols(n) = 1;
        end
    end
end