#lang debug racket
(require sicp)
(require racket/trace)
;10m
;has-circulateはmemqで訪問済みかを調べ、
;訪問済みなら#t, 訪問済みでないならパンくずリストに追加して#f
;c-iterは、ペアじゃないなら#f
;ペアならhas-circulate?で訪問済みか調べて、訪問済みなら#t,
;訪問済みでないならcdrに進む


(define (circulate? x)
  (define encounterd nil)
  (define (has-circulate? x)
    (if (memq x encounterd)
      #t
      (begin (set! encounterd (cons x encounterd)) #f))
    )
  (define (c-iter x)
    (cond
      [(not (pair? x)) #f]
      [(has-circulate? x) #t]
      [else
       (c-iter (cdr x))
       ]
      )
    )
  (c-iter x)
  )










;
;
;
;
;(define (circulate? x)
;  (define encounterd nil)
;  (define (has-circulate? lst)
;    (cond
;      [(memq lst encounterd) #t]
;      [else (begin (set! encounterd (cons lst encounterd)) #f)]
;      )
;    )
;  (define (c-iter x)
;      (cond
;        [(not (pair? x)) #f]
;        [else
;         (if (has-circulate? x)
;            #t
;           (c-iter (cdr x))
;           )
;         ]
;        )
;    )
;  (c-iter x)
;  )


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
