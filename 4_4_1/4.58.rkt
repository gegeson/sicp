12:06->12:30
よくわからない。
SQL力の無さかな
答え見て考えるモード
http://www.serendip.ws/archives/2654
(assert! (rule (big-shot ?person)
               (and (job ?person (?section . ?type))
                    (supervisor ?person ?supervisor)
                    (job ?supervisor (?section-sp . ?type-sp))
                    (not (same ?section ?section-sp)))))
これだと
「同じ部署に上司が存在しない」になって成功するのか
上司が存在しない場合については出てこないけど、出てこなくてもいいのか
