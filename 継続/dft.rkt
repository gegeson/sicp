21:26->22:28
#lang debug racket
(require racket/trace)
こちらより。
http://uents.hatenablog.com/entry/sicp/058-continuations.md
深さ優先探索を、継続呼び出しによってとぎれとぎれで行うコード。

(define *saved* '())

(define (dft-node tree)
  (cond ((null? tree) (restart))
        ((not (pair? tree)) tree)
        (else (call/cc
               (lambda (cc)
                 (set! *saved*
                       (cons (lambda ()
                               (cc (dft-node (cdr tree))))
                             *saved*))
                 (dft-node (car tree)))))))

(trace dft-node)

(define (restart)
  (if (null? *saved*)
      'done
      (let ((cont (car *saved*)))
        (set! *saved* (cdr *saved*))
        (cont))))

(define t1 '(a (b (d h) (c e (f i) g))))

真面目に読んでみた。

要するに、
先頭を再帰的に読む→後半を読む事を記憶する
(restart)で記憶したものの先頭を読む
これの繰り返しだと思う。
抽象的思考が苦手なので、ここまで具体的に追いかけて初めて言葉にできた。

'((b (d h) (c e (f i) g)))
まず、これを処理する継続がsaveされ、
'a が出力される。
(save = (((b~)) nil))
(restart)後、
'((b (d h) (c e (f i) g)))
上が処理され、
nilを処理する継続がセーブされる。
save = (nil nil)
また、これはcarが
(b (d h) (c e (f i) g))
これなので、もう一回、以下を処理する継続がセーブされる。
'((d h) (c e (f i) g))
save = ((d h) nil nil)
そして 'b が出力される。
(restart)後、
'((d h) (c e (f i) g))
が処理される。
'((c e (f i) g))
を処理する継続がセーブされる。
save = (c nil nil)
car が(d h)なので、
引き続き呼び出しが起きる。
(h)を処理する継続がセーブされ、
'd が表示される。
save = (h c nil nil)
nilを処理する継続がセーブされ、
h が出力される。
save = (nil c nil nil)
nilを処理する。
もう一回呼び出しが起きる。
次に、これを処理する。
'((c e (f i) g))
…
長いので、この辺にしておく。
