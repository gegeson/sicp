12:41->12:47

解けなかった実装問題はリトライする自分ルール。

出来た。
---
(define (require p)
  (if (not p) (amb)))

(define (an-integer-starting-from n)
  (amb n (an-integer-starting-from (+ n 1))))

(define (an-integer-between low high)
  (if (= low high)
      low
    (amb low (an-integer-between (+ low 1) high))))
---
(define (pythagoras start)
  (let ((k (an-integer-starting-from start)))
    (let ((j (an-integer-between start k)))
      (let ((i (an-integer-between start j)))
        (require (= (+ (* i i) (* j j)) (* k k)))
        (list i j k)))))
---
