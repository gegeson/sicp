(define zero (lambda (f) (lambda (x) x))) 
(define (add-1 n)
    (lambda (f) (lambda (x) (f ((n f) x)))))
(define one
   (lambda(f) (lambda(x) (f x)))
  )
(define two
  (lambda(f) (lambda(x)(f (f x)))))

(define (plus a b)
   (lambda(f) (lambda(x) ((a f) ((b f) x))))
  )

(define (inc n)
  (+ n 1))

(define (to_s z)
  ((z inc) 0))

(print (to_s zero))
(print (to_s (add-1 one)))
(print (to_s (plus (add-1 one) (add-1 (add-1 one)))))