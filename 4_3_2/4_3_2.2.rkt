12:12->12:42
+3m

自然言語の構文解析。
ambがなくても、require だけで解の探索は機能するんだなあ。

言葉の形を
「冠詞・シンプルな名詞・シンプルな動詞」
で決め打ちしたバージョンと、

ambを使って
名詞 = シンプルな名詞 or 名詞 + 前置詞 + 冠詞 + 名詞
動詞 = シンプルな動詞 or 動詞 + 前置詞 + 冠詞 + 名詞
と、再帰的に定義した上で
「冠詞・名詞・動詞」
と決めたバージョンの二つがある、という理解。

解析する文をグローバル変数にしててわかりづらいが、読めたと思う。

あまり興味がそそられないし、論理パズル同様脇道だと思うので、問題は解かずに飛ばそうかな。

4.46, 4.47の問題文と答えだけ眺めた。解かず。
http://www.serendip.ws/archives/2540