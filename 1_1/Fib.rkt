木の再帰によるFib(n)の葉の数を表す関数Lfib(n)を考える
Lfib(2) = 2
Lfib(1) = 1
Lfib(0) = 0
Lfib(n) = Lfib(n-1) + Lfib(n-2)
これはFib(n)を一つずつずらしたものと同じなので、
Lfib(n) = Fib(n+1)が言える。
