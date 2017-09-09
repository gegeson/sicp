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

(define (_* a b)
  (if (= b 0)
    0
    (+ a (_* a (- b 1)))))

(define (double a) (+ a a))
(define (halve b) (/ b 2))

(define (__* a b)
  (cond ((= b 0) 0)
    ((even? b) (__* (double a) (halve b)))
    (else
      (+ a (__* a (- b 1)))
     )
    ))

(define (*fast-iter product a b)
  (cond ((= b 0) product)
    ((even? b) (*fast-iter product (double a) (halve b)))
    (else
      (*fast-iter (+ product a) a (- b 1))
      )
  ))
(define (*fast a b)
  (*fast-iter 0 a b))

;(trace _*)
(trace __*)
(trace *fast-iter)

;(display (_* 4 7))
;(newline)
;(display (__* 4 7))
;(newline)
;(display (*fast 4 7))
;(newline)
(display (_* 121 42))
(newline)
(display (__* 121 42))
(newline)
(display (*fast 121 42))
(newline)
(display (*fast 31 33))
(define (fast-times-iter c a b)
 (cond ((= b 0) c)
       ((even? b)
        (fast-times-iter (double c) a (halve b)))
       (else (fast-times-iter (+ c a) a (- b 1)))))
(trace fast-times-iter)
(define (fast-times a b)
  (fast-times-iter 0 a b))
(fast-times 31 33)
