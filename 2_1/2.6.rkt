#lang racket
(require racket/trace)

(define zero (lambda (f) (lambda (x) x)))
(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))

;zero
;f -> (x -> x)
;add-1
;n -> (f -> (x -> (f ((n f) x))))
;
;(add-1 zero)
;= (f -> (x -> (f ((x -> x) x))))
;= (f -> (x -> (f ((x -> x) x))))
;= (f -> (x -> (f (x))))
(define one (lambda (f) (lambda (x) (f x))))
;(add-1 one)
;= (f -> (x -> (f ((x -> (f x) x)))))
;= (f -> (x -> (f (f x))))
(define two (lambda (f) (lambda (x) (f (f x)))))

;このテスト関数はググった
(define (inc n)
  (+ n 1))
(define (to-s z)
  ((z inc) 0))

(to-s one) ; 1
(to-s two) ; 2

(define (plus a b)
  (lambda (f)
    (lambda (x)
            ((a f) ((b f) x))
            )
          )
  )
  (define (plus2 a b)
    (lambda (f)
      (lambda (x)
              ((a f) ((b f) x))
              )
            )
    )

(to-s (plus (plus two two) (plus one two))) ; 7
(to-s (plus zero zero))
;plusの考え方と展開図
;oneは f -> (x -> (f x))
;twoは f -> (x -> (f (f x)))
;ここから
;f -> (x -> (f (f (f x))))
;を作り出したい。
;つまり、
;まずは、oneとtwoに「エサ」になるfを食べさせて
;外側に近付けてやる必要がある
;つまり、
;(one f)
;= x -> (f x)
;(two f)
;= x -> (f (f x))
;見ると、
;(one f) (two f)
;とすればいいのでは？と思うが、ちょっと違う。
;なぜなら、そうすると
;(one f) (two f)だと、
;f (x-> f (f x))
;になってしまう。失敗。
;でもよく見るとこれ、ほぼ目的の形に近い。
;もしf()の内側の　x-> f (f x)　にxを渡してやれば、
;そのまま完成形になる。
;この内側とは、(two f)のことだった。
;つまり、((two f) x)とした上ではどうだろう
;((two f) x)は
;(f (f x))である。
;これを(one f)に渡すと？
; (x -> (f x)) (f (f x))
; = (f (f (f x)))
;目的にたどり着いた。
;f, xが必要なので、plusのラムダの引数としてf, xを与えてやる事を考えて、
;f -> (x -> (one f) ((two f) x))
;one, twoを一般にa, bとして、引数として表記してやると
;(a -> (b -> (f -> (x -> (one f) ((two f) x)))))
;正確には、
;(one f)に(f (f x))を渡してやる必要がある。
;つまり、
;(one f) ((two f) x)
;である。
;これを式にすると、one, twoをa, bとして
;a, b -> (f -> (x -> (a f) ((b f) x)))
;すなわち
;(define (plus a b)
;  (lambda (f)
;    (lambda (x)
;            ((a f) ((b f) x)))))
