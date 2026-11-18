clc; clear; close all;

% Data
y = [22.2, 22.7, 32.2, 44.4, 54.8, 64.3, ...
     68.8, 67.1, 60.2, 49.5, 39.3, 27.4];

% Harmonic Analysis
n = length(y);
t = 1:n;
k = 1:floor(n/2);

A = zeros(size(k));
B = zeros(size(k));

for i = k
    A(i) = (2/n)*sum(y.*cos(2*pi*i*t/n));
    B(i) = (2/n)*sum(y.*sin(2*pi*i*t/n));
end

% Nyquist frequency
if mod(n,2) == 0
    A(end) = A(end)/2;
    B(end) = 0;
end

% Amplitude and period
C = sqrt(A.^2 + B.^2);
tau = n./k;

% Results
Results = table(k',tau',A',B',C', ...
    'VariableNames', {'k','Period','A','B','C'});

disp(Results)

% Harmonic plots (k = 1,...,6)

phi = atan2(B,A);

figure;

for i = 1:min(6,length(k))

    theta = 2*pi*i*t/n;

    % Left: normalized harmonic
    subplot(6,2,2*i-1)
    plot(t,cos(theta-phi(i)),'LineWidth',1.5)
    ylabel(sprintf('k = %d',i))
    grid on

    % Right: harmonic component
    subplot(6,2,2*i)
    plot(t,A(i)*cos(theta)+B(i)*sin(theta), ...
        'LineWidth',1.5)
    ylabel(sprintf('k = %d',i))
    grid on

end