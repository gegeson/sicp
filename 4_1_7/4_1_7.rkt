18:58->19:12
19:23->19:41
とりあえず読むだけ。

二周読んで朧気ながら分かってきた。

(define (factorial n)
  (if (= n 1)
    1
    (* (factorial (- n 1)) n)))

これが評価される時、この節のバージョンでは、
1回目に評価された時は言わずもがな、再帰をくぐって二回目に評価された時も

(define (analyze-if exp)
  (let ((pproc (analyze (if-predicate exp)))
        (cproc (analyze (if-consequent exp)))
        (aproc (analyze (if-alternative exp))))
    (lambda (env)
      (if (true? (pproc env))
          (cproc env)
          (aproc env)))))

これの返り値のラムダにenvを渡したものが出てくるということか。
再帰をくぐってもう一度式に出会った時に、再びevalのcondの長い場合分けをくぐらずともいきなりここに来る、と。
なるほどなるほど。
