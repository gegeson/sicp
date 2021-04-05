#lang racket
(require racket/trace)
(require sicp)
;9:03->9:19
(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))


(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))


(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low (enumerate-interval (+ low 1) high))))

(define (unique-pairs n)
  (flatmap (lambda (i) (map (lambda (j)
                              (if (< j i)
                              (list i j)
                                nil)) (enumerate-interval 1 (- i 1)))) (enumerate-interval 1 n)))
(define (unique-trines n)
  (flatmap (lambda (i)
    (flatmap (lambda (j)
      (map (lambda (k)
        (list k j i)
          )
        (enumerate-interval 1 (- j 1))))
      (enumerate-interval 1 (- i 1))))
    (enumerate-interval 1 n)))
(display (unique-trines 3))
;;; for i in 1..n:
;;;   for j in 1..i-1:
;;;     for k in 1..j-1:
;;;       print(k, j, i)
;;; iが1~5
;;; jは1~4
;;; kは1~3
;;; iが1->i-1=0なので、ループが回らない
;;; jが1->j-1=0なので、ループが回らない
;;; つまり、
;;; 最低でもiが3, jが2の時初めてループが回る
;;; iが3なら、jは1か2で、1は除外で2なので、kは1
;;; このパターンだけが許容されるので、(1, 2, 3)が出力される
;;; iが4なら、jは2か3で、2の時(1, 2, 3)
;;; 3の時、kは1か2なので、(1, 3, 4)と(2, 3, 4)が追加されて出力される
(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))

(define (sum-eq-n trines sum)
    (filter
      (lambda (trine)
        (equal? (+ (car trine) (cadr trine) (caddr trine)) sum))
        trines))
(newline)
(display (sum-eq-n (unique-trines 5) 8))
(newline)
(display (sum-eq-n (unique-trines 6) 9))
