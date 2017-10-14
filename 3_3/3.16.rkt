#lang debug racket
(require sicp)
(require racket/trace)
;7:47->
;ググったら何もかもが違う（問題文の意味を理解できてない）
;悲しい。
(define (count-pairs x)
  (if (not (pair? x))
    0
    (+ (count-pairs (car x))
       (count-pairs (cdr x))
       1)))
(define a1 '((a) (b) (c)))
;(count-pairs '())
(count-pairs a1)
;トレースチャレンジ！
;(count-pairs ((a) (b) (c)))
;= (+ (count-pairs (a)) (count-pairs ((b) (c))) 1)
;  (count-pairs (a))
;  = (+ (count-pairs a) (count-pairs nil) 1)
;  = 1
;
;  (count-pairs ((b) (c)))
;  = (+ (count-pairs (b)) (count-pairs ((c))) 1)
;
;    (count-pairs (b))
;    = 1
;
;    (count-pairs ((c)))
;    = (+ (count-pairs (c)) (count-pairs nil) 1)
;    = 1 + 1
;  = 4
;= (+ 1 4 1)
;= 6

;じゃあ、これは7になるはずだ
(define a2 '((a b) (c) (d)))
(count-pairs a2)
;->なった。

(define x 'a)
(define a3 '((x) (x) (x)))
(count-pairs a3)
;これは6のまま。まあ、トレースした感じ共有は明らかに関係ないからなあ。

(define a4 '(nil nil nil))
(count-pairs a4)
;うん、これは3を返す…けど、これはペアと呼んでいいのか？わからん。



(define (last-pair x)
  (if (null? (cdr x))
      x
    (last-pair (cdr x)))
  )
(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)
(define a5 '((a) (b) (c)))
(define a5-cycle (make-cycle a5))
(count-pairs a5-cycle)
案の定無限ループ
