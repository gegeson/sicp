7:17->7:28


(let ((pairs '()))
  (if-fail (let ((p (prime-sum-pair '(1 3 5 8) '(20 35 110))))
             (permanent-set! pairs (cons p pairs))
             (amb))
           pairs))

最初に素数になるペアが表示されるんじゃないかな、単に
---
;;; Starting a new problem
;;; Amb-Eval value:
((8 35) (3 110) (3 20))
---
→いや、複数だったぞ。
考えてみると、
(amb)が持つ失敗継続はif-failの持つ失敗継続じゃなくて、
prime-sum-pairの失敗継続か。
つまり一つペアが見つかってもすべてが切れるまではambが進み続けるんだな。
なるほどなるほど
そして右から左に追加されていくので見つかった順の逆に表示、ということかな
---
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

(define (require p)
 (if (not p) (amb)))

(define (an-element-of items)
 (require (not (null? items)))
 (amb (car items) (an-element-of (cdr items))))

(define (prime-sum-pair list1 list2)
  (let ((a (an-element-of list1))
        (b (an-element-of list2)))
    (require (prime? (+ a b)))
    (list a b)))

(let ((pairs '()))
  (if-fail (let ((p (prime-sum-pair '(1 3 5 8) '(20 35 110))))
             (permanent-set! pairs (cons p pairs))
             (amb))
           pairs))
