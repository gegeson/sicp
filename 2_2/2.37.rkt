#lang racket
(require racket/trace)
(require sicp)
; 23:18->23:42
(define (accumulate op initial sequence)
  (if (null? sequence)
    initial
    (op (car sequence)
        (accumulate op initial (cdr sequence)))))
(define (accumulate-n op init seqs)
  (if (null? (car seqs))
    nil
    (cons (accumulate op init (map car seqs))
          (accumulate-n op init (map cdr seqs)))))

(define (dot-product v w)
  (accumulate + 0 (map * v w)))

(define (matrix-*-vector m v)
  (map (lambda (m_i) (dot-product m_i v)) m))

(define m '((1 2 3 4) (4 5 6 6) (6 7 8 9)))
(define n '((1 2) (3 4)))
(display (matrix-*-vector m '(1 2 3 4)))
(define (transpose mat)
  (accumulate-n cons nil mat))
(newline)
(display (transpose n))
(newline)
(display (transpose m))

(define (matrix-*-matrix m n)
    (let ((n_t (transpose n)))
        (map (lambda (m_i) (matrix-*-vector n_t m_i)) m)
      )
  )
(newline)
(display (matrix-*-matrix n n))
