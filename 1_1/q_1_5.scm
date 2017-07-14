; 正規順序評価
; 完全に展開してから簡約する
; (test 0 (p)) -> (if (= 0 0) 0 y) -> 0 

; 適用順序評価
; 引数を評価してから適用する
; (test 0 (p))-> (test 0 (p)) -> (test 0 (p)) -> 



(define (p) (p))
(define (test x y)
  (if (= x 0) 0 y))

(test 0 (p))