#lang racket
(require sicp)
(require racket/trace)
;15:46->15:48
;15:56->16:14
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
        ((= x (car set)) set)
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
(display (element-of-set? 1 '(2 3 4)))
(newline)
(display (element-of-set? 5 '(2 4 6 9)))
(newline)
(display (element-of-set? 6 '(2 4 6 9)))
(newline)
(display (adjoin-set 1 '(2 3 4)))
(newline)
(display (adjoin-set 5 '(2 4 6 9)))
(newline)
(display (adjoin-set 6 '(2 4 6 9)))
(newline)

(display (intersection-set '(1 3 5 7) '(1 2 3 4 5)))
