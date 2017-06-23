(define (cube x) (* x x x))
(define (p x) (- (* 3 x) (* 4 (cube x))))
(define (sine angle)
  (if (not (> (abs angle) 0.1))
      angle
      (p (sine (/ angle 3.0)))
      )
  )
(use slib)
(require 'trace)
(trace p)
(print (sine 12.15))
(print (sine (/ 3.14 6.0)))
;;再帰はa/3^nが0.1以下になるまで行われる。
;;その等式を解くと、log(3)(10*a)<=n
;;この式において、再帰は分岐しないので、
;;再帰の深さがそのまま時間・空間計算量となる
;;故ににΘ = log(a)
;;you are right!!!!!!!!!!!!!!!!
