#lang debug racket
(require sicp)
(require racket/trace)
;方針（アルゴリズム）だけググって、あとは実装してみる。
;http://hidekazu.hatenablog.jp/entry/2016/04/01/204153
;cdr、cddrと一つずれて進むポインタを用意し、二つが一致したらループと判定。
;16:37->16:49

(define (circulate? x)
  (define (r-t rabbit turtle)
    (cond
      [(or (not (pair? rabbit)) (not (pair? turtle))) #f]
      [(or (null? (cdr rabbit)) (null? (cddr rabbit))) #f]
      [(or (null? (cdr turtle)) (null? (cddr turtle))) #f]
      [(eq? rabbit turtle) #t]
      [else
       (r-t (cdr rabbit) (cddr turtle))
       ])

    )
  (cond
    [(not (pair? x)) #f]
    [(or (null? (cdr x)) (null? (cddr x))) #f]
    [else
     (r-t (cdr x) (cddr x))
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
