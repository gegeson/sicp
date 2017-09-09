#lang racket
(require racket/trace)
(require sicp)
;20:39->21:28
(define (filter predicate sequence)
  (cond ((null? sequence) nil)
    ((predicate (car sequence)) (cons (car sequence) (filter predicate (cdr sequence))))
    (else (filter predicate (cdr sequence)))))


(define (accumulate op initial sequence)
  (if (null? sequence)
    initial
    (op (car sequence)
        (accumulate op initial (cdr sequence)))))


(define (_map p sequence)
  (accumulate (lambda (x y) (cons (p x) y)) nil sequence))
(display (_map (lambda (x) (* x 2)) (list 1 2 3)))
(newline)

(define (_append seq1 seq2)
  (accumulate cons seq2 seq1))
(display (_append (list 1 2 3) (list 4 5 6)))
(newline)

(define (_length sequence)
  (accumulate (lambda (x y) (+ 1 y)) 0 sequence))
(display (_length (list 1 2 3 4 5 6)))

(define (enumerate-interval low high)
  (if (> low high)
    nil
    (cons low (enumerate-interval (+ low 1) high))))

(define (enumerate-tree tree)
  (cond
    ((null? tree) nil)
    ((not (pair? tree)) (list tree))
    (else
     (append (enumerate-tree (car tree)) (enumerate-tree (cdr tree))))
    ))
