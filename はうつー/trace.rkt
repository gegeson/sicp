
#lang racket
(require racket/trace)
(printf "うわああ！！！\n")
(define (length l)
  (cond
      ((null? l) 0)
      (else
        (+ 1 (length (cdr l)))
       )
    )
  )
(trace length)
(display (length '(1 2 3)))
