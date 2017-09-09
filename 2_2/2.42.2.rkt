#lang racket/load
(require racket/trace)
(require sicp)
; 12:52->13:19
(require "2_2/hojo.rkt")

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
  (define start1 (runtime))
  (display (length (queens 8)))
  (newline)
  (display (- (runtime) start1))

(define (queens2 board-size)
  (define (queen-cols k)
    (if (= k 0)
        (list empty-board)
        (filter
         (lambda (positions) (safe? k positions))
         (flatmap
	  (lambda (new-row)
	    (map (lambda (rest-of-queens)
		   (adjoin-position new-row k rest-of-queens))
		 (queen-cols (- k 1))))
	  (enumerate-interval 1 board-size)))))
  (queen-cols board-size))

(newline)
(define start2 (runtime))
(display (length (queens2 8)))
(newline)
(display (- (runtime) start2))
