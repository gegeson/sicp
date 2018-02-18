17:02->17:08
17:10->18:09
削除するべきフレームは、先頭から順々に検索していってすべて探すべきだと思う。
関数の中からグローバル変数を削除したい時などがあるかもしれないので。

まず、便利なので4.12.2.rktをベースに、scanとそれを使う奴らを若干変更する
4.12.2のコードのバグに気付いた。ので修正。

どうやら解答を観た感じ、今のフレームだけ削除するべきらしかった。
ただ、ほぼ変更せずに対応できそうだし、だるいのでパス。

(define (make-frame variables values)
  (cons variables values))

(define (frame-variables frame) (car frame))
(define (frame-values frame) (cdr frame))

(define (scan var vars vals)
  (cond ((null? vars) #f)
        ((eq? var (car vars))
         (make-frame vars vals))
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

色々実験した結果、これで先頭の削除がうまくいくとわかった。
あとはこれを活用する。
厳密にテストするのがだるいけど、多分できている。

(define (del-first! lst)
  (if (null? (cdr lst))
    (set! lst nil)
    (begin
     (set-car! lst (cadr lst))
     (set-cdr! lst (cddr lst)))))

(define (make-unbound! var env)
  (let* ((err "Unbound variable")
        　(result (env-loop var env err)))
    (if result
      (begin (del-first! (frame-variables result))
             (del-first! (frame-values result)))
      (make-unbound! var (enclosing-environment env)))))

実行用にこいつらも必要。
(define (unbound? exp)
  (tagged-list? exp 'make-unbound!))

(define (unbound-variable exp) (cadr exp))

(define (eval-unbound exp env)
  (make-unbound! (unbound-variable exp) env)
  'ok)
