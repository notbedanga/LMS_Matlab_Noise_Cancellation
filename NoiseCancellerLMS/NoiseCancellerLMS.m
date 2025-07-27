[clean, fs] = audioread('/Users/bedanga/Desktop/test.wav');
clean = clean(:,1);
clean = clean(1:200000);

noise = randn(size(clean));
b = [1, 0.8];
ref_noise = filter(b, 1, noise);

noisy = clean + ref_noise;

N = 32;
mu = 0.01;
w = zeros(N,1);
ref_buf = zeros(N,1);
L = length(clean);

y = zeros(L,1);
e = zeros(L,1);

for i = N:L
    ref_buf = ref_noise(i:-1:i-N+1);
    y(i) = w' * ref_buf;
    e(i) = noisy(i) - y(i);
    w = w + mu * ref_buf * e(i);
end

t = (0:L-1)/fs;
figure;
subplot(3,1,1); plot(t, noisy); title('Noisy Signal'); xlabel('Time (s)');
subplot(3,1,2); plot(t, e); title('Recovered Signal after LMS'); xlabel('Time (s)');
subplot(3,1,3); plot(t, clean); title('Original Clean Speech'); xlabel('Time (s)');

soundsc(noisy, fs);
pause(length(noisy)/fs + 1);
soundsc(e, fs);
pause(length(e)/fs + 1);
soundsc(clean, fs);
