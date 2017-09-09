#lang racket
(require racket/trace)
(define (inc x) (+ x 1))
(define double
  (lambda (f)
          (lambda (x)
                  (f (f x))
                  )))
(display (((double double) inc) 1))
(newline)
(display ((double ((double double) inc)) 1))
(newline)
;((d d) inc)
;= x->(d d x) inc
;= x->(d d inc)
;= (d (x->(inc (inc x))))
;= (x-> (x->(inc (inc x))) ((x->(inc (inc x))) x)
;= (x-> (inc (inc ((x->(inc (inc x))) x))))
;= (x-> (inc (inc (inc (inc x)))))
;4回足すことになる。
;同じ流れで、
;(d ((d d) inc))
;は、
;(d (x-> (inc (inc (inc (inc x))))))
;= x -> (x-> (inc (inc (inc (inc x)))) ((x-> (inc (inc (inc (inc x))))) x))
;= x -> (x-> (inc (inc (inc (inc x)))) ((inc (inc (inc (inc x)))) )
;= x -> (x-> (inc (inc (inc (inc (inc (inc (inc (inc x)))))))))
;= x -> (inc (inc (inc (inc (inc (inc (inc (inc x))))))))
;で、8回足すことになる。
