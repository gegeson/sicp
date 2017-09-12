#lang racket/load
(require sicp)
(require racket/trace)
;13:28->13:41
;お手本
(define (square x) (* x x))
(define (make-from-real-imag x y)
  (define (dispatch op)
    (cond ((eq? op 'real-part) x)
          ((eq? op 'imag-part) y)
          ((eq? op 'magnitude)
           (sqrt (+ (square x) (square y))))
          ((eq? op 'angle) (atan y x))
          (else
           (error "Unknown op -- MAKE-FROM-REAL-IMAG" op))))
  dispatch)

(define (apply-generic op arg) (arg op))
;お手本で実験
(display (apply-generic 'real-part (make-from-real-imag 1 2)))
(newline)
(display (apply-generic 'imag-part (make-from-real-imag 1 2)))
(newline)
(display (apply-generic 'magnitude (make-from-real-imag 3 4)))
(newline)
(display (apply-generic 'angle (make-from-real-imag 2 2)))
(newline)

;ここから問題
(define (make-from-mag-ang r a)
  (define (dispatch op)
    (cond ((eq? op 'real-part) (* r (cos a)))
          ((eq? op 'imag-part) (* r (sin a)))
          ((eq? op 'magnitude) r)
          ((eq? op 'angle) a)
          (else
           (error "Unknown op -- MAKE-FROM-MAG-ANG" op))))
  dispatch)

;実験
(display (apply-generic 'real-part (make-from-mag-ang 2 (/ 3.14 4))))
(newline)
(display (apply-generic 'imag-part (make-from-mag-ang 2 (/ 3.14 4))))
(newline)
(display (apply-generic 'magnitude (make-from-mag-ang 2 (/ 3.14 4))))
(newline)
(display (apply-generic 'angle (make-from-mag-ang 2 (/ 3.14 4))))
(newline)
;合ってる。
