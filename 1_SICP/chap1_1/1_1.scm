;;18:08->18:52
;;18:55->19:42
;;22:23->23:15
;;23:26-00:07
;;00:24->00:38
;;4/4
(use slib)
(require 'trace)
(set! debug:max-count 100)
(define (square x) (* x x))

(/ (+ 5 4 (- 2 (- 3 (+ 6 (/ 4 5))))) (* 3 (- 6 2) (- 2 7)))
(define (sum-of-squares x y)
  (+ (square x) (square y))
  )
;;(define (>= x y) (not (< x y)))

(define (sum_1_3 x y z)
  (cond
   ((and (>= x y) (>= z y))
    (sum-of-squares x z)
    )
   ((and (>= y x) (>= z x))
    (sum-of-squares y z)
    )
   (else
    (sum-of-squares x y)
    )
   )
  )
(print (sum_1_3 1 2 3))
(print (sum_1_3 1 3 2))
(print (sum_1_3 2 1 3))
(print (sum_1_3 2 3 1))
(print (sum_1_3 3 1 2))
(print (sum_1_3 3 2 1))

;;(if (> b 0) + -)の部分は最終的に+か-かになるので
;;(> b 0)の真偽に応じて(+ a b)か(- a b)かを計算することになる
;;具体的には、aにbの絶対値を加える手続きとなる
(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b)
  )
(define (p) (p))

(define (test x y)
  (print x)
  (if (= x 0) 0 y)
  )
;;(test 0 (p))
;;(p)は、終了条件がない無限の再帰なので、
;;正規順序ならば最後まで(p)を評価することがなく、
;;0を返すが、
;;適用順序ならばいきなり(p)を評価するため無限ループになり、
;;プログラムが停止する


(define (improve guess x)
  (average guess (/ x guess))
  )

(define (average x y)
  (/ (+ x y) 2)
  )

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001)
  )
(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x) x)
      )
  )

(define (sqrt x)
  (sqrt-iter 1.0 x)
  )

(define (new-if predicate then-clause else-clause)
  (cond (predicate
         then-clause)
        (else
         else-clause)
        )
  )
(define (good-enough2? guess prguess x)
  (< (abs (- guess prguess)) (/ guess 1000.0))
  )
;;new-ifは関数なので、まず引数を評価してから
;;関数を適用する。
;;しかし引数に再帰があると、
;;ifであるならばスルーして欲しい再帰まで追いかけてしまい、
;;無限ループになる。
(define (sqrt-iter2 guess x)
  (new-if (good-enough? guess x)
      guess
      (sqrt-iter2 (improve guess x) x)
      )
  )
(define (sqrt-iter3 guess x)
  (cond
   ((good-enough? guess x)
      guess)
   (else
    (sqrt-iter3 (improve guess x) x)
    )
   )
  )

(define (sqrt-iter4 guess x)
  (if (good-enough2? (improve guess x) guess x)
      guess
      (sqrt-iter4 (improve guess x) x)
      )
  )


(trace sqrt-iter)
;;(print (sqrt 2))
;;(print (sqrt 0.000001))
;;(print (sqrt 9.0e28))
(print (sqrt 10000000000000))
(print (sqrt-iter4 1.0 0.000001))
(print (sqrt-iter4 1.0 2))
(print (sqrt-iter4 1.0 9))
(print (sqrt-iter4 1.0 9.0e29))

;;0.0001では小さい数同士では近似の制度が悪い。
;;とても大きい数について
;;有効数字が10桁だとしたら、0.001で判定する場合3桁がこれに奪われるので7桁になってしまう。計算不能。
;;多分そんな感じ

;;good-enough2?は小さい数については解決するが、
;;大きい数については、推定値に対する相対的な大きさを調べるので、
;;数が大きいほど精度が粗くなってしまう模様

(define (improved-good-enough2? old-guess new-guess)
  (< (abs (- 1.0 (/ old-guess new-guess))) 0.001))

;; 改良型improved-good-enough2? を使用
(define (improved-sqrt-iter2 old-guess new-guess x)
  (if (improved-good-enough2? old-guess new-guess)
      new-guess
      (improved-sqrt-iter2 new-guess (improve new-guess x) x)))

(define (improved-mysqrt2 x)
  (improved-sqrt-iter2 1.0 x x))

(print (improved-mysqrt2 9.0))
(print (improved-mysqrt2 9000000000000.0))

