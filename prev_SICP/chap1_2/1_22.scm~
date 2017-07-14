(define (runtime)
    (use srfi-11)
    (let-values (((a b) (sys-gettimeofday)))
      (+ (* a 1000000) b)))

(define (smallest-divisor n) (find-divisor n 2))
(define (find-divisor n test-devisor)
  (cond
   ((> (square test-devisor) n) n)
   ((devides? test-devisor n) test-devisor)
   (else (find-divisor n (+ test-devisor 1)))
   )
  )

(define (devides? a b) (= (remainder b a) 0))

(define (even? n) (= (remainder n 2) 0))
(define (odd? n) (not (= (remainder n 2) 0)))
(define (square n) (* n n))

(define (prime? n)
  (= n (smallest-divisor n))
  )

(define (timed-prime-test n)
  ;;(newline)
  ;;(display n)
  (start-prime-test n (runtime))
  )
(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime n (- (runtime) start-time))
      )
  )
(define (report-prime n elapsed-time)
  (newline)
  (display n)
  (display "***")
  (display elapsed-time)
  )

(define (search-for-primes start-n end-n)
  (cond ((> start-n end-n)
         (newline)
         (display "end"))
        ((even? start-n)
         (search-for-primes (+ start-n 1) end-n)
         )
        (else
         (timed-prime-test start-n)
         (search-for-primes (+ start-n 2) end-n)
         )
   )
  )

(define (search-for-primes-times start-n end-n start-time)
  (search-for-primes start-n end-n)
  (newline)
  (display (- (runtime) start-time))
  (newline)
  )
;;997->8
;;9973->24
;;99991->79
;;999983->246
;;大体ルート10倍ずつである
(search-for-primes 10000 10050)
(search-for-primes 100000 100050)
(search-for-primes 1000000 1000050)
(search-for-primes 100000000 100000500)
(search-for-primes 100000000000 100000000500)

;;(search-for-primes-times 2 100000 (runtime))
