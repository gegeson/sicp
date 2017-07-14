
(define (square x) (* x x))
(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

(define (accumulate combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner (term a) (accumulate combiner null-value term (next a) next b))
      )
  )
(define (accumulate2 combiner null-value term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (combiner (term a) result))
        )
    )
  (iter a null-value)
  )
(define (filtered-accumulate filter combiner null-value term a next b)
  (cond
   ((> a b) null-value)
   ((filter a)
    (combiner (term a) (filtered-accumulate filter combiner null-value term (next a) next b)))
   (else
    (filtered-accumulate filter combiner null-value term (next a) next b)
    )
   )
  )
(define (filtered-accumulate2 filter combiner null-value term a next b)
  (define (iter a result)
    (cond
     ((> a b) result)
     ((filter a)
      (iter (next a) (combiner (term a) result)))
      (else
       (iter (next a) result)
      )
     )
    )
  (iter a null-value)
  )
(define (add1 n) (+ n 1))
(define (identity n) n)

(define (gcd-product n)
  (define (is_gcd_1 i)
    (= (gcd i n) 1)
    )
  (filtered-accumulate is_gcd_1 * 1 identity 1 add1 (- n 1))
  )
(define (prime-sum n)
  (filtered-accumulate prime? + 0 square 1 add1 n)
  )

(define (gcd-product2 n)
  (define (is_gcd_1 i)
    (= (gcd i n) 1)
    )
  (filtered-accumulate2 is_gcd_1 * 1 identity 1 add1 (- n 1))
  )
(define (prime-sum2 n)
  (filtered-accumulate2 prime? + 0 square 1 add1 n)
  )


(print (prime-sum 11))
(print (gcd-product 10))
(print (prime-sum2 11))
(print (gcd-product2 10))

