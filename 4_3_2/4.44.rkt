19:16->19:58

解の総数が相当数あるらしいので、
合ってるかどうかの検証がめっちゃしづらい…
http://www.serendip.ws/archives/2479
ここと最初の三つが一致しているのでOKってことでいいかな。
ロジック的に間違えるのが難しいぐらいのもんだし
本来xy-1、xy+1なども、
計算量的には都度都度distinct?してやるほうがいいんだろうけど、
大したことない変更だし、パス。

(define (require p)
  (if (not p) (amb)))

(define (distinct? items)
  (cond ((null? items) true)
        ((null? (cdr items)) true)
        ((member (car items) (cdr items)) false)
        (else (distinct? (cdr items)))))

(define (eight-queen)
  (let ((line1 (amb 1 2 3 4 5 6 7 8))
        (line2 (amb 1 2 3 4 5 6 7 8)))
        (require (distinct? (list line2 line1)))
    (let ((line3 (amb 1 2 3 4 5 6 7 8)))
    (require (distinct? (list line3 line2 line1)))
    (let ((line4 (amb 1 2 3 4 5 6 7 8)))
    (require (distinct? (list line4 line3 line2 line1)))
    (let ((line5 (amb 1 2 3 4 5 6 7 8)))
    (require (distinct? (list line5 line4 line3 line2 line1)))
    (let ((line6 (amb 1 2 3 4 5 6 7 8)))
    (require (distinct? (list line6 line5 line4 line3 line2 line1)))
    (let ((line7 (amb 1 2 3 4 5 6 7 8)))
    (require (distinct? (list line7 line6 line5 line4 line3 line2 line1)))
    (let ((line8 (amb 1 2 3 4 5 6 7 8)))
    (require (distinct? (list line1 line2 line3 line4 line5 line6 line7 line8)))
    (let ((xy-1 (- 1 line1))
          (xy-2 (- 2 line2))
          (xy-3 (- 3 line3))
          (xy-4 (- 4 line4))
          (xy-5 (- 5 line5))
          (xy-6 (- 6 line6))
          (xy-7 (- 7 line7))
          (xy-8 (- 8 line8))
          (xy+1 (+ 1 line1))
          (xy+2 (+ 2 line2))
          (xy+3 (+ 3 line3))
          (xy+4 (+ 4 line4))
          (xy+5 (+ 5 line5))
          (xy+6 (+ 6 line6))
          (xy+7 (+ 7 line7))
          (xy+8 (+ 8 line8)))
      (require (distinct? (list xy+1 xy+2 xy+3 xy+4 xy+5 xy+6 xy+7 xy+8)))
      (require (distinct? (list xy-1 xy-2 xy-3 xy-4 xy-5 xy-6 xy-7 xy-8)))
      (list line1 line2 line3 line4 line5 line6 line7 line8)))
    )))))))
