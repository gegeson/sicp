(define (double n)
  (* n 2)
  )
(define (halve n)
  (/ n 2)
  )

(define (_* a b)
  (if (= b 0)
      0
      (+ a (_* a (- b 1)))
      )
  )

(define (even? n)
  (= (remainder n 2) 0)
  )
(define (multi a b)
  (cond
   ((= b 1) a)
   ((even? b)
    (double (multi a (halve b))))
   (else
    (+ a (multi a (- b 1)))
    )
   )
  )
(define (fast-multi-iter mem a b)
  (cond
   ((= b 1) (+ mem a))
   ((even? b)
    (fast-multi-iter mem (double a) (halve b)))
   (else
    (fast-multi-iter (+ mem a) a (- b 1))
    )
   )
  )
(define (fast-multi a b)
  (fast-multi-iter 0 a b)
  )




(use slib)
(require 'trace)
;;(trace multi)
;;(trace fast-multi-iter)
(set! debug:max-count 100)

(print (multi 11 7))
(print (fast-multi 11 7))
(print (multi 2 3))
(print (fast-multi 2 3))
(print (multi 1932 9842))
(print (fast-multi 1932 9842))
