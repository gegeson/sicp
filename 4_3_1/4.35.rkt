21:47->21:57

(define (an-integer-between low high)
  (if (= low high)
      low
    (amb low (an-integer-between (+ low 1) high))))

(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high)))
    (let ((j (an-integer-between i high)))
      (let ((k (an-integer-between j high)))
        (require (= (+ (* i i) (* j j)) (* k k)))
        (list i j k)))))

amb.rktにて実験。できとるーー！！！
---
;;; Amb-Eval input:
(a-pythagorean-triple-between 1 100)

;;; Starting a new problem
;;; Amb-Eval value:
(3 4 5)

;;; Amb-Eval input:
try-again

;;; Amb-Eval value:
(5 12 13)

;;; Amb-Eval input:
try-again

;;; Amb-Eval value:
(6 8 10)
---
ネットで見た別解
http://www.serendip.ws/archives/2321

(define (an-integer-between low high)
  (require (< low high))
  (amb low (an-integer-between (+ low 1) high)))

まだこの表記になれないが、意味は取れる。
