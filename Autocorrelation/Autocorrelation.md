# Autocorrelation Analysis

## Mathematical formulation

The correlation coefficient at lag $k$ is:

$$
r_k = \frac{\sum_{i=1}^{n-k}(x_i-\bar{x}_1)(x_{i+k}-\bar{x}_2)}{\sqrt{\sum_{i=1}^{n-k}(x_i-\bar{x}_1)^2\sum_{i=1}^{n-k}(x_{i+k}-\bar{x}_2)^2}}
$$

## MATLAB implementation

```matlab
clc; clear; close all;

% Data
x = [33,32,30,29,25,30,37,37,29,30,36,32,33,34,53,45, ...
     25,28,32,27,26,28,24,26,9,22,17,26,27,30,34];

n = length(x);

% Maximum lag
maxLag = 5;
r = zeros(1, maxLag);

% Autocorrelation
for k = 1:maxLag

    x1 = x(1:n-k);
    x2 = x(1+k:n);

    m1 = mean(x1);
    m2 = mean(x2);

    numerator = sum((x1-m1).*(x2-m2));

    denominator = sqrt(sum((x1-m1).^2) * ...
                       sum((x2-m2).^2));

    r(k) = numerator / denominator;

end

% Display results
disp('Lag          Autocorrelation')
disp([(1:maxLag)' r'])

% Plot in MATLAB
figure
plot(1:maxLag, r, 'o-', 'LineWidth', 1.5)
xlabel('Lag k')
ylabel('Autocorrelation r_k')
grid on



```

## Results

| Lag | Autocorrelation |
|---:|---:|
| 1 | 0.5188 |
| 2 | 0.2677 |
| 3 | 0.1979 |
| 4 | 0.2337 |
| 5 | 0.0842 |
