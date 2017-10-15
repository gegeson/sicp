#lang debug racket
(require sicp)
(require racket/trace)
;17:31->17:56,
;+3m
;+10m
;+16m
;にっちもさっちも行かないので答えを見た。
;全部は理解できてない。
;答えを見たのに関わらず。
;一番正確（l4でも#fを返す）な解答はSerendipさんのものだった。
;http://www.serendip.ws/archives/1305
;明日、これを徹底的に理解する。
(define (check-loop lst)
  (define checked-lst nil)
  (define (check-lst lst)
    (cond
      [(memq lst checked-lst) #t]
      [else (begin (set! checked-lst (cons lst checked-lst)) #f)]
      )
    )
  (define (sub lst)
    (cond
      [(null? lst) #f]
      [(not (pair? lst)) #f]
      [else (if (check-lst (car lst))
         #t
        (sub (cdr lst)))
       ]
      ))
  (sub lst)
  )

(define (circulate? items)
  (define walks '())
  (define (has-circulate? x)
    (if (memq x walks)
        #t
        (begin (set! walks (cons x walks)) #f)))
  (define (circulate?-iter i)
    (if (not (pair? i))
        #f
        (if (has-circulate? (car i))
            #t
            (circulate?-iter (cdr i)))))
  (circulate?-iter items))



(define (last-pair x)
  (if (null? (cdr x))
      x
    (last-pair (cdr x)))
  )
(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)
(define z (make-cycle (list 'a 'b 'c)))
;(display (circulate? z)) ;#t
;(newline)
;(display (circulate? (list 'a 'b 'c))) ;#f
;(newline)
;(display (circulate? nil)) ;#f
;(newline)
;(display (circulate? (cons z '(1 2 3)))) ;#t
;(newline)
;(display (circulate? (cons '(1 2 3) z))) ;#t
;(newline)
;(display (circulate? (list 'a 'a 'a))) ;#fになってるので、前より前に進んだ。
;(newline)
;(newline)

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
