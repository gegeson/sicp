#lang racket
(require racket/trace)
(require sicp)
; 9:39->10:42
; 10:49->11:03

;2.43
;11:08->

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

(define (adjoin-position new-row k rest)
  (append rest (list new-row)))

(define (index lst)
  (define (index-iter i lst)
    (if (null? lst)
         nil
         (cons (cons i (car lst)) (index-iter (+ i 1) (cdr lst))))

    )
  (index-iter 1 lst)
  )
(display (index '(1 4)))
(newline)
(define (ret_last lst)
  (if (null? (cdr lst))
    lst
    (ret_last (cdr lst)))
  )
(define (ret_not_last lst)
  (if (null? (cdr lst))
      nil
    (cons (car lst) (ret_not_last (cdr lst)))
    )
  )

(define (_safe? k positions)
(cond
  ((null? (cdr positions)) true)
  (else
  (let ((xy_s (index positions)))
    (let ((xy_s_p (ret_not_last xy_s)) (xy_s_k (ret_last xy_s)))
      (let ((x-y (- (caar xy_s_k) (cdar xy_s_k)))
            (x+y (+ (caar xy_s_k) (cdar xy_s_k)))
            (x-y_p (- (caar xy_s_p) (cdar xy_s_p)))
            (x+y_p (+ (caar xy_s_p) (cdar xy_s_p))))
             (and (not (equal? x-y x-y_p)) (not (equal? x+y x+y_p))
                  (_safe? k (cdr positions)))
             )
            )
        )
      )
  )
)
(define (is_duplicate_none lst)
  (define (is_not_duplicate a lst)
    (cond ((null? lst) true)
      (else (and (not (equal? a (car lst))) (is_not_duplicate a (cdr lst))))
      )
    )
  (cond
    ((null? lst) true)
    (else
      (and (is_not_duplicate (car lst) (cdr lst)) (is_duplicate_none (cdr lst)))
     )
    )
  )
(define (safe? k positions)
  (and (is_duplicate_none positions) (_safe? k positions)))

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
