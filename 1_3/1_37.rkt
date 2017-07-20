#lang racket
(require racket/trace)
;15:48->16:07
(define (cont-frac n d k)
  (define (cont-frac-iter i)
    (cond
      ((= i k) (/ (n k) (d k)))
      (else
        (/ (n i) (+ (d i) (cont-frac-iter (+ i 1))))
       )
    ))
  (trace cont-frac-iter)
  (cont-frac-iter 1)
)
(define (cont-frac2 n d k)
    (define (cont-frac2-iter i result)
        (if (> i k)
          result
          (cont-frac2-iter (+ i 1) (/ (n i) (+ (d i) result))))
      )
      (trace cont-frac2-iter)
    (cont-frac2-iter 1 0)
  )

(newline)
(display (cont-frac (lambda (i) 1.0) (lambda (i) 1.0) 11))
(newline)
(display (cont-frac2 (lambda (i) 1.0) (lambda (i) 1.0) 11))
