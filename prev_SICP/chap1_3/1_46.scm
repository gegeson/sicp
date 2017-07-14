(define (square x) (* x x))
(define (cube x) (* x x x))
(define (average a b) (/ (+ a b) 2))

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve* x guess)
                 x)))

(define (improve* x guess)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

(define (sqrt x)
  (sqrt-iter 1.0 x))


(define tolerance 0.00001)

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2))
       tolerance
       )
    )
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))
      )
    )
  (try first-guess)
  )


(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2))
       tolerance
       )
    )
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))
      )
    )
  (try first-guess)
  )

(define (fixed-point2 f first-guess)
   (define close-enough?
     (lambda (v1)
       (lambda (v2)
         (< (abs (- v1 v2))
            tolerance
            )
         )))
  ((interative-improve close-enough? f) first-guess)
  )

(define (interative-improve judge improve)
  (lambda (guess)
    (if ((judge guess) (improve guess))
        (improve guess)
        ((interative-improve judge improve) (improve guess))
        )
    )
  )
(print (fixed-point cos 1.0))
(print (fixed-point2 cos 1.0))
(print (fixed-point (lambda (y) (+ (sin y) (cos y))) 1.0))
(print (fixed-point2 (lambda (y) (+ (sin y) (cos y))) 1.0))
;;interative-improveを使ったsqrt2
(define (sqrt2 x)
  (define improve*
    (lambda (y)
      (lambda (guess)
        (if (and (= y x) (= guess x))
            x
            (average guess (/ y guess)))
        )
      )
    )
  (define good-enough?*
    (lambda (guess)
      (lambda (y)
        (print guess)
        (print y)
        (< (abs (- (square guess) x)) 0.001)
        )
      ))
  ((interative-improve good-enough?* (improve* x)) 2.5)
  )

(sqrt2 2.0)
(sqrt2 3.0)

(define good-enough?**
  (lambda (x)
    (lambda (guess)
      (< (abs (- (square guess) x)) 0.001))
    ))


(define (interative-improve2 judge improve)
  (lambda (guess)
    (if (judge guess (improve guess))
        (improve guess)
        ((interative-improve2 judge improve) (improve guess))
        )
    )
  )
