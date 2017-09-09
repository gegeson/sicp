#lang racket
(require racket/trace)
;(a") = (p+q  q)(a)
;(b") = (q    p)(b)
;Tを(p+q  q)
;   (q    p)と置くと、
;T^2 = (p^2+q^2 + q^2 + 2pq, q^2+2pq)
;    = (q^2 + 2pq          , p^2+q^2)
;となる。
;ここで、
;q" = q^2+2pq
;p" = p^2+q^2
;とすると、
;T^2 = (p"+q", q")
;    = (q",    p")
;となる。よって、TとT^2は等価である。

(define (fib n)
  (fib-iter 1 0 0 1 n))
(define (fib-iter a b p q count)
  (cond ((= count 0) b)
      ((even? count)
      (fib-iter
                a
                b
                (+ (* p p) (* q q))
                (+ (* q q) (* 2 p q))
                (/ count 2)))
      (else (fib-iter (+ (* b q) (* a (+ p q))) (+ (* b p) (* a q)) p q (- count 1)))
    ))
(trace fib-iter)
(display (fib 5))
(newline)
(display (fib 10))
