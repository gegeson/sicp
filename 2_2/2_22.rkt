#lang racket
(require racket/trace)
(require sicp)
; 18:23->18:50
(define (square x) (* x x))
(define (scale-list items factor)
  (if (null? items)
    nil
    (cons (* (car items) factor)
          (scale-list (cdr items) factor))))
(define (map proc items)
  (if (null? items)
    nil
    (cons (proc (car items))
          (map proc (cdr items))))
  )
(define (square-list items)
  (define (iter things answer)
    (if (null? things)
      answer
      (iter (cdr things)
            (cons (square (car things)) answer))))
    (iter items nil))
;トレースしてみると
;(iter '(1 2 3) '())
;(iter '(2 3) '(1))
;(iter '(3) '(4 1))
;(iter '() '(9 4 1))
;となる
;(car things)をanswerの左側に順々に入れていくと、
;逆になる（当たり前）
(define (square-list2 items)
  (define (iter things answer)
    (if (null? things)
      answer
      (iter (cdr things)
            (cons answer (square (car things))))))
    (iter items nil))
;トレースしていく
; (iter '(1 2 3) '())
; (iter '(2 3) '(().1))
; (iter '(3) '(((). 1). 2)'
; (iter '() '(((). 1). 2). 3)
; ちゃんとしたリストにするには
; (cons 1 (cons 2 (cons 3 nil)))
; という形でconsする必要がある
; 一方、これは
; (cons nil 1)
; (cons (cons nil 1) 4)
; (cons (cons (cons nil 1) 4) 9)
;となっている
;実際、
;(display (cons 1 (cons 4 (cons 9 nil))))
; -> (1 4 9)
;(display (cons (cons (cons nil 1) 4) 9))
; -> (((() . 1) . 4) . 9)
; である。
(display (square-list (list 1 2 3)))
(newline)
(display (square-list2 (list 1 2 3)))
(newline)
(display (cons 1 (cons 4 (cons 9 nil))))
(newline)
(display (cons (cons (cons nil 1) 4) 9))
(newline)
(define (append lst1 lst2)
  (if (null? lst1)
    lst2
    (cons (car lst1) (append (cdr lst1) lst2)))
  )
;appendならうまくいく（ググった）
(define (square-list3 items)
  (define (iter things answer)
    (if (null? things)
      answer
      (iter (cdr things)
            (append answer (list (square (car things)))))))
    (iter items nil))
(display (square-list3 (list 1 2 3)))
