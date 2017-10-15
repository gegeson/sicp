#lang debug racket
(require sicp)
(require racket/trace)
;方針（アルゴリズム）だけググって、あとは実装してみる。
;http://hidekazu.hatenablog.jp/entry/2016/04/01/204153
;cdr、cddrと一つずれて進むポインタを用意し、二つが一致したらループと判定。
;あっさりできたー
;(10m)
;
(define (circulate? x)
  (define (iter turtle rabbit)
  (cond
    [(eq? turtle rabbit) #t]
    [(or (null? turtle) (null? rabbit)) #f]
    [(or (null? (cdr turtle)) (null? (cdr rabbit))) #f]
    [(or (null? (cddr turtle)) (null? (cddr rabbit))) #f]
    [else
     (iter (cdr turtle) (cddr rabbit))
     ]
    )
    )
  (cond
    [(null? x) #f]
    [(null? (cdr x)) #f]
    [(null? (cddr x)) #f]
    [else
     (iter (cdr x) (cddr x))
     ]
    )
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
