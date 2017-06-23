(use srfi-27)

(define (square x) (* x x))

(define (runtime)
    (use srfi-11)
    (let-values (((a b) (sys-gettimeofday)))
      (+ (* a 1000000) b)))

(define (random-time n start-time)
  (newline)
  (display (+ 1 1))
  ;;(display (random-integer n))
  (newline)
  (display "time is")
  (display (- (runtime) start-time))
  )
(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (fast-prime? n 10)
      (report-prime (- (runtime) start-time))))

(define (timed-remainder-test n m)
  (newline)
  (display n)
  (display "%")
  (display m)
  (start-remainder-test n m (runtime))
  )
(define (start-remainder-test n m start-time)
  (if (> (remainder n m) 0)
      (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))



;; Logarithmic iteration
(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))))

;; fast-prime?

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))        

(define (fermat-test n)
  (define (try-it a)
    (= (expmod2 a n n) a))
  (try-it (+ 1 (random-integer (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) #t)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else #f)))

(define (expmod2 base exp m)
  (remainder (fast-expt base exp) m)
  )
(print (fast-expt 1000 10007))
(print (fast-expt 1000 100003))

(timed-prime-test 1009)
(timed-prime-test 1013)
(timed-prime-test 1019)
(timed-prime-test 10007)
(timed-prime-test 10009)
(timed-prime-test 10037)
(timed-prime-test 100003)
(timed-prime-test 100019)
(timed-prime-test 100043)
(timed-prime-test 1000003)
(timed-prime-test 1000033)
(timed-prime-test 1000037)

;;expmodでは、べき乗を減らすと同時に最終的に
;;a mod nの形にして剰余演算を繰り返すが、
;;expmod2では、同じくべき乗を減らすが最終的な形は
;;a^n mod nとなる
;;後者は非常に遅いが、この違いはmodの計算量によるものと考えられる
;;modに渡す第一項が計算量に影響を与えると仮定し、
;;それをΘ(f(a))とすると、
;;expmodではΘ(log n)*Θ(f(a))となるのに対して、
;;expmod2ではΘ(log n) * Θ(f(a^n))となる
;;f(a)が具体的にどういう形かはわからないが、
;;仮にlog(n)だとしてもn倍の計算量が必要になるため、
;;非常に計算量が大きくなると想定できる。
;;→残念、違いました。
;;a^n を計算するとき、実は巨大な数の掛け算にかなりの計算量を食う。
;;a mod nの繰り返しに置き換えられる場合はそれを上手く避けることが出来る。
;;(nより大きい数は登場しない)
;;そのため掛け算がボトルネックになっていた
