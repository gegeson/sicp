#lang racket
(require sicp)
(require racket/trace)
;15:46->15:48
;15:56->16:14 2.61

;2.62
;16:15->16:25

(define (element-of-set? x set)
  (cond
      ((null? set) #f)
      ((equal? x (car set)) #t)
      ((< x (car set)) #f)
      (else
        (element-of-set? x (cdr set))
       )
    )
  )
;必ずしも全体を走査する必要がなく、
;最初で終わることも最後で終わることもあり得るので、
;オーダーは非整列済み版の半分
(define (adjoin-set x set)
    (cond
        ((null? set) (cons x nil))
        ((< x (car set)) (cons x set))
        (else
         (cons (car set) (adjoin-set x (cdr set)))
         )
      )
  )
(define (intersection-set set1 set2)
    (cond
        ((or (null? set1) (null? set2))
         nil)
         ((equal? (car set1) (car set2))
          (cons (car set1) (intersection-set (cdr set1) (cdr set2))))
          ((> (car set1) (car set2))
           (intersection-set set1 (cdr set2)))
           (else
             (intersection-set (cdr set1) set2)
            )
      )
  )
;各ループでは先頭だけを調べ、
;かつ、必ず次のループで一つ以上集合が小さくなるので、
;オーダーはO(n)
(define (union-set set1 set2)
    (cond
        ((or (null? set1) (null? set2)) (append set1 set2))
        ((equal? (car set1) (car set2))
         (cons (car set1) (union-set (cdr set1) (cdr set2))))
         ((< (car set1) (car set2))
          (cons (car set1) (union-set (cdr set1) set2)))
          ((> (car set1) (car set2))
           (cons (car set2) (union-set set1 (cdr set2))))
      )
  )

(display (intersection-set '(1 3 5 7) '(1 2 3 4 5)))
(newline)
(display (union-set '(1 3 5 7) '(1 2 3 4 5)))
(newline)
(display (union-set '(1 3 5 7) '(2 4 5 6 8)))
(newline)
(display (union-set '(0 1 9 10) '(2 5 6 7 9)))
