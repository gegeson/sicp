; 21:18->21:47
#lang racket

; Scehme手習いでYコンビネータの原理まで理解済みなので、多分余裕→余裕ではなかった

; 階乗の例
((lambda (n)
   ((lambda (fact)
      (fact fact n))
    (lambda (ft k)
      (if (= k 1)
          1
          (* k (ft ft (- k 1)))))))
 10)

; フィボナッチ。できてるっぽいが原理は覚えてないのであてずっぽうに近い
((lambda (n)
         ((lambda (fib)
                  (fib fib n))
          (lambda (ft k)
                  (cond
                    ((= k 0) 0)
                    ((= k 1) 1)
                    (else
                     (+ (ft ft (- k 1)) (ft ft (- k 2)))))))
         )
 4)

;;PART B
; 原理がよくわからないが、これで出来ているらしい。
; ほぼ当てずっぽう
; ぶっちゃけこの問題、内部定義というテーマからは脇の脇だし、
; Scheme手習いでガッツリ学んだことあるから、こんなもんでいいや。

(define (f x)
  ((lambda (even? odd?)
           (even? even? odd? x))
  (lambda (ev? od? n)
    (if (= n 0)
      true
      (od? od? ev? (- n 1))))
  (lambda (ev? od? n)
    (if (= n 0)
      false
      (od? od? ev? (- n 1))))))
(f 0)
(f 1)
(f 2)
(f 3)
(f 4)
(f 5)
(f 6)
(f 7)
(f 8)
(f 9)
(f 10)

; 別解
; http://d.hatena.ne.jp/tetsu_miyagawa/20131214/1387029694
; 最初の関数は引数xに対してeven?として渡された関数を適用する。引数には次に適用出来る様にeven?とodd?も渡す。
; even?とodd?に相当する関数は、次に適用するべき関数を引数として受け取る事、次に適用する時にこれらの関数も引数とする事以外は普通に記述する
; だそうで。
(define (f x)
    ((lambda (even? odd?)
       (even? even? odd? x))
     (lambda (ev? od? n)
       (if (= n 0) true (od? ev? od? (- n 1))))
     (lambda (ev? od? n)
       (if (= n 0) false (ev? ev? od? (- n 1))))))
