#lang racket
(require racket/trace)
(require sicp)
; 10:02->10:29
; 10:30->10:44
(define (cons_all a)
  (lambda (set)
          (cond
            ((null? set) (cons nil nil))
            (else (cons (cons a (car set)) ((cons_all a) (cdr set)))))))


(display ((cons_all 1) '(() (2) (3) (2 3))))
(newline)
(define (map f lst)
  (if (null? lst)
    nil
    (cons (f (car lst)) (map f (cdr lst))))
  )
(define (subsets s)
  (if (null? s)
    (list nil)
    (let ((rest (subsets (cdr s))))
      (append rest (map (lambda (set)
                                (cons (car s) set)) rest))
      )))
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

(display (subsets '(1 2 3)))
(newline)
(display (length (subsets '(1 2 3 4 5 6))))
(newline)
(display (is_duplicate_none (subsets '(1 2 3 4 5 6))))
(newline)
;解説
;letで作るrestは、(1 2 3)で言うなら(2 3)の冪集合である
;(2 3)のべき集合のそれぞれの要素に対して1を追加したものと(2 3)の冪集合を結合したものが(1 2 3)の冪集合である。
;mapを使用してこの操作を行う場合、集合を受け取り、sの先頭要素を集合に加えていく、という関数をmapに渡してやれば良い。
