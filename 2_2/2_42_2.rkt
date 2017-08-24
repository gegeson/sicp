#lang racket
(require racket/trace)
(require sicp)
; 12:52->13:19
(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))

(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low (enumerate-interval (+ low 1) high))))


(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))


(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

(define empty-board nil)

(define (adjoin-position new-row k rest-of-queens)
  (cons new-row rest-of-queens))

(define (safe? k positions)
    (let ((x k) (y (car positions)))
        (define (_safe? i positions)
            (if (= i k)
              true
                (let ((x_p i)
                      (y_p (list-ref positions (- k i))))
                      (cond
                          ((= y y_p) false)
                          ((= (+ x y) (+ x_p y_p)) false)
                          ((= (- x y) (- x_p y_p)) false)
                        (else
                          (_safe? (+ i 1) positions))))))
      (if (null? positions)
        true
        (_safe? 1 positions))))

(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
      (list empty-board)
      (filter
       (lambda (positions) (safe? k positions))
       (flatmap
        (lambda (rest-of-queens)
                (map (lambda (new-row)
                             (adjoin-position
                              new-row k rest-of-queens))
                     (enumerate-interval 1 board-size)))
        (queen-cols (- k 1))))))
  (queen-cols board-size))
(display (queens 4))
(newline)
(display (length (queens 8)))
