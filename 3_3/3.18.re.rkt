#lang debug racket
(require sicp)
(require racket/trace)
;17:31->17:56
;+3m
(define (check-loop lst)
  (define checked-lst nil)
  (define (check-lst lst)
    (cond
      [(not (pair? lst)) #f]
      [(memq lst checked-lst) #t]
      [else #f]
      )
    )
  (define (sub lst)
    (cond
      [(null? lst) #f]
      [(not (pair? lst)) #f]
      [(check-lst lst)
       #t]
      [else
       (begin
        (set! checked-lst (cons lst checked-lst))
              (or (sub (car lst)) (sub (cdr lst))))
       ]
      ))
  (sub lst)
  )

(define (last-pair x)
  (if (null? (cdr x))
      x
    (last-pair (cdr x)))
  )
(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)
(define z (make-cycle (list 'a 'b 'c)))
(display (check-loop z)) ;#t
(newline)
(display (check-loop (list 'a 'b 'c))) ;#f
(newline)
(display (check-loop nil)) ;#f
(newline)
(display (check-loop (cons z '(1 2 3)))) ;#t
(newline)
(display (check-loop (cons '(1 2 3) z))) ;#t
(newline)
(display (check-loop (list 'a 'a 'a))) ;#fになってるので、前より前に進んだ。
(newline)
(newline)

;テストデータ拝借
;https://wizardbook.wordpress.com/2010/12/16/exercise-3-18/
;これが通ればOK
(define l1 (list 'a 'b 'c))
(define l2 (list 'a 'b 'c))
(set-cdr! (cdr (cdr l2)) l2)
(define l3 (list 'a 'b 'c 'd 'e))
(set-cdr! (cdddr l3) (cdr l3))
(define l4 (list 'a 'b 'c 'd 'e))
(set-car! (cdddr l4) (cddr l4))

(check-loop l1)
;#f

(check-loop l2)
;#t

(check-loop l3)
;#t

(check-loop l4)
;#f
