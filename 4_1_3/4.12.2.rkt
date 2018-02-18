14:50->15:06

4.12.rktで一応解けたが、
ググると更にenv-loopまで抽象化してる人がいる。やってみようかな。
できた。（答えちら見したから完全自力ではないけど）
4.13解く途中にバグに気付いたので修正した。

(define (scan var vars vals)
  (cond ((null? vars) #f)
        ((eq? var (car vars))
         vals)
        (else (scan var (cdr vars) (cdr vals)))))

(define (env-loop var env err)
  (if (eq? env the-empty-environment)
    (error err var)
    (let ((frame (first-frame env)))
        (scan var (frame-variables frame)
                  (frame-values frame)))))

(define (lookup-variable-value var env)
  (let* ((err "Unbound variable")
        　(result (env-loop var env err)))
    (if result
      (car (frame-values result))
      (lookup-variable-value var (enclosing-environment env)))))

(define (set-variable-value! var val env)
  (let* ((err "Unbound variable -- SET!")
         (result (env-loop var env err)))
    (if result
      (set-car! (frame-values result) val)
      (set-variable-value! var val (enclosing-environment env)))))

(define (define-variable! var val env)
  (let* ((err "本来表示されることがないエラーです")
        (result (env-loop var env err)))
    (if result
      (set-car! (frame-values result) val)
      (add-binding-to-frame! var val (first-frame env)))))
