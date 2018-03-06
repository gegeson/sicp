22:53->22:55
22:57->23:09

(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high)))
    (let ((j (an-integer-between i high)))
      (let ((k (an-integer-between j high)))
        (require (= (+ (* i i) (* j j)) (* k k)))
        (list i j k)))))

(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high))
        (hsq (* high high)))
    (let ((j (an-integer-between i high)))
      (let ((ksq (+ (* i i) (* j j))))
        (require (>= hsq ksq))
        (let ((k (sqrt ksq)))
          (require (integer? k))
          (list i j k))))))

違い
元のは
(i, j, k)
のカウンタが三つとも回っていた（i >= j >= k）が、
このバージョンでは
(i, j) (i >= j)
だけが回っているので、
単純にループの数が…減る。
言葉で表現しづらいが、
こちらの画像そのままのイメージだった。
http://www.serendip.ws/archives/2344
