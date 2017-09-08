#lang racket/load
(require racket/trace)
(require sicp)
(require "2_2/hojo.rkt")

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

;(newline)
;(define start2 (runtime))
;(display (length (queens2 8)))
;(newline)
;(display (- (runtime) start2))

;通常版→queen-cols*8
;失敗版→queen-cols呼び出し 8**7
;オーダーは8**6*T？
;(失敗版の計算量)
;8*(queen-cols 7)
;= 8* 8* (queen-cols 6)
;=…
;=8**8*(queen-cols 0)
;(通常版の計算量)
;= 8**2(queen-cols 0)
