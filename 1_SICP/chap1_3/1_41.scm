(define (inc n) (+ n 1))

(define (double f)
  (lambda(x) (f (f x)))
  )

(print (((double (double double)) inc) 0))
