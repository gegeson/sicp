#lang racket
(require racket/trace)
;16:15->16:28
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
(define (ret1 x) 1)
(define (d_e i)
    (cond
        ((= i 2) 2.0)
        ((= (remainder (- i 1) 3) 1)
         (* 2.0 (+ 1 (quotient i 3))))
      (else 1.0)
      )
  )
(display (cont-frac ret1 d_e 100))
