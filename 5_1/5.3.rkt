20:41->21:04
(define (sqrt x)
  (define (good-enough? guess)
    (< (abs (- (square guess) x)) 0.001))
  (define (improve guess)
    (average guess (/ x guess)))
  (define (sqrt-iter guess)
    (if (good-enough? guess)
        guess
        (sqrt-iter (improve guess))))
  (sqrt-iter 1.0))

バージョン1がこれ
(controller
 (assign (reg g) (const 1.0))
 test-sqrt
 (test (op good-enough?) (reg g) (reg x))
 (branch (label sqrt-done))
 (assign (reg g) (op improve) (reg g) (reg x))
 (goto (label test-sqrt))
 sqrt-done)
---
good-enough?を記述してみる。
(test
 (assign g (op *) (reg g) (reg g))
 (assign g (op -) (reg g) (reg x))
 (test (op >) (reg g) (const 0))
 (branch (label plus))
 (assign (reg g) (op *) (const -1) (reg g))
 plus
 (test (op <) (reg g) (const 0.001))
 )
---
improveを記述してみる。
(test
 (assign t (reg g))
 (assign g (op /) (reg x) (reg g))
 (assign g (op +) (reg t) (reg g))
 (assign g (op /) (reg g) (const 2))
 )
---
組み合わせるだけで行けるはず…
(controller
 (assign (reg g) (const 1.0))
 test-sqrt

 (assign g (op *) (reg g) (reg g))
 (assign g (op -) (reg g) (reg x))
 (test (op >) (reg g) (const 0))
 (branch (label plus))
 (assign (reg g) (op *) (const -1) (reg g))
 plus
 (test (op <) (reg g) (const 0.001))

 (branch (label sqrt-done))
 (assign t (reg g))

 (assign g (op /) (reg x) (reg g))
 (assign g (op +) (reg t) (reg g))
 (assign g (op /) (reg g) (const 2))

 (goto (label test-sqrt))
 sqrt-done)

図は、バージョン1のデータパス図だけ書いた。合ってた
多分合ってるだろうから検証無しで次へ。
