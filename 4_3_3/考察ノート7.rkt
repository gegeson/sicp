今度これやってみよう

(define (require p)
  (if (not p) (amb)))

(define x false)
(define y false)

(begin
  (set! x (amb 0 1))
  (set! y (amb 0 1))
  (set! x (+ x 1))
  (require (= x 2))
  (x y))
