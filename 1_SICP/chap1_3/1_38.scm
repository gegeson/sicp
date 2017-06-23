(define (cont-frac n d k)
  (define (iter i)
    (if (= i k)
        (/ (n i) (d i))
        (/ (n i) (+ (d i) (iter (+ i 1)))))
    )
  (iter 1)
  )

(define (cont-frac2 n d k)
  (define (iter i result)
    (if (= i 1)
        (/ (n i) (+ (d i) result))
        (iter (- i 1) (/ (n i) (+ (d i) result))))
    )
  (iter k 0)
  )

(define (d* n)
  (if (= 0 (remainder (- n 2) 3))
      (+ 2.0 (/ (* 2.0 (- n 2.0)) 3.0) )
      1.0)
  )
(define (loop n)
  (if (< n 15)
      (let ()
        (print (d* n))
        (loop (+ n 1)))
      (print (d* n))
      )
  )
;;(loop 1)
(print (+ 2.0 (cont-frac (lambda (x) 1.0) d* 5)))
(print (+ 2.0 (cont-frac2 (lambda (x) 1.0) d* 5)))
(print (+ 2.0 (cont-frac (lambda (x) 1.0) d* 10)))
(print (+ 2.0 (cont-frac2 (lambda (x) 1.0) d* 10)))
(print (+ 2.0 (cont-frac (lambda (x) 1.0) d* 15)))
(print (+ 2.0 (cont-frac2 (lambda (x) 1.0) d* 15)))
;;(lambda (n) (= 0 (remainder (- n 2) 3)))
;;(lambda (n) (+ 2 (/ (* 2 (- x 2)) 3) ))
