;20:40->21:34
まず、直列化しない場合。
(define x 10)
(parallel-execute (lambda () (set! x (* x x)))
                  (lambda () (set! x (* x x x))))

p_a1: xの値の一つ目を読み取る
p_a2: xの値の二つ目を読み取る
p_a3: p_a1, p_a2で読み取ったxの値に基づいて、自乗を計算する
p_a4: p_a3で計算した値に基づいて、xに値を代入する

p_b1: xの値の一つ目を読み取る
p_b2: xの値の二つ目を読み取る
p_b3: xの値の三つ目を読み取る
p_b4: p_b1〜p_b3で読み取ったxの値に基づいて、3乗を計算する
p_b5: p_b4で計算した値に基づいて、xに値を代入する

処理が多いが、
読み取りと代入のタイミングがポイントな事を考えると、こういう風な場合分けになると思う
面倒とかいうレベルじゃないので処理単位での列挙はしない

パターン1
・一方の読み込みは、一方の代入の後に行われた（処理は直列に行われた）
  パターン1.1
  ・p_aの後にp_bが実行された
    結果:100**3
  パターン1.2
  ・p_bの後にp_aが実行された
    結果:1000**2
パターン2
・p_aの読み込み最中にp_bによる代入があった
  パターン2.1
  ・p_a1とp_a2の間にp_bが実行された
    結果:10*1000
  パターン2.2
  ・p_a2の後ならパターン4.1と同じ

パターン3
・p_bの読み込み最中にp_aによる代入があった
  パターン3.1
  ・p_b1とp_b2の間にp_aが実行された
    結果:10*100*100
  パターン3.2
  ・p_b2とp_b3の間にp_aが実行された
    結果:10*10*100
  パターン3.3
  ・p_b3の後ならパターン5.1と同じ

パターン4
・p_bの代入の前にp_aの読み込みがすべて完了していて、
  かつ、p_aの代入がp_bの代入の後に行われた
 （p_bが完全に無視された）
  結果:100
  パターン4.1
  ・p_aの読み取り終了後から代入の前までにp_bがすべての処理を終え、
   その後にp_aの代入が行われた
  パターン4.2
  ・p_bの代入前にp_aが読み取りを行い、p_bの代入後にp_aが代入した
  パターン4.3
  ・他にも色々。でもこれ以上細かく分ける意味は多分無い

パターン5
・p_aの代入の前にp_bの読み込みがすべて完了していて、
  かつ、p_bの代入がp_aの代入の後に行われた
 （p_aが完全に無視された）
  結果:1000
  パターン5.1
  ・p_bの読み取り終了後から代入の前までにp_aがすべての処理を終え、
　  その後にp_bの代入が行われた
  パターン5.2
  ・p_aの代入前にp_bが読み取りを行い、p_aの代入後にp_bが代入した
  パターン5.3
  ・列挙しきれないけど他にも色々。

このように直列化すると？
(define x 10)
(define s (make-serializer))
(parallel-execute
    (s (lambda () (set! x (* x x))))
    (s (lambda () (set! x (* x x x)))))

このバージョンでは、
明らかにパターン1.1とパターン1.2だけになるので、
結果は100**3か1000*2、値としてはどっちも同じく10^6になる。