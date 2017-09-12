#lang racket
(require racket/trace)
(require sicp)
;単純なのに解けなかったのが悔しいので（だいぶ日を置いた上で）なんとなく再挑戦

;23:15->23:30

(define (accumulate op initial sequence)
  (if (null? sequence)
    initial
    (op (car sequence)
        (accumulate op initial (cdr sequence)))))

(define (count-leaves t)
  (accumulate + 0 (map
                  (lambda (t)
                          (cond
                            ((null? t) 0)
                            ((not (pair? t)) 1)
                            (else
                              (+ (count-leaves (list (car t))) (count-leaves (cdr t)))
                             )
                            )
                          )
                   t)))

(newline)
(display (count-leaves (list 1 2 (list 1 2))))
(newline)
(display (count-leaves (cons (list 1 2) (list 1 2))))
(newline)
(display (count-leaves (list 1 2 (list 1 2) (list 2 3 (list 3 4 5)) (list 1 2))))
(newline)
(display (count-leaves (cons (list 1 2) (list 1 2))))


;出来た。
;思考プロセス
;まず、accumulateを使うからには0から始めて結果を次々に足していく、という形が最も自然だろう。
;そして, mapを使う。この中で再帰するのは覚えていたので、再帰を使うという前提で解く。
;再帰ならまず場合分けだが、木なのでnullかatomかをまず調べる。
;nullなら言うまでもなく0, atomなら1
;他については、リストがペアならcarとcdrに分かれるから、それぞれについて
;count-leavesして足せば良い。
;が、carはリストじゃないからmapに渡す上で都合が悪いようだ。
;ならとりあえずlistで囲えばいいのではないか。
;そんな具合で完成した。
;正しい答えを確認すると、最後のelseは単に(count-leaves t)で良いらしい。

(define (count-leaves2 t)
  (accumulate + 0 (map
                  (lambda (t)
                          (cond
                            ((null? t) 0)
                            ((not (pair? t)) 1)
                            (else
                              (count-leaves2 t)
                             )
                            )
                          )
                   t)))


(newline)
(display (count-leaves2 (list 1 2 (list 1 2))))
(newline)
(display (count-leaves2 (cons (list 1 2) (list 1 2))))
(newline)
(display (count-leaves2 (list 1 2 (list 1 2) (list 2 3 (list 3 4 5)) (list 1 2))))

;なるほど、これでも確かに正しく動いているらしい。
;考えてみれば、普通の再帰と違って徐々にtを小さくしていくわけではないので、
;普通の再帰の発想は必要がない。
;そして、自分の書いたバージョンを簡潔に書いただけだから、正しく動くことは明白である。
