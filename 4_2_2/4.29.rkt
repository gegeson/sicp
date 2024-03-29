19:39->20:05
20:07->20:56
21:52->22:01
(define count 0)

(define (id x)
  (set! count (+ count 1))
  x)

例が思い浮かばないのでまずこれについて考える

(define (square x)
  (* x x))

(square (id 10))

引数が遅延されるんだから、まず
(* (id 10) (id 10))
だよな。
そこからそれぞれ強制されて、
idが二回実行されて
(* 10 10)
となる。
だからcountは 2 になると思う。
普通のインタプリタなら 1 。
---
→いやいやいや、違う違う。
実験したら遅延評価版（メモ化あり）が 1 だったから気付いたが、（普通版では普通に1）
メモ化してるんだから同じオブジェクト(id 10)については即座に答えが出てくるんだった。
メモ化しない版なら2で合ってる。（メモ化しない版とする版の両方を調べる事を見落としてた）
---
でもこれでわかったぞ。
この手の、引数が二つに分かれて両方見る場合についてはメモ化しないとすごいことになるはず。
1章でも出たな。こういうやつ
1.26より。
(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))
メモ化すればO(log(n)), メモ化しなければO(n)
これは遅延評価の話と言うよりメモ化の話だな。

ここで一つ疑問。
メモ化は同じ対象についてしか機能しないのに、
なぜ右と左で別なものにメモ化が機能しているのか？
→これは単に、square内で二つとして扱ってるだけで同じ対象を指してるのだろうと思う。
---
ググったら、木構造再帰じゃない、下のfib-iterなんかでもメモ化が有効に働くらしい。
実行してみたら確かに明らかに速かった。
なぜ？考えてみよう。
http://www.serendip.ws/archives/2228

(define (fib n)
  (define (fib-iter a b count)
    (if (= count 0)
        b
        (fib-iter (+ a b) a (- count 1))))
  (fib-iter 1 0 n))

(fib n)について
初期値をa0, b0, count0とすると…
(fib-iter (+ a0 b0) a0 (- count0 1))
(fib-iter (+ (+ a0 b0) b0) (+ a0 b0) (- (- count0 1) 1))
(fib-iter (+ (+ a0 b0) (+ (+ a0 b0) b0)) (+ (+ a0 b0) b0) (- (- (- count0 1) 1) 1))
(fib-iter (+ (+ (+ a0 b0) b0) (+ (+ a0 b0) (+ (+ a0 b0) b0))) (+ (+ a0 b0) (+ (+ a0 b0) b0)) (– (- (- (- count0 1) 1) 1) 1))
(fib-iter (+ (+ (+ (+ a0 b0) b0) (+ (+ a0 b0) (+ (+ a0 b0) b0))) (+ (+ a0 b0) (+ (+ a0 b0) b0)))
          (+ (+ (+ a0 b0) b0) (+ (+ a0 b0) (+ (+ a0 b0) b0)))
          (- (– (- (- (- count0 1) 1) 1) 1) 1)
こういう風になっていく。
ここでcountが0になり、値が強制される時…
bだけが評価されるわけだけど、
(+ (+ (+ a0 b0) b0) (+ (+ a0 b0) (+ (+ a0 b0) b0)))
この中身の(+ x y)は実際には全部thunk化されるので、全部メモ化される。
なるほど。
この+の連鎖がもっとすごいことになっていれば、節約にはなりそうだなということはわかった。
+の数は2のべき乗で増えていくから、まあなんとなくわかる。
多分だけど、加算に関してO(2^n)がメモ化によってO(n)になってるはず。
(fib 1000)でも一瞬だったから間違いない。
メモ化しない版だと(fib 300)で沈黙した。
---
ところで、普通のインタプリタだと別に遅延評価してないしメモ化もしてないわけだけど、
何故か遅くなってない。(fib 1000)が一瞬。
なぜ？
→これは簡単な話。
遅延評価する版だと、足し算をどんどん積み重ねていくことになるが、
遅延評価しないならその場で都度都度計算するため、
同じ計算が何度も現れることがない。
だからメモ化する必要がない。
---
・普通のインタプリタ
・メモ化なし遅延評価インタプリタ
・メモ化あり遅延評価インタプリタ
の三者でそれぞれに計算方法が違う、というのが面白い。すごい面白い。
---
気になって眠れないのでこれについて遅延評価版でどうなるかチェック
(define (fib n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 1))
                 (fib (- n 2))))))
計算結果は略すが、これは多分メモ化が効かないパターンだ。
同じ引数の(fib n)がそれぞれ同じオブジェクトじゃないもの。
→計算した結果、やはりfib(100)で沈黙。
(fib 30)でももう遅い。
やはりやはり、この評価器におけるメモ化は同じオブジェクトに対してのみ有効なんだな。
