#lang racket
(require racket/trace)
(require sicp)
(define (reverse lst)
  (define (reverse-iter lst result)
    (cond
      ((null? lst) result)
      (else
        (reverse-iter (cdr lst) (cons (car lst) result))
       )
      )
    )
    (reverse-iter lst '())
  )
(define x (list (list 1 2) (list 3 4)))
(display (reverse '(1 2 3)))

(define (deep-reverse lst)
  (define (deep-reverse-iter lst result)
      (cond
        ((null? lst) result)
        ((not (pair? lst))
        (cond
          ((null? result) lst)
          (else
            (cons lst result))))
        (else
         (deep-reverse-iter (cdr lst) (cons (deep-reverse (car lst)) result))
         )
      )
    )
  (trace deep-reverse-iter)
  (deep-reverse-iter lst nil)
  )
(newline)
(display (deep-reverse '(1 2)))
(newline)
(display (deep-reverse x))
(define y '(1 2 (3 4 (5 6)) 7))
(newline)
(display (deep-reverse y))
(define z '((1 2 3 4 5) ((1 2 3) (4 5 (6 7 8))) (3 4 (5 6)) 7))
(newline)
(display (deep-reverse z))
