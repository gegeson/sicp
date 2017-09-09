#lang racket
(require racket/trace)
(require sicp)
; 7:23-> 7:41

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
(display (fold-right / 1 (list 1 2 3)))
(newline)
(display (fold-left / 1 (list 1 2 3)))
(newline)
(display (fold-right list nil (list 1 2 3)))
(newline)
(display (fold-left list nil (list 1 2 3)))
(newline)
(display (fold-right list nil (list 1 2 3)))
(newline)
(display (fold-left list nil (list 1 2 3)))
(newline)
;(op a_1 (op a_2 (op (a_3 initial)))) = (op' (op' (op' a_1 initial) a_2) a_3)
;であれば良い
;数式で書くと
;(((a_1 + i) + a_2) + a_3) = (a_1 * (a_2 * (a_3 * i)))
;これが成り立つには、計算の順序によって結果が変わらない演算子であれば良い
