やる気の波。
People In The BoxのアルバムKodomo Rengouを聴きながら。
20:38->20:50
+2m

これを
(define (eval-sequence exps env)
  (cond ((last-exp? exps) (_eval (first-exp exps) env))
        (else (_eval (first-exp exps) env)
              (eval-sequence (rest-exps exps) env))))

こんな風に変化させなくとも
(define (eval-sequence exps env)
  (cond ((last-exp? exps) (eval (first-exp exps) env))
        (else (actual-value (first-exp exps) env)
              (eval-sequence (rest-exps exps) env))))

こいつは動く
;;PART A
(define (for-each proc items)
  (if (null? items)
      'done
      (begin (proc (car items))
             (for-each proc (cdr items)))))

よね？
(for-each (lambda (x) (newline) (display x))
          (list 57 321 88))
なんで？
---
多分、この順に進む
(lambda (x) (newline) (display x))はまずthunk化される。
(list 57 321 88)もthunk化される。
しかし！
(proc (car item))
ここで二つ強制が起きる
まず、関数適用の適用時、関数は強制される。
そして基本手続き car に引数が渡された時も強制される。
つまり、ここでは引数が両方強制される事になる。
つまり、普通に実行される。
---
ググるとdisplayがプリミティブであるという指摘がチラホラあって気づいたけど、
thunkリストがcarに渡る事でもとに戻る→ラムダの引数になる事でもう一度thunk化される
→displayに渡りもう一度強制される
という順序だった。ミスだ。
