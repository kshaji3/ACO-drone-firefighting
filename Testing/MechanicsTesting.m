A = {1 2 3; 4 5 6};
B = {'apple', 'banana', 'banana'; 'cherry', 'cherry', 'apple'};
S = struct('number', A, 'fruit', B);
T = S(2, 2) % T.number is 5, T.fruit is 'cherry'