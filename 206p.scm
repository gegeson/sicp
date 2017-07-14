(define-syntax cons-stream (
  syntax-rules () ((_ a b) (cons a (delay b)))))
(define the-empty-stream '())
(define (stream-car stream) (car stream))
(define (stream-cdr stream) (force (cdr stream)))
(define (stream-null? stream) (null? stream))
(define (add-streams s1 s2) (stream-map + s1 s2))
(define (stream-ref s n)
  (if (= n 0)
    (stream-car s)
    (stream-ref (stream-cdr s) (- n 1))))
(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
    the-empty-stream
    (cons-stream
      (apply proc (map stream-car argstreams))
      (apply stream-map
        (cons proc (map stream-cdr argstreams))))))
(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))
(define (integral delay-integrand initial-value dt)
  (define int
    (cons-stream initial-value
      (let ((integrand (force delay-integrand)))
        (add-streams 
          (scale-stream integrand dt)
          int))))
  int)
(define (solve f y0 dt)
  (letrec
      ((y (integral (delay dy) y0 dt))
      (dy (stream-map f y)))
    y))
; (define (solve f y0 dt)
;   (define y (integral (delay dy) y0 dt))
;   (define dy (stream-map f y))
;   y)
; (define (solve f y0 dt)
;   (letrec
;       ((y (integral (delay dy) y0 dt))
;       (dy (stream-map f y)))
;     y))
(print (stream-ref (solve (lambda (y) y) 1 0.001) 1000))