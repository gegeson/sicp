（ほぼただの雑記）

計算機プログラムの構造と解釈（SICP）の問題の解答（一部ネットの解答を参考にしたものあり）  
--
訳・処理系・エディタの話
--
* 訳:真鍋版
* 処理系:Racket
* エディタ:Atom(プラグインはScript, Pareditなどを使用)

訳は真鍋版がいいと思う。別の訳や原文と比較したわけではないが、真鍋版は訳が気になった事が無い（1章から3.3章までで）。　　

処理系はRacketがおすすめ。sicpライブラリというものがあり、それをインストールするとsicp掲載のコードがそのまま動く。（図形言語にも対応している）  
ステップ実行と変数の表示ができるGUIのデバッガも付いている。  
debugライブラリをインストールすると#RRと書いた部分の値が表示される。   

ついでに、RacketはAtomがサポートしている。  
GaucheはSublime Textだと日本語コメントが使えず、AtomだとシンタックスハイライトとScript実行をサポートしてなかった。
そのため、EmacsもVimもヤダという人にはRacketとAtomの組み合わせを勧めたい。　　

AtomのScriptをインストールすると、エディタを開きながらCmd+iで下にコンソールの実行結果が表示されて、楽。  
Pareditは　　
Ctrl + Alt + . 入れる　　
Ctrl + Alt + s 剥く　　  
この二つしか使ってないが、これでも十分役に立っている。おすすめ。  

自分のやりかたとか
--
所要時間を厳密に記録している。（3章の所要時間.txt などを参照）  
コメントによる解説や感想も多め。（ブログに近い使い方かもしれない）  
もはや人に見せることを一切考慮していない自分用まとめである。見せられたものではない。  
（いつかブログに綺麗にまとめたい）  
ファイル名が3.17.2.rktみたいになってるやつは繰り返し解いたり再挑戦したりした（内の2回目）という事  

問題は基本自力で解くようにしてた（1.1〜2.4）が、  
2.5〜3章辺りから解けない事が多くなってきたので、自力で解けそうも無いと思った問題はしばしばネットの解答を参考にして、  
写経したり解答の意味や動作の説明文を書いてみたり見ないで再現したりヒントだけ拾ったり、などしている。  
3章に関してはだいたい8割自力で解けた。  

参考にしているサイトなど  
--
SICP公式のサンプルコード・補助コード掲載サイト  
<https://mitpress.mit.edu/sicp/code/index.html>  
2章のput, getの実装などもここで入手できてお手軽。これは知るべき。  

解答・解説が多く、よく参考にしているサイト  
<http://www.serendip.ws/archives/tag/sicp/page/1>  
<http://uents.hatenablog.com/entry/sicp/index>  

1〜5章のほぼすべての問題の難易度リストとヒント  
（人による体感難易度は違うので参考にならないケースもある）  
<http://kinokoru.jp/archives/584>  

他にもたくさん。SICP (問題番号)でググるとたいてい解説が出てくる。英語含めればほぼ確実。  
ただ時折間違っていることもあるので要検証。    
