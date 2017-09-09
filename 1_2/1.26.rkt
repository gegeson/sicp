

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

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (* (expmod base (/ exp 2) m)
                       (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))
racketは適用順序評価であるため、
まず引数を計算してから簡約を行う。
一般に、
(square (f x))
(* (f x) (f x))とで何が違うのか。
前者では、まず(f x)を計算し、その後その結果を二乗する。
後者では、2つある(f x)を二回別々に計算してから、その結果を二乗する。
つまり、ワンステップごとに計算量は二倍になる。
expmodでは、再帰の深さがlog(exp)であるが、
後者では再帰のそれぞれのステップについて2倍道が増えるため、
ステップ数は2^log(exp) = expとなる。
