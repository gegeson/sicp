(define (cube x) (* x x x))

(define (integral f a b dx)
  (define (add-dx x)
    (+ x dx)
    )
  (* (sum f (+ a (/ dx 2.0)) add-dx b) dx)
  )
(define (integral2 f a b dx)
  (define (add-dx x)
    (+ x dx)
    )
  (* (sum2 f (+ a (/ dx 2.0)) add-dx b) dx)
  )

(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b)
         )
      )
  )

(define (sum2 term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (+ (term a) result))
        )
    )
  (iter a 0)
  )
(print (integral cube 0 1 0.01))
(print (integral cube 0 1 0.001))
(print (integral2 cube 0 1 0.01))
(print (integral2 cube 0 1 0.001))
