#lang debug racket
(require sicp)
(require racket/trace)
;3m
z1ではcar cdrが同じリストを指しているので、
set-to-wow!でcarのcar, cdrのcdr両方が変化する
z2ではcar とcdr が別々で、
car, cdrの二つのリストが同じ'a 'bを指しているという状態。
set-to-wow!によって変更されるのは、carの方のリストのcarが何を指すか、
という情報なので、
set-to-wow!によって変化するのは(car z2)だけになる。

(define x (list 'a 'b))
(define z1 (cons x x))
(define z2 (cons (list 'a 'b) (list 'a 'b)))
(define (set-to-wow! x) (set-car! (car x) 'wow) x)
(set-to-wow! z1)
(display z1)
(newline)
(set-to-wow! z2)
(newline)
(display z2)
