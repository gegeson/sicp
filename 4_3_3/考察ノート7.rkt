今度これやってみよう
12:29->12:58
+30m
通勤中や寝る前にも考えてたので+30mした
色々間違えてたので全消し、やる気次第でやり直す予定
脳内トレースを何度かやったので、継続の動きは完全に掴めてると思う

(define (require p)
  (if (not p) (amb)))

(define x false)
(define y false)

(begin
  (set! x (amb 0 1))
  (set! y (amb 0 1))
  (set! y (+ y 1))
  (require (= y 2))
  (x y))
