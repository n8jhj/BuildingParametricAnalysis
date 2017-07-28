function nvec = noise(mag,len)
%NOISE Noise centered at 1.
%   nvec = noise(mag,len)
%   Returns a vector of length LEN containing random values ranging between
%   1+MAG and 1-MAG.

nvec = rand(len,1) * 2 * mag + (1-mag);

end
