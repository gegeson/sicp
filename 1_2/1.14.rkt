#lang racket
;10:22->10:50
(define (count-change amount)
  (cc amount 5))

(define (cc amount kinds-of-coins)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (= kinds-of-coins 0)) 0)
        (else (+ (cc amount
                     (- kinds-of-coins 1))
                 (cc (- amount
                        (first-denomination kinds-of-coins))
                     kinds-of-coins)))))

(define (first-denomination kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-coins 2) 5)
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-coins 4) 25)
        ((= kinds-of-coins 5) 50)))
(display (cc 11 3))
(newline)
(display (cc 6 2))
(newline)
(display (cc 1 1))
(newline)
(display (cc 0 2))
;;空間ステップは、一番深くまで降りるのが1ずつ減らしていく場合なので、O(x)
;(cc x 1)
;=(cc x 0) + (cc x-1 1)
;(cc x 0) = 0, (cc 0 1) = 1より、
;(cc x 1) = 1,
;また、(cc x 1)の葉の数は(x+1)
;(cc x 2)
;= (cc x 1) + (cc x-5 2)
;よって、(cc x 2)の葉の数は、
;(x + 1) * int(x/5) + 1
;(cc x 3)
;= (cc x 2) + (cc x-10 3)
;よって(cc x 3)の葉の数は、
;((x + 1) * int(x/5) + 1) * int(x/10)+1
;同様に
;(cc x 4)の葉の数は
;(((x + 1) * int(x/5) + 1) * int(x/10)+1) * int(x/25) + 1
;(cc x 5)の葉の数は
;((((x + 1) * int(x/5) + 1) * int(x/10)+1) * int(x/25) + 1) * (int(x/50) + 1)
;よって、(cc x 5)の時間オーダーはO(x^5)
;尚、明らかに
;(cc x k)なら、時間オーダーはO(x^k)
