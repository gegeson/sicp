(define (square x) (* x x))
(define (average-3 a b c) (/ (+ a b c) 3))
(define dx 0.00001)

(define (compose f g)
  (lambda (x) (f (g x)))
  )
(define (repeated f n)
  (define (iter n)
    (if (= n 1)
        (lambda (a) (f a))
        (compose f (iter (- n 1))))
    )
  (iter n)
  )

(define (smooth f)
  (lambda (x)
    (average-3
      (f (- x dx)) (f x) (f (+ x dx))
     )
    ))
;;間違い
(define (smooth-n-dame f n)
    (repeated (smooth f) n)
  )

(define (smooth-n f n)
  ((repeated smooth n) f)
  )

(print ((smooth-n sin 10) (/ 3.14 6)))
