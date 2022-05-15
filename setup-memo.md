## shell profileまわり

bashについては[bash の初期化ファイル .profile, .bashrc, .bash_profile の使い分けと管理方針](https://blog1.mammb.com/entry/2019/12/01/090000)が参考になる。zshに関しては[Startup Files](https://zsh.sourceforge.io/Intro/intro_3.html), [Zsh - ArchWiki](https://wiki.archlinux.jp/index.php/Zsh) など。

自分は以下の方針でいこうと考えている:

- 環境変数はログイン時にセット。
  - →systemdなどで自動化するときはセットされないことを意味する。このようなケースでは必要なものを別途手動で設定する。
- シェルのその他の設定はインタラクティブシェル向けの設定ファイルで環境変数の設定後に行う。

そのため以下のようにする:

- `.profile` 環境変数の設定処理を書く。
- `.bashrc`, `.zshrc`: インタラクティブシェルで必要な設定を書く。
- `.bash_profile`: `.profile` と `.bashrc` をこの順に呼ぶ。
- `.zsh_profile`: `.profile` を呼ぶ。

## Go

[Download and install - The Go Programming Language](https://go.dev/doc/install) のtarball方式が手軽。
