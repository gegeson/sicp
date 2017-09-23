#lang debug racket
(require sicp)
(require racket/trace)

(define (square x) (* x x))
;18:25->19:00
(define (rand-update x)
  (let ((a 27) (b 26) (m 127))
    (modulo (+ (* a x) b) m)))
(define random-init 7)
(define rand (let ((x random-init))
               (lambda ()
                       (set! x (rand-update x))
                       x)))
(define (estimate-pi trials)
  (sqrt (/ 6 (monte-carlo trials cesaro-test))))

(define (cesaro-test)
  (= (gcd (rand) (rand)) 1))

(define (monte-carlo trials experiment)
  (define (iter trials-remaining trials-passed)
    (cond ((= trials-remaining 0)
           (/ trials-passed trials))
      ((experiment)
       (iter (- trials-remaining 1)
             (+ trials-passed 1)))
      (else
       (iter (- trials-remaining 1)
             trials-passed)
       )
      )
    )
  (iter trials 0)
)

(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))


(define (estimate-integral p x1 x2 y1 y2 trials)
  (define ratio
    (monte-carlo trials
                 (lambda ()
                         (let ((x (random-in-range x1 x2))
                               (y (random-in-range y1 y2)))
                           (p x y)))
                 )
    )
  (* ratio (- x2 x1) (- y2 y1))
)
(define (p1 x y) (<= (+ (* x x) (* y y)) 4))
(display (/ (estimate-integral p1 -15 15 -15 15 100000) 4.0))
;3.29175
(newline)
(define (p2 x y) (<= (+ (* x x) (* y y)) 100))
(display (/ (estimate-integral p2 -10 10 -10 10 100000) 100.0))
;3.15492
(newline)
