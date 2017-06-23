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
    (= (expmod a n n) a))
  (try-it (+ 1 (random-integer (- n 1)))
          ))

(define (fast-prime? n times)
  (cond ((= times 0) #t)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else #f)))


(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (fast-prime? n 10)
      (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))


(timed-prime-test 2)
(timed-prime-test 3)
(timed-prime-test 4)
(timed-prime-test 5)
(timed-prime-test 6)
(timed-prime-test 7)
(timed-prime-test 33)
(timed-prime-test 41)
(timed-prime-test 52)
(timed-prime-test 63)
(timed-prime-test 71)

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

(random-time 1009 (runtime))
(random-time 1013 (runtime))
(random-time 1019 (runtime))
(random-time 10007 (runtime))
(random-time 10009 (runtime))
(random-time 10037 (runtime))
(random-time 100003 (runtime))
(random-time 100019 (runtime))
(random-time 100043 (runtime))
(random-time 1000003 (runtime))
(random-time 1000033 (runtime))
(random-time 1000037 (runtime))
;;IOにはおよそ15単位時間かかる。
;;また、1000と10000、1000と100000、1000と1000000の比は、それぞれ
;;1.33, 1.66, 2.0
;;である。
;;これらをすべて踏まえると、
;;(time-1000 - 15)*1.33 + 15 = time-10000
;;(time-1000 - 15)*1.66 + 15 = time-100000
;;(time-1000 - 15)*2.00 + 15 = time-1000000
;;が成り立つ。これは実験結果にある程度一致している。
