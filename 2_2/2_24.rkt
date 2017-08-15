#lang racket
(require racket/trace)
(require sicp)

(define (count-leaves x)
  (cond
    ((null? x) 0)
    ((not (pair? (car x))) (+ 1 (count-leaves (cdr x))))
    (else
     (+ (count-leaves (car x)) (count-leaves (cdr x))))
    )
  )
(trace count-leaves)
(display (count-leaves (list 1 2 (list 1 2))))
(newline)
(display (count-leaves (cons (list 1 2) (list 1 2))))
(newline)
(display (list 1 (list 2 (list 3 4))))
(newline)
(display (cons 1 (cons (cons 2 (cons (cons 3 (cons 4 nil)) nil)) nil)))
(newline)
(display (cons (cons 7 nil) nil))
(newline)
(display (cons (list 1 2)(list 3 4)))
;(newline)
(display (cons (cons 1 (cons 2 nil)) (cons 3 (cons 4 nil))))
;(1->(2->(3->(4->nil)->nil) ->nil))
;=(1 (2 (3 4)))
 /    \
1   /   \
   2   /  \
      3    4
