# Mathematical Summations to MATLAB Indexing

> GitHub-readable version of the MATLAB Live Script. The MATLAB source file (`.mlx`) is for opening and running in MATLAB Live Editor.

## Indexing rules

Mathematical indices start at 1 here, as do MATLAB indices: $x_1$ corresponds to `x(1)`. MATLAB ranges `x(start:stop)` include both endpoints (unlike Python slices). `numel(x)` returns the number of elements.

## Method 1 — Direct vector slicing

For a sum of shifted observations,

$$
S=\sum_{i=a}^{b}x_{i+k}
$$

write `S = sum(x(a+k:b+k));` with indices from 1 through `numel(x)`.

## Method 2 — Explicit indexing

Use `i = a:b;` and `S = sum(x(i+k));` to preserve the mathematical summation indices explicitly.

Both methods agree when indices are valid. MATLAB uses parentheses for array indexing. Elementwise multiplication and exponentiation use `.*` and `.^`.

## Exercise 1 - Product of lagged observations

Given x = [3,5,8,12,7,10,15,6,9,4], k = 2. No loops.

$$
S=\sum_{i=1}^{n-k}x_i x_{i+k}
$$

```matlab
x = [3,5,8,12,7,10,15,6,9,4];
n = numel(x);
k = 2;
% Method 1: slices
x1 = x(1:n-k);
x2 = x(k+1:n);
S_slice = sum(x1 .* x2);
% Method 2: explicit mathematical indices
i = 1:n-k;
S_index = sum(x(i) .* x(i+k));
fprintf('Exercise 1: slicing = %g, indexing = %g\n', S_slice, S_index);
assert(isequal(S_slice,S_index));
```

## Exercise 2 - Centered product sum

Mean values are calculated over their own overlapping segments.

$$
S=\sum_{i=1}^{n-k}(x_i-\bar{x}_{-})(x_{i+k}-\bar{x}_{+})
$$

$$
\bar{x}_{-}=\frac{1}{n-k}\sum_{i=1}^{n-k}x_i,\qquad \bar{x}_{+}=\frac{1}{n-k}\sum_{i=k+1}^{n}x_i
$$

```matlab
x = [3,5,8,12,7,10,15,6,9,4];
n = numel(x); k = 2;
% Method 1
x1 = x(1:n-k);
x2 = x(k+1:n);
m1 = mean(x1); m2 = mean(x2);
S_slice = sum((x1-m1).*(x2-m2));
% Method 2
i = 1:n-k;
m1i = mean(x(i)); m2i = mean(x(i+k));
S_index = sum((x(i)-m1i).*(x(i+k)-m2i));
fprintf('Exercise 2: slicing = %g, indexing = %g\n', S_slice, S_index);
assert(abs(S_slice-S_index)<1e-10);
```

## Exercise 3 - Multiple shifted indices

Given x = [3,5,8,12,7,10,15,6,9,4,11,14].

$$
S=\sum_{i=2}^{n-3}(x_{i+1}-x_{i-1})(x_{i+2}-x_i)
$$

```matlab
x = [3,5,8,12,7,10,15,6,9,4,11,14];
n = numel(x);
% Method 1 - bounds from i=2,...,n-3
S_slice = sum((x(3:n-2)-x(1:n-4)).*(x(4:n-1)-x(2:n-3)));
% Method 2
i = 2:n-3;
S_index = sum((x(i+1)-x(i-1)).*(x(i+2)-x(i)));
fprintf('Exercise 3: slicing = %g, indexing = %g\n', S_slice, S_index);
assert(isequal(S_slice,S_index));
```

## Exercise 4 - Two sums with different limits

Given x = [4,7,2,9,12,5,8,15,6,11,3,10,14,7,13,5,9,16], k = 3.

$$
S_1=\sum_{i=2}^{n-k-2}(x_{i+k}-x_{i-1})^2
$$

$$
S_2=\sum_{j=k+1}^{n-2}(x_{j+1}-x_{j-k})(x_j-x_{j-1})
$$

No loops and no reindexing of the mathematical sums.

$$
S=S_1+S_2
$$

```matlab
x = [4,7,2,9,12,5,8,15,6,11,3,10,14,7,13,5,9,16];
n = numel(x); k = 3;
% Method 1 - slice ranges directly from the original sum limits
S1_slice = sum((x(k+2:n-2)-x(1:n-k-3)).^2);
S2_slice = sum((x(k+2:n-1)-x(1:n-k-2)).*(x(k+1:n-2)-x(k:n-3)));
S_slice = S1_slice + S2_slice;
% Method 2 - original mathematical indices i,j
i = 2:n-k-2;
j = k+1:n-2;
S1_index = sum((x(i+k)-x(i-1)).^2);
S2_index = sum((x(j+1)-x(j-k)).*(x(j)-x(j-1)));
S_index = S1_index + S2_index;
fprintf('Exercise 4: slicing = %g, indexing = %g\n', S_slice, S_index);
assert(isequal(S_slice,S_index));
```

## Exercise 5 - Lagged correlation coefficient

For k = 1,...,5. Pearson correlation of overlapping lagged segments. Do not use corrcoef().

$$
r_k=\frac{\sum_{i=1}^{n-k}(x_i-\bar{x}_{-})(x_{i+k}-\bar{x}_{+})}{\sqrt{\left[\sum_{i=1}^{n-k}(x_i-\bar{x}_{-})^2\right]\left[\sum_{i=k+1}^{n}(x_i-\bar{x}_{+})^2\right]}}
$$

```matlab
x = [33,32,30,29,25,30,37,37,29,30,36,32,33,34,53,45,25,28,32,27,26,28,24,26,9,22,17,26,27,30,34];
n = numel(x);
maxLag = 5;
r_slice = zeros(1,maxLag);
r_index = zeros(1,maxLag);
for k = 1:maxLag
    % Method 1
    x1 = x(1:n-k);
    x2 = x(k+1:n);
    m1 = mean(x1); m2 = mean(x2);
    numerator = sum((x1-m1).*(x2-m2));
    denominator = sqrt(sum((x1-m1).^2)*sum((x2-m2).^2));
    r_slice(k) = numerator/denominator;
    % Method 2: original mathematical index i
    i = 1:n-k;
    m1i = mean(x(i)); m2i = mean(x(i+k));
    numerator = sum((x(i)-m1i).*(x(i+k)-m2i));
    denominator = sqrt(sum((x(i)-m1i).^2)*sum((x(i+k)-m2i).^2));
    r_index(k) = numerator/denominator;
end
fprintf('  Lag      r_k\n');
fprintf('  %d      %.4f\n',[(1:maxLag);r_slice]);
assert(all(abs(r_slice-r_index)<1e-12));
figure;
plot(1:maxLag,r_slice,'o-','LineWidth',1.5);
xlabel('Lag k'); ylabel('Autocorrelation r_k');
xticks(1:maxLag); grid on;
title('Lagged Pearson correlation');
```

## Exercise 5 - Reindexing note

General reindexing identity.

$$
\sum_{i=a}^{b}f(i)=\sum_{j=c}^{b-a+c}f(j+a-c)
$$

Direct MATLAB slices do not require reindexing.

$$
\sum_{i=k+1}^{n}(x_i-\bar{x}_{+})^2=\sum_{i=1}^{n-k}(x_{i+k}-\bar{x}_{+})^2
$$

## Exercise 6 - Four summations

Given x = [4,7,12,5,9,15,3,11,8,14,6,10,17,2,13,19,7,16,5,12,9,18,4,11,15], k = 3.

$$
S_1=\sum_{i=2}^{n-k-3}(x_{i+k}-x_{i-1})(x_{i+2}-x_i)
$$

$$
S_2=\sum_{i=k+1}^{n-2}(x_i-x_{i-k})^2
$$

$$
S_3=\sum_{i=3}^{n-k}(x_{i+k-1}-x_{i-2})(x_{i+1}-x_i)
$$

$$
S_4=\sum_{i=k+2}^{n-1}(x_i-x_{i-k-1})^2
$$

No loops or manual term evaluation.

$$
S=S_1+S_2-S_3+S_4
$$

```matlab
x = [4,7,12,5,9,15,3,11,8,14,6,10,17,2,13,19,7,16,5,12,9,18,4,11,15];
n = numel(x); k = 3;
% Method 1 - direct slices derived from the written summation bounds
S1 = sum((x(k+2:n-3)-x(1:n-k-4)).*(x(4:n-k-1)-x(2:n-k-3)));
S2 = sum((x(k+1:n-2)-x(1:n-k-2)).^2);
S3 = sum((x(k+2:n-1)-x(1:n-k-2)).*(x(4:n-k+1)-x(3:n-k)));
S4 = sum((x(k+2:n-1)-x(1:n-k-2)).^2);
S_slice = S1+S2-S3+S4;
% Method 2 - keep original mathematical indices
 i = 2:n-k-3;
 j = k+1:n-2;
 ell = 3:n-k;
 m = k+2:n-1;
T1 = sum((x(i+k)-x(i-1)).*(x(i+2)-x(i)));
T2 = sum((x(j)-x(j-k)).^2);
T3 = sum((x(ell+k-1)-x(ell-2)).*(x(ell+1)-x(ell)));
T4 = sum((x(m)-x(m-k-1)).^2);
S_index = T1+T2-T3+T4;
fprintf('Exercise 6: slicing = %g, indexing = %g\n',S_slice,S_index);
assert(isequal(S_slice,S_index));
```
