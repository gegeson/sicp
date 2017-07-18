#lang racket
(require racket/trace)
(define (gcd a b)
  (if (= b 0)
    a
    (gcd b (rm a b))))

;正規順序評価
;完全に展開してから簡約する
;
;適用順序評価(gauche, racketはこっち)
;引数を評価してから適用する

(define rm remainder)
;;正規順序評価
;18回
;どんどん引数にremainderが溜まっていくが、
;if文を通る時はremainderの入れ子を整数値に戻すために計算する

;;適用順序評価
;(gcd 206 40)
;= (gcd 40 (rm 206 40))
;= (gcd 40 6)
;= (gcd 6 (rm 40 6))
;= (gcd 6 4)
;= (gcd 4 (rm 6 4))
;= (gcd 4 2)
;= (gcd 2 (rm 4 2))
;= (gcd 2 0)
;= 2
;4回
