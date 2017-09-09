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
        (list i j k)
          )
        (enumerate-interval 1 (- j 1))))
      (enumerate-interval 1 (- i 1))))
    (enumerate-interval 1 n)))
(display (unique-trines 5))

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
