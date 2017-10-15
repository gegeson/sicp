#lang debug racket
(require sicp)
(require racket/trace)
;20:38->20:53
(define (append x y)
  (if (null? x)
    y
    (cons (car x) (append (cdr x) y))))
(define (last-pair x)
  (if (null? (cdr x))
      x
    (last-pair (cdr x)))
  )
(define (append! x y)
  (set-cdr! (last-pair x) y)
  x)
(display (last-pair '(1 2)))
(newline)
(define x (list 'a 'b))
(define y (list 'c 'd))
(define z (append x y))
(display z)
(newline)
(display (cdr x)) ;=> (b)
(define w (append! x y))
(newline)
(display w)
(newline)
(display x) ;=> (a b c d)
(newline)
(display (cdr x)) ;=> (b c d)
;w (append! x y)で、
;xの最後のcdr、つまりリストの最後にあるnilがyを指すように破壊的に変更した
;だからこうなる
;図は略だけどまあ書くまでもない
