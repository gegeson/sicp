#lang debug racket
(require sicp)
(require racket/trace)
;16:25->16:36
(define (circulate? x)
  (define encountered nil)
  (define (check-enc x)
    (cond
      [(memq x encountered) #t]
      [else
        (begin (set! encountered (cons x encountered)) #f)
       ]
      )
    )
  (define (iter x)
    (cond
      [(not (pair? x)) #f]
      [(check-enc x) #t]
      [else
       (iter (cdr x))
       ]
      ))
  (iter x)
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
(display (circulate? z)) ;#t
(newline)
(display (circulate? (list 'a 'b 'c))) ;#f
(newline)
(display (circulate? nil)) ;#f
(newline)
(display (circulate? (cons z '(1 2 3)))) ;#f（循環リストの定義上これは#fで正しい。）
(newline)
(display (circulate? (cons '(1 2 3) z))) ;#t
(newline)
(display (circulate? (list 'a 'a 'a))) ;#f
(newline)
(newline)

(define l1 (list 'a 'b 'c))
(define l2 (list 'a 'b 'c))
(set-cdr! (cdr (cdr l2)) l2)
(define l3 (list 'a 'b 'c 'd 'e))
(set-cdr! (cdddr l3) (cdr l3))
(define l4 (list 'a 'b 'c 'd 'e))
(set-car! (cdddr l4) (cddr l4))
;
(circulate? l1)
;#f

(circulate? l2)
;#t

(circulate? l3)
;#t

(circulate? l4)
;#f
