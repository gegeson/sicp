22:04->22:21
まず思いついたのが本文に出てきた微分方程式だったんだが…どうしろと

あ…
そういえば
3.52でこんなんがあった

(define sum 0)

(define (accum x)
  (set! sum (+ x sum))
  sum)

(define seq (stream-map accum (stream-enumerate-interval 1 20)))
(define y (stream-filter even? seq))
(define z (stream-filter (lambda (x) (= (remainder x 5) 0))
                         seq))

(stream-ref y 7)
(display-stream z)

これ、挙動が変わるはず
y, zの定義時点で初項が決まるせいで
y, z定義時点でいきなり初項を求めるためにseqを探索する挙動になってたが、
今回は変わるはず。
---
この遅延度を活かす方法？
本文にあるように、3.5のやり方ならdelayを使うようなものを扱えば良いのでは。
---
（これで解答になってるのかな？？と思いつつ、これ以上絞っても何も出なさそうなので答えを見る）
---
http://www.serendip.ws/archives/2249
なるほど。
consで作る対象が全部未定義でもなんとかなるのか。
すげえ。
自分のでもまあ考察として間違いではないかな。
