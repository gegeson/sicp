;15:37->
#lang racket
(require racket/trace)

(define (cons2 x y)
  (lambda (m) (m x y)))
(define (car2 z)
  (z (lambda (p q) p)))
(define (cdr2 z)
  (z (lambda (p q) q)))

(define lst1 (cons2 1 2))
(display (car2 lst1)) ;=>1
(newline)
(display (cdr2 lst1)) ;=>2
(newline)
(define lst2 (cons2 0 lst1))
(display (car2 lst2)) ;=>0
(newline)
(display (cdr2 lst2)) ;=>procedure（おそらく(1 2)）(newline)
(newline)
(display (car2 (cdr2 lst2))) ;=>1
(newline)
(display (cdr2 (cdr2 lst2))) ;=>2
;(car (cons x y))
;(cons x y)
;=(m -> (m x y))
;
;(car (cons x y))
;= (z -> (z (p q -> p))) (m -> m x y)
;= (m -> m x y) (p q -> p)
;=　(p q -> p) (x y)
;= x
