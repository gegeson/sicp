#lang debug racket
(require sicp)
(require racket/trace)

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

    (define l1 (list 'a 'b 'c))
    (define l2 (list 'a 'b 'c))
    (set-cdr! (cdr (cdr l2)) l2)
    (define l3 (list 'a 'b 'c 'd 'e))
    (set-cdr! (cdddr l3) (cdr l3))
    (define l4 (list 'a 'b 'c 'd 'e))
    (set-car! (cdddr l4) (cddr l4))

    (circulate? l1)
    ;#f

    (circulate? l2)
    ;#t

    (circulate? l3)
    ;#t

    (circulate? l4)
    ;#f
