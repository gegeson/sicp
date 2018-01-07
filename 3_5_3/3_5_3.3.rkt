#lang racket/load
(require sicp)
(require (prefix-in strm: racket/stream))
(require "3_5_3/stream.rkt")
; 21:01->21:26
(define (integral integrand initial-value dt)
  (define int
    (cons-stream initial-value
                 (add-streams (scale-stream integrand dt)
                             int)))
  int)

; S_i = C + Σx_j*dt
; は、S = S_1, S_2, S_3, …
; のiの値のことか。

; integrand を 1, 2, 3, 4, …とすると、
; int は
;
; C, 1*dt, 2*dt, 3*dt, 4*dt  …
;       C, 1*dt, 2*dt, 3*dt, …
;             C, 1*dt, 2*dt, …
;
; これらを縦に足したものがintの結果になる、はず。読んだ限りでは。
;

(define (stream-head s n)
  (define (iter s n)
    (if (<= n 0)
      'done
      (begin
        (display (stream-car s))
        (newline)
        (iter (stream-cdr s) (- n 1)))))
  (iter s n))

(stream-head (integral integers 0 1) 10)

; この検証結果を見た限りでも合ってるっぽい。
; この場合partial-sumと同じ結果になるべきだが、実際そうなっている。
; これが実際に積分になるには、integrand が　dt幅で変化する関数である必要があると思う。
; ついでにdtは十分狭い必要がある。だから結構実例でテストするのは難しい気がする。
