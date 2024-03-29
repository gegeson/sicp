#lang racket
(require racket/trace)
(require sicp)
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
(display (ret_last '(1 2 3)))
(newline)
(display (ret_not_last '(1 2 3)))
(newline)

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
;(trace safe?)
(display (caar (ret_not_last (index '(1 4 1)))))
(newline)
(display (cdar (ret_not_last (index '(1 4 1)))))
(newline)
(display (safe? 3 '(1 4 1)))
(newline)
(display (safe? 3 '(1 4 2)))
(newline)
(display (safe? 3 '(1 4 3)))
(newline)
(display (safe? 3 '(1 4 4)))

(newline)
(display (safe? 4 '(3 7 2 1)))
(newline)
(display (safe? 4 '(3 7 2 2)))
(newline)
(display (safe? 4 '(3 7 2 3)))
(newline)
(display (safe? 4 '(3 7 2 4)))
(newline)
(display (safe? 4 '(3 7 2 5)))
(newline)
(display (safe? 4 '(3 7 2 6)))
(newline)
(display (safe? 4 '(3 7 2 7)))
(newline)
(display (safe? 4 '(3 7 2 8)))
