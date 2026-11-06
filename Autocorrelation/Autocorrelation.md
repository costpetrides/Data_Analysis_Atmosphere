
```matlab
clc; clear; close all;

x = [33,32,30,29,25,30,37,37,29,30,36,32,33,34,53,45,25,28,32,27,26,28,24,26,9,22,17,26,27,30,34];

n = length(x);

% Maximum lag
maxLag = 5;

r = zeros(1, maxLag);

for k = 1:maxLag

    x1 = x(1:n-k);
    x2 = x(1+k:n);

    m1 = mean(x1);
    m2 = mean(x2);

    numerator = sum((x1-m1) .*(x2-m2));

    denominator = sqrt(sum((x1-m1).^2) .* ...
                       sum((x2-m2).^2));

    r(k) = numerator / denominator;

end

disp('Lag          Autocorrelation')
```

```matlabTextOutput
Lag          Autocorrelation
```

```matlab
disp([(1:maxLag)' r'])
```

```matlabTextOutput
1.0000    0.5188
    2.0000    0.2677
    3.0000    0.1979
    4.0000    0.2337
    5.0000    0.0842
```

```matlab

plot(1:maxLag, r, 'o-', 'LineWidth', 1.5)
xlabel('Lag k')
ylabel('Autocorrelation r_k')
grid on 
```

![figure_0.png](Autocorrelation_media/figure_0.png)
