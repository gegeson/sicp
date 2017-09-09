(define (expmod base exp m) (remainder (fast-expt base exp) m))

とすると、baseがとても大きな数だった場合、
とても大きな数^exp乗をまず計算してから、それのmで割ったあまりを求めることになる。
一般に、とても大きな数をべき乗すると非常に大きな数になり、
非常に大きな数の掛け算は時間がかかり、非効率的である。
一方、

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m)) m))
         (else
           (remainder
             (* base (expmod base (- exp 1) m) m)
            )
          )
    ))

は、常に小さな数のmodをまず求めてから掛け算を行うようにしている。
これによって大きな数同士をかけることがなくなるため、計算量は改善される。
