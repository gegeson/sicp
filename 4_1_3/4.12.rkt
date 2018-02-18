14:25->14:50
方針だけ考えてた時間は計測せず
予想より修正が必要だったが、まあ簡単な部類に入るかも
実験室は"mc/4.12.mc.rkt"

図らずしてこことほぼ同じになった
http://www.serendip.ws/archives/1884
ググると更にenv-loopまで抽象化してる人がいる。やってみようかな。
"./4.12.2.rkt"でやってみた。

(define (scan var vars vals)
  (cond ((null? vars) #f)
        ((eq? var (car vars))
         vals)
        (else (scan var (cdr vars) (cdr vals)))))

(define (lookup-variable-value var env)
  (define (env-loop env)
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let* ((frame (first-frame env))
               (scan-result
                (scan var (frame-variables frame)
                          (frame-values frame))))
          (if scan-result
            (car scan-result)
            (env-loop (enclosing-environment env)))
          )))
  (env-loop env))

(define (set-variable-value! var val env)
  (define (env-loop env)
    (if (eq? env the-empty-environment)
        (error "Unbound variable -- SET!" var)
        (let* ((frame (first-frame env))
               (scan-result
                (scan var (frame-variables frame)
                          (frame-values frame))))
             (if scan-result
               (set-car! scan-result val)
               (env-loop (enclosing-environment env))
               ))))
  (env-loop env))

(define (define-variable! var val env)
  (let* ((frame (first-frame env))
        (scan-result
        (scan var (frame-variables frame)
                  (frame-values frame))))
    (if scan-result
      (set-car! scan-result val)
      (add-binding-to-frame! var val frame))
      )
    )
