# Autocorrelation Analysis

## Mathematical formulation

Pearson correlation between shifted observations:

$$
r_k = \frac{\sum_{i=1}^{n-k}(x_i-\bar{x}_1)(x_{i+k}-\bar{x}_2)}{\sqrt{\sum_{i=1}^{n-k}(x_i-\bar{x}_1)^2\sum_{i=1}^{n-k}(x_{i+k}-\bar{x}_2)^2}}
$$

## Data and parameters

```matlab
clc; clear; close all;

% Data
x = [33,32,30,29,25,30,37,37,29,30,36,32,33,34,53,45, ...
     25,28,32,27,26,28,24,26,9,22,17,26,27,30,34];

n = numel(x);
maxLag = 5;
```

## Method 1 — Explicit vectorised indexing

Valid indices: $i=1+L,```matlab
% ===== METHOD 1: EXPLICIT VECTORISED INDEXING =====

r1 = zeros(1,maxLag);

for k = 1:maxLag
    L = 0;
    R = k;
    i = (1+L):(n-R);

    x1 = x(i);
    x2 = x(i+k);

    m1 = mean(x1);
    m2 = mean(x2);

    numerator = sum((x1-m1).*(x2-m2));
    denominator = sqrt(sum((x1-m1).^2) * ...
                       sum((x2-m2).^2));

    r1(k) = numerator / denominator;
end
```

## Method 2 — Slicing

```matlab
% ===== METHOD 2: SLICING =====

r2 = zeros(1,maxLag);

for k = 1:maxLag
    x1 = x(1:n-k);
    x2 = x(k+1:n);

    m1 = mean(x1);
    m2 = mean(x2);

    numerator = sum((x1-m1).*(x2-m2));
    denominator = sqrt(sum((x1-m1).^2) * ...
                       sum((x2-m2).^2));

    r2(k) = numerator / denominator;
end

% Results
disp('Lag      Indexing      Slicing')
disp([(1:maxLag)' r1' r2'])

assert(all(abs(r1-r2) < 1e-12), ...
       'Methods do not agree.');
```

## Results

| Lag | Explicit indexing | Slicing |
|---:|---:|---:|
| 1 | 0.5188 | 0.5188 |
| 2 | 0.2677 | 0.2677 |
| 3 | 0.1979 | 0.1979 |
| 4 | 0.2337 | 0.2337 |
| 5 | 0.0842 | 0.0842 |

Both methods give identical results.
