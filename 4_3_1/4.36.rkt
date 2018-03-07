18:48->19:19
20:31->22:43

まったく答えに近づけないまま二時間半。
タイムアップ。
答えを見る。

"単純に an-integer-between を an-integer-starting-from に変更しただけでは、任意の Pythagoras 三角形を生成する方法として適切でない理由は。
an-integer-starting-from は継続を失敗することが無いために無限に継続するので、バックトラックできないため計算ができない。
正常に計算できるためには、最大値を与えて継続の範囲を限定し、バックトラックできるようにする必要がある。

三角形の長辺 k をまず指定し、残りの2つの短辺の最大値を長辺の長さに限定し、バックトラックできるようにする。"
http://www.serendip.ws/archives/2339

三角形の性質を使う、という発想が少しも出なかった…
上限をどこかに設ける、という考えなら出てきたんだけどなあ。
途中で一部だけ止められればいい、とも考えてたけど、
そこにbetweenを使う、という発想が出てこなかったなあ…
---
(define (an-integer-starting-from n)
  (amb n (an-integer-starting-from (+ n 1))))

(define (an-integer-between low high)
  (if (= low high)
      low
    (amb low (an-integer-between (+ low 1) high))))

(define (a-pythagorean-triple low)
  (let ((k (an-integer-starting-from low)))
    (let ((j (an-integer-between low k)))
      (let ((i (an-integer-between low j)))
        (require (= (+ (* i i) (* j j)) (* k k)))
        (list i j k)))))
---
ゴミ箱（の一部）
---
(define (a-pythagorean-triple-between low)
  (let ((i (an-integer-starting-from low)))
    (let ((j (an-integer-starting-from i)))
      (let ((k (an-integer-starting-from j)))
        (require (= (+ (* i i) (* j j)) (* k k)))
        (list i j k)))))
無限ループ。
---
試しにこのように書き換えると、kだけがどんどん進んでいた。
これは困る。
(define (test low)
  (let ((i (an-integer-starting-from low)))
    (let ((j (an-integer-starting-from i)))
      (let ((k (an-integer-starting-from j)))
        (list i j k)))))
しかし、
一つだけが進みすぎない & 全部を網羅し尽くす
って難しくないか…？
---
まず、二つの要素だけで満遍なく進める事を考えてみよう
---
(define (test2 a b)
  (let ((i (an-integer-starting-from a)))
    (let ((j (an-integer-starting-from b)))
        (amb (list i j) (list (+ i 1) j) (list i (+ j 1))
             (test2 (+ i 1) (+ j 1))))))

なかなか解けないが、色々試行錯誤してわかったこと。
(amb 初期値 再帰)
という形を書くと、
初期値を見る→再帰
の順に進むが、
初期値を一つ見て再帰を見て、再帰の中の初期値を見て、
の繰り返しなので、
結局、初期値を関数の引数に応じて変化させながら繰り返す形にしか出来ない。
上のtest2だと、
(i, j), (i+1, j), (i, j+1), (i+1, i+1), (i+2, j+1), (i+1, j+2), (i+2, j+2)
こういうものになるだけで、網羅出来てない。
かと言って、(amb 再帰　再帰)みたいにすると終着点なしの無限ループになる。
今回、満遍なく見てほしいが、それを
(amb 初期値　初期値　再帰)
のような形で表現するのはかなり難しいと思う。
---
逆転の発想で、上限を決めて少しずつ上限をあげていくっていのはどうだろう

一応出来たが、ピタゴラスに適用しようとすると停止する…
(define (an-integer-to n)
  (require (> n 0))
  (amb n (an-integer-to (- n 1))))

(define (test3 n)
  (let ((i (an-integer-to n)))
    (let ((j (an-integer-to i)))
        (list i j))))

(define (test4 n)
  (amb (test3 n) (test4 (+ n 1))))
---
