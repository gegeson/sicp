#lang racket
(require racket/trace)
(require sicp)
; 21:32->22:54
; -11

(define (count-leaves x)
  (cond
    ((null? x) 0)
    ((not (pair? (car x))) (+ 1 (count-leaves (cdr x))))
    (else
     (+ (count-leaves (car x)) (count-leaves (cdr x))))
    )
  )

(define (enumerate-tree tree)
  (cond
    ((null? tree) nil)
    ((not (pair? tree)) (list tree))
    (else
     (append (enumerate-tree (car tree)) (enumerate-tree (cdr tree))))
    ))

(define (accumulate op initial sequence)
  (if (null? sequence)
    initial
    (op (car sequence)
        (accumulate op initial (cdr sequence)))))


;(define (f tree)
;  (cond ((null? tree) nil)
;    ((not (pair? tree)) (list tree))
;    (else
;      (append (f (car tree)) (f (cdr tree)))
;     )
;    )
;  )

(define (f t)
  (cond
    ((null? t) nil)
    ((not (pair? t)) (list t))
    (else (append (f (car t)) (f (cdr t))))
    ))

;これと上のfは自分で書いたもの。
;間違いではなく、正しく動くが、明らかに出題者の意図とは違う。
(define (count-leaves2 t)
  (accumulate
   (lambda (x y)
           (+ (length x) y)) 0 (map f t)))


;ググって出てきた模範解答。
;mapの中で再帰は不可能ではないか？と思っていて選択肢から除外していたが、
;よく考えれば条件分岐をmapに渡す関数に入れてやれば普通に可能である。
(define (count-leaves3 t)
  (accumulate + 0
              (map (lambda (t)
                           (cond ((null? t) 0)
                             ((not (pair? t)) 1)
                             (else (count-leaves3 t)))) t))
  )
(trace count-leaves3)

(display (list 1 (list 2 (list 3 4))))
(newline)
(display (f (cons (list 1 2) (list 3 4))))
(newline)
(newline)
(display (map append (cons (list 1 2) (list 3 4))))
(newline)
(display (count-leaves (list 1 2 (list 1 2))))
(newline)
(display (count-leaves (cons (list 1 2) (list 1 2))))
(newline)
(display (count-leaves (list 1 2 (list 1 2) (list 2 3 (list 3 4 5)) (list 1 2))))
(newline)
(display (count-leaves (cons (list 1 2) (list 1 2))))
(newline)
(display (count-leaves2 (list 1 2 (list 1 2))))
(newline)
(display (count-leaves2 (cons (list 1 2) (list 1 2))))
(newline)
(display (count-leaves2 (list 1 2 (list 1 2) (list 2 3 (list 3 4 5)) (list 1 2))))
(newline)
(display (count-leaves3 (list 1 2 (list 1 2))))
(newline)
(display (count-leaves3 (cons (list 1 2) (list 1 2))))
(newline)
(display (count-leaves3 (list 1 2 (list 1 2) (list 2 3 (list 3 4 5)) (list 1 2))))
(newline)

(display (list 1 2 (list 1 2) (list 2 3 (list 3 4 5)) (list 1 2)))
(newline)
(display (map f (list 1 2 (list 1 2) (list 2 3 (list 3 4 5)) (list 1 2))))
