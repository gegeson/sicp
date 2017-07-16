#lang racket
(require racket/trace)

(define (square n)
  (* n n))
(define (even? n)
    (= (remainder n 2) 0))

  (define (fast-expt b n)
    (cond ((= n 0) 1)
          ((even? n) (square (fast-expt b (/ n 2))))
          (else (* b (fast-expt b (- n 1))))))

(define (fast-expt2-iter a b n)
  (cond
    ((= n 0) a)
    ((even? n) (fast-expt2-iter a (square b) (/ n 2)))
    (else
      (fast-expt2-iter (* a b) b (- n 1)) )))
(define (fast-expt2 b n)
  (fast-expt2-iter 1 b n)
  )
(trace fast-expt)
(trace fast-expt2-iter)
(display (fast-expt 2 11))
(newline)
(display (fast-expt2 2 11))
(newline)
(display (fast-expt2 2 16))
