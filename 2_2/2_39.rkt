#lang racket
(require racket/trace)
(require sicp)
; 7:43->7:48

(define (fold-right op initial sequence)
  (if (null? sequence)
    initial
    (op (car sequence)
        (fold-right op initial (cdr sequence)))))

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
      result
      (iter (op result (car rest))
            (cdr rest))))
  (iter initial sequence))

(define (reverse sequence)
  (fold-right (lambda (x y) (append y (cons x nil))) nil sequence))
(display (reverse (list 1 2 3)))
(newline)

(define (reverse2 sequence)
  (fold-left (lambda (x y) (cons y x)) nil sequence))
(display (reverse2 (list 1 2 3)))
(newline)
