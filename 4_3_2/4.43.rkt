12:00->12:11
12:30->12:59
+11m+10m+6m
17:40->19:03

友達の娘の名前をクルーザーに付ける5人のおじさんたちってなんかやばそうだな

娘の名前とクルーザーの名前をリストとすれば良い気がする。
carが娘でcadrがクルーザー。
(amb 'Mary 'Gabrielle 'Lorna 'Rosalind 'Mellissa)
(define (daughter x) (car x))
(define (cruiser x) (cadr x))

初期時点で簡単に確定出来る情報は削る。

父視点:娘の名前とクルーザーの名前は違う、
娘視点:父の名前とクルーザーの名前は違う、自分の名前をクルーザーの名前にしている人は父ではない
あと、父がクルーザーの名前にしてるのはそれぞれ相異なるのかな

考えててわかったけど、
父親がクルーザーを持つ、という情報と
娘が父親を持つ、という情報の二つに分けて、
つなぎ合わせる事で正解を探す、というやり方しかないんじゃないかな。
→それでもまだ足りない。
父親が娘とクルーザーと持つ、という情報と
娘が父親を持つ、という情報の組み合わせなら多分出来る。
父親が娘を持つ情報は削ったらダメだ

(define (map f lst)
  (cond
    ((null? lst) '())
    (else
     (cons (f (car lst)) (map f (cdr lst)))
     )
    ))

(define (require p)
  (if (not p) (amb)))

(define (distinct? items)
  (cond ((null? items) true)
        ((null? (cdr items)) true)
        ((member (car items) (cdr items)) false)
        (else (distinct? (cdr items)))))

(define (daughter x) (car x))
(define (cruiser x) (cadr x))

(define (father x) (car x))

(define (fathers-cruiser father)
  (cond
    ((equal? father 'Moore) 'Lorna)
    ((equal? father 'Downing) 'Mellissa)
    ((equal? father 'Hall) 'Rosalind)
    ((equal? father 'Barancle) 'Gabrielle)
    ((equal? father 'Parker) 'Mary)
    (else
     'a
    )
  ))

(define (same? p1 p2)
  (let ((MaryFather1 (assoc 'Mary p1))
        (MaryFather2 (assoc 'Mary p2))
        (GabrielleFather1 (assoc 'Gabrielle p1))
        (GabrielleFather2 (assoc 'Gabrielle p2))
        (LornaFather1 (assoc 'Lorna p1))
        (LornaFather2 (assoc 'Lorna p2))
        (RosalindFather1 (assoc 'Rosalind p1))
        (RosalindFather2 (assoc 'Rosalind p2))
        (MellissaFather1 (assoc 'Mellissa p1))
        (MellissaFather2 (assoc 'Mellissa p2)))
    (and (equal? MaryFather1 MaryFather2)
         (equal? GabrielleFather1 GabrielleFather2)
         (equal? LornaFather1 LornaFather2)
         (equal? RosalindFather1 RosalindFather2)
         (equal? MellissaFather1 MellissaFather2)
         )
    )
  )

出来た。
娘の父=父の娘
という条件が満たされる必要がある事に漸く気づけた。
すごい汚い。他の人どうやってるんだろう
(define (pazzle)
  (let ((Moore (list 'Mary 'Lorna))
        (Downing (list (amb 'Gabrielle 'Lorna 'Rosalind) 'Mellissa))
        (Hall (list (amb 'Gabrielle 'Lorna) 'Rosalind))
        (Barancle (list 'Mellissa 'Gabrielle))
        (Parker (list (amb 'Gabrielle 'Lorna 'Rosalind) 'Mary))
        (Mary 'Moore)
        (Gabrielle (amb 'Downing 'Hall 'Parker))
        (Lorna (amb 'Downing 'Hall 'Parker))
        (Rosalind (amb 'Downing 'Parker))
        (Mellissa 'Barancle))
    (require (distinct? (map car (list Moore Downing Hall Barancle Parker))))
    (require (distinct? (list Mary Gabrielle Lorna Rosalind Mellissa)))
    (require (equal? (fathers-cruiser Gabrielle) (daughter Parker)))
    (let ((daughter-father1
      (list (list 'Mary Mary) (list 'Gabrielle Gabrielle) (list 'Lorna Lorna)
                  (list 'Rosalind Rosalind) (list 'Mellissa Mellissa)))
          (daughter-father2
            (list (list (daughter Moore) 'Moore) (list (daughter Downing) 'Downing) (list (daughter Hall) 'Hall)
                  (list (daughter Barancle) 'Barancle) (list (daughter Parker) 'Parker))))
      (require (same? daughter-father1 daughter-father2))
      (assoc 'Lorna daughter-father1))
    )
  )

;;; Amb-Eval input:
(pazzle)

;;; Starting a new problem
;;; Amb-Eval value:
(Lorna Downing)

;;; Amb-Eval input:
try-again

;;; There are no more values of
(pazzle)


「MaryとMooreが親子とわからなかった時」が上手く行かない。
スパゲッティ過ぎてどこに誤りがあるかわからないし（父・娘関係には誤りはないらしい）、
得られるものも無さそうなので次行こう。
(define (pazzle2)
  (let ((Moore (list (amb 'Mary 'Gabrielle 'Rosalind) 'Lorna))
        (Downing (list (amb 'Mary 'Gabrielle 'Lorna 'Rosalind ) 'Mellissa))
        (Hall (list (amb 'Mary 'Gabrielle 'Lorna) 'Rosalind))
        (Barancle (list 'Mellissa 'Gabrielle))
        (Parker (list (amb 'Gabrielle 'Lorna 'Rosalind) 'Mary))
        (Mary (amb 'Moore 'Downing 'Hall))
        (Gabrielle (amb 'Moore 'Downing 'Hall 'Parker))
        (Lorna (amb 'Downing 'Hall 'Parker))
        (Rosalind 'Moore 'Downing 'Parker)
        (Mellissa 'Barancle))
        (require (distinct? (map car (list Moore Downing Hall Barancle Parker))))
        (require (distinct? (list Mary Gabrielle Lorna Rosalind Mellissa)))
        (require (equal? (fathers-cruiser Gabrielle) (daughter Parker)))
        (let ((daughter-father1
          (list (list 'Mary Mary) (list 'Gabrielle Gabrielle) (list 'Lorna Lorna)
                      (list 'Rosalind Rosalind) (list 'Mellissa Mellissa)))
              (daughter-father2
                (list (list (daughter Moore) 'Moore) (list (daughter Downing) 'Downing) (list (daughter Hall) 'Hall)
                      (list (daughter Barancle) 'Barancle) (list (daughter Parker) 'Parker))))
          (require (same? daughter-father1 daughter-father2))
          (assoc 'Lorna daughter-father1))
        )
      )
