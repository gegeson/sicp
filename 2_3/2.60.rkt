#lang racket
(require sicp)
(require racket/trace)
;22:13->22:37
;和集合だけ超スピードなので、和集合を求める操作をよく使うならこっちがいい
;→adjoinもO(1)でした。伏兵 （参照 http://d.hatena.ne.jp/ohyajapan/20090120/p2
;O(n)
(define (element-of-set? x set)
    (cond
        ((null? set) #f)
        ((equal? (car set) x) #t)
        (else
          (element-of-set? x (cdr set))
         )
      )
  )

;O(n)->ちげえ！即consでいいんだよ
;(define (adjoin-set x set)
;    (if (element-of-set? x set)
;      set
;      (cons x set))
;  )

;O(1)
(define (adjoin-set x set) (cons x set))

;O(1)
(define (union-set set1 set2)
    (append set1 set2)
  )
;O(n^2)
;↓オーダー変わらないけど無駄が多い
;(define (intersection-set set1 set2)
;    (define (iter set1 set2)
;        (cond
;            ((or (null? set1) (null? set2)) nil)
;            ((element-of-set? (car set1) set2)
;              (cons (car set1) (iter (cdr set1) set2))
;             )
;          (else
;            (iter (cdr set1) set2)
;           )
;          )
;      )
;  (append (iter set1 set2) (iter set2 set1))
;  )
;こっちで十分
(define (intersection-set set1 set2)
    (cond
      ((or (null? set1) (null? set2)) nil)
      ((element-of-set? (car set1) set2)
          (cons (car set1) (intersection-set (cdr set1) set2)))
      (else (intersection-set (cdr set1) set2))
  ))

(display (union-set '(1 2 3) '(3 4 5)))
(newline)
(display (intersection-set '(1 2 3) '(3 4 5)))
(newline)
(display (intersection-set '(1 4 1 3 5 6 3 4) '(2 3 5 1 2 3 4 7 5)))
