; 10:46->10:58
; 11:22->11:24
; 11:26->11:44
; 12:04->12:22
359pに誤訳発見
「n は素数であるか (その場合、n を割り切る素数がすでに生成されています)、素数であるか」
は
「n は素数で"ない"か (その場合、n を割り切る素数がすでに生成されています)、素数であるか」
だと思われ（和田版でもそうなっていた）

むっずい！でも面白い。まったく新しいパラダイムに出会ったみたいな気分。

(define (sieve stream)
  (cons-stream
   (stream-car stream)
   (sieve (stream-filter
           (lambda (x)
                   (not (divisible? x (stream-car stream))))
           (stream-cdr stream)))))
(define primes (sieve integers-starting-from 2))

(define (add-streams s1 s2) (stream-map + s1 s2))

(define integers
  (cons-stream 1 (add-streams ones integers)))

(define fibs
  (cons-stream
   0
   (cons-stream 1 (add-streams (stream-cdr fibs) fibs))))

(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor))
              stream))

(define double (cons-stream 1 (scale-stream double 2)))

(define primes
  (cons-stream
   2
   (stream-filter prime? integers-starting-from 3)))

ここの注意点。
prime?はprimesがある程度素数を生成しているという前提に立って動くので、
2の素数性については判定できないし、そもそもprimesと分けて単体で使えるものではない。

(define (prime? n)
  (define (iter ps)
    (cond ((> (square (stream-car ps)) n) true)
      ((divisible? n (stream-car ps)) false)
      (else
       (iter (stream-cdr ps)))))
  (iter primes))
