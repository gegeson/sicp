20:17->20:28

(controller
 test-b
   (test (op =) (reg b) (const 0))
   (branch (label gcd-done))
   (assign t (op rem) (reg a) (reg b))
   (assign a (reg b))
   (assign b (reg t))
   (goto (label test-b))
 gcd-done)

(define (factorial n)
 (define (iter product counter)
   (if (> counter n)
       product
       (iter (* counter product)
             (+ counter 1))))
 (iter 1 1))
---
上2つとfactorialの図を見ながら、部品から書いた
ググった所、nが(const n)じゃなくて(reg n)っぽい。
でも他は同じ。ほぼ正解でしょ。

(controller
   (assign (reg p) (const 1))
   (assign (reg c) (const 1))
   test-b
   (test (op >) (reg c) (const n))
   (branch (label factorial-done))
   (assign p (op *) (reg p) (const c))
   (assign c (op +) (reg c) (const 1))
   (goto (label test-b))
  factorial-done)
