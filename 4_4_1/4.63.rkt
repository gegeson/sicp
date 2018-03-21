13:41->13:51
右と左どっちが夫でどっちが妻かだけで詰まった（そこだけネット参照）
そこさえ分かれば大した問題ではない
というわけで超スピードで4.4.1終了

(son 父　息子)
(grandson 祖父　孫)
(wife 夫　妻)

(assert! (rule (grandson ?G ?S)
               (and (son ?f ?S)
                    (son ?G ?f))))

(asset! (rule (is-son ?M ?S)
              (and (wife ?M ?W)
                   (son ?M ?S))))
