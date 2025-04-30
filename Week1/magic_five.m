%%magic_five.m - build a 5x5 magic square two ways
clear,clc
n = 5;              % order of the square

%% 1) Imperative version - "Siamese" algorithm (for-loops)
M_imp = zeros(n);   % pre-allocate a 5×5 matrix of zeros
row = 1;            % start in the first row
col = (n+1)/2;      % …and the middle column (3 for n=5)

for k = 1:n^2
    M_imp(row,col) = k; % drop the current number into the cell
    
    % Step 1: compute the candidate cell
    nextRow = row - 1;  if nextRow < 1, nextRow = n; end
    nextCol = col + 1;  if nextCol > n, nextCol = 1; end

    % Step 2: occupied? then go 'down' instead
    if M_imp(nextRow,nextCol) ~= 0
        row = row + 1;  if row > n, row = 1; end
    else
        row = nextRow;
        col = nextCol;
    end
end

disp(M_imp)

% Row sums - dimension-2 collapse keeps rows separate
rowSums = sum(M_imp, 2); % 5x1 column vector
fprintf("\nRow sums: %s\n", mat2str(rowSums'))

% Column sums - dimension-1 collapse keeps columns separate
colSums = sum(M_imp,1); % 1x5 row vector
fprintf("Col sums: %s\n", mat2str(colSums))

% Diagonal sums
mainDiagSum = trace(M_imp);                   % ↘︎ (i == j)
antiDiagSum = trace(flip(M_imp, 2));          % ↙︎ (i + j == n+1)

fprintf("Main diagonal  sum = %d\n", mainDiagSum);
fprintf("Anti-diagonal sum = %d\n", antiDiagSum);

% Quick validation for a magic square of order n
n = size(M_imp, 1);
magicConstant = n * (n^2 + 1) / 2;
assert(all(rowSums  == magicConstant) && ...
       all(colSums  == magicConstant) && ...
       mainDiagSum  == magicConstant  && ...
       antiDiagSum  == magicConstant, "Not a proper magic square!");

%% Remove the matrix diagonal
A = M_imp;                  % start with a copy
idxDiag = 1 : n+1 : n^2;    %linear indices of diagonal elements
A(idxDiag) = 0;             % set them to 0  (use NaN if you prefer)
A