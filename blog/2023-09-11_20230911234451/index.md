---
layout: layouts/blog.njk
title: "WASIの標準化: ウェブの外でWebAssemblyを実行するためのインターフェース"
tags:
  - blog
---

[Standardizing WASI: A system interface to run WebAssembly outside the web](https://hacks.mozilla.org/2019/03/standardizing-wasi-a-webassembly-system-interface/)の和訳．

> Today, we announce the start of a new standardization effort — WASI, the WebAssembly system interface.

私たちは新しい標準化の取り組みであるWASI(WebAssembly system interface) を開始したことをお知らせします．

> **Why:** Developers are starting to push WebAssembly beyond the browser, because it provides a fast, scalable, secure way to run the same code across all machines.

なぜ? WebAssemblyは全てのコンピュータで同じコードを高速に，スケーラブルかつ安全に実行する方法を提供するため，開発者たちはブラウザの枠を超えてWebAssemblyを推し進めているからです．

> But we don’t yet have a solid foundation to build upon. Code outside of a browser needs a way to talk to the system — a system interface. And the WebAssembly platform doesn’t have that yet.

しかし，私たちはまだ構築するための強力な基盤を持っていません．
コードをブラウザの外に持っていくには，システムと対話するための方法，システムインターフェースが必要です．
そして，WebAssemblyはそのシステムインターフェースをまだ持っていません．

> **What:** WebAssembly is an assembly language for a conceptual machine, not a physical one. This is why it can be run across a variety of different machine architectures.

何? WebAssemblyは仮想(概念的な)マシンのアセンブリ言語であり，物理マシンのそれではありません．
これがさまざまなアーキテクチャで実行可能な理由です．

> Just as WebAssembly is an assembly language for a conceptual machine, WebAssembly needs a system interface for a conceptual operating system, not any single operating system. This way, it can be run across all different OSs.

WebAssemblyは仮想マシンのアセンブリ言語であり，特定のOSに依存しない仮想的なOSのシステムインターフェースを必要としています．
この方法で，全てのOSでWebAssemblyを実行できるようになります．

> This is what WASI is — a system interface for the WebAssembly platform.

WebAssemblyのシステムインターフェース，これがWASIです．

> We aim to create a system interface that will be a true companion to WebAssembly and last the test of time. This means upholding the key principles of WebAssembly — portability and security.

私たちはWebAssemblyの真のパートナーとなり，長期間に渡運用できるシステムインターフェースを目指します．
これはWebAssemblyの携帯性とセキュリティという重要な原則を支持することを意味します．

> **Who:** We are chartering a WebAssembly subgroup to focus on standardizing WASI. We’ve already gathered interested partners, and are looking for more to join.

誰が? 私たちはWASIの標準化にフォーカスしたWebAssemblyのサブグループを設立しています．
私たちは既に興味のあるパートナーを集めており，さらな参加者を募集しています．

> Here are some of the reasons that we, our partners, and our supporters think this is important:

私たちパートナーやスポンサーがこれが重要と考える理由:

> ### Sean White, Chief R&D Officer of Mozilla
> “WebAssembly is already transforming the way the web brings new kinds of compelling content to people and empowers developers and creators to do their best work on the web. Up to now that’s been through browsers, but with WASI we can deliver the benefits of WebAssembly and the web to more users, more places, on more devices, and as part of more experiences.”

(TODO)

> ### Tyler McMullen, CTO of Fastly
> “We are taking WebAssembly beyond the browser, as a platform for fast, safe execution of code in our edge cloud. Despite the differences in environment between our edge and browsers, WASI means WebAssembly developers won’t have to port their code to each different platform.”

(TODO)

> ### Myles Borins, Node Technical Steering committee director
> “WebAssembly could solve one of the biggest problems in Node — how to get close-to-native speeds and reuse code written in other languages like C and C++ like you can with native modules, while still remaining portable and secure. Standardizing this system interface is the first step towards making that happen.”

(TODO)

> ### Laurie Voss, co-founder of npm
> “npm is tremendously excited by the potential WebAssembly holds to expand the capabilities of the npm ecosystem while hugely simplifying the process of getting native code to run in server-side JavaScript applications. We look forward to the results of this process.”

(TODO)

> So that’s the big news! 🎉

良い知らせがあります．

> There are currently 3 implementations of WASI:
> - wasmtime, Mozilla’s WebAssembly runtime
> - Lucet, Fastly’s WebAssembly runtime
> - a browser polyfill

現在3つのWASIの実装があります．

> You can see WASI in action in this video: [YouTube](https://www.youtube.com/watch?v=ggtEJC0Jv8A)

この動画でWASIの動作を知ることができます: [YouTube](https://www.youtube.com/watch?v=ggtEJC0Jv8A)

> And if you want to learn more about our proposal for how this system interface should work, keep reading.

どのようにWASIが動作するのか，プロポーザルについてさらに知りたい場合は，読み続けてください．

> ### What’s a system interface?
> Many people talk about languages like C giving you direct access to system resources. But that’s not quite true.

### システムインターフェースとは何か?
多くの人がCライクな言語がシステムリソースに直接アクセスする方法を提供すると言っています．
しかしそれは完全に正しくない．

> These languages don’t have direct access to do things like open or create files on most systems. Why not?

それらの言語はファイルを開いたり作成したりといったことをほとんどのシステム上で直接アクセスすることができない．
なぜか?

> Because these system resources — such as files, memory, and network connections— are too important for stability and security.

なぜならそれらのシステムリソース(ファイルやめm炉，ネットワーク接続)は安定性と安全性のために特に重要だからです．

> If one program unintentionally messes up the resources of another, then it could crash the program. Even worse, if a program (or user) intentionally messes with the resources of another, it could steal sensitive data.

もしあるプログラムが意図せず他のリソースを破壊(メチャクチャに)した場合，プログラムをクラッシュさせう可能性があります．
さらにプログラム(もしくはユーザー)が意図せず他のリソースを破壊(台無しに)した場合，機密情報が盗まれる可能性がある．

> So we need a way to control which programs and users can access which resources. People figured this out pretty early on, and came up with a way to provide this control: protection ring security.

なので私たちはプログラムとユーザーがどのリソースにアクセスできるかをコントロールする方法が必要です．

> With protection ring security, the operating system basically puts a protective barrier around the system’s resources. This is the kernel. The kernel is the only thing that gets to do operations like creating a new file or opening a file or opening a network connection.

リングセキュリティによる保護では，OSは基本的にシステムリソースの周囲に保護バリアを設置します．
それがカーネルです．
カーネルはファイルを作成したり，開いたり，ネットワークに接続できる唯一の機能です．

> The user’s programs run outside of this kernel in something called user mode. If a program wants to do anything like open a file, it has to ask the kernel to open the file for it.

ユーザーのプログラムはカーネルの外側のユーザーモードと呼ばれる形で実行されます．
もしプログラムが何かのファイルを開く必要がある場合，カーネルそのファイルを開くよう要求する必要がああります．

> This is where the concept of the system call comes in. When a program needs to ask the kernel to do one of these things, it asks using a system call. This gives the kernel a chance to figure out which user is asking. Then it can see if that user has access to the file before opening it.

ここでシステムコールと呼ばれるコンセプトが登場します．
プログラムがカーネルに何かを行うことを要求するとき，システムコールを使って要求します．
これにより，ユーザーが要求しているのかをカーネルに知らせることができます．
これにより，ユーザーがファイルにアクセスすることができるのかを開く前に確認することができます．

> On most devices, this is the only way that your code can access the system’s resources — through system calls.

多くのデバイス上でシステムコールを通すのがコードがシステムリソースにアクセスする唯一の方法です．

> The operating system makes the system calls available. But if each operating system has its own system calls, wouldn’t you need a different version of the code for each operating system? Fortunately, you don’t.

OSはシステムコールを利用可能にします．
OSごとに独自のシステムコールを持っていた場合，OSごとに異なるコードが必要でしょうか?
際ないなことにそうすることはありません．

> How is this problem solved? Abstraction.

どのようにこの問題を解決するのか? 抽象化によってです．

> Most languages provide a standard library. While coding, the programmer doesn’t need to know what system they are targeting. They just use the interface.

多くの言語が標準ライブラリを提供しています．
コーディングしている時，プログラマーは何のシステムをターゲットとしているか知る必要がありません．
インターフェースを使うだけです．

> Then, when compiling, your toolchain picks which implementation of the interface to use based on what system you’re targeting. This implementation uses functions from the operating system’s API, so it’s specific to the system.

コンパイルする時，ツールチェーンが使用するターゲットシステムに基づいてインターフェースの実装を選択します．
つまり，この実装は特定のシステムのOSのAPIファンクションを使用します．

> This is where the system interface comes in. For example, printf being compiled for a Windows machine could use the Windows API to interact with the machine. If it’s being compiled for Mac or Linux, it will use POSIX instead.

ここでシステムインターフェースが登場します．
例えば， Windows用にコンパイルされた`printf`はWindows APIを使用してコンピュータと対話します．
MacやLinux用にコンパイルされていれば，代わりにPOSIXを使うでしょう．

> This poses a problem for WebAssembly, though.

これはWebAssemblyにとって問題です．

> With WebAssembly, you don’t know what kind of operating system you’re targeting even when you’re compiling. So you can’t use any single OS’s system interface inside the WebAssembly implementation of the standard library.

WebAssemblyでは，どんなOSをターゲットにコンパイルしているかを知りません．
なので，特定のOSのシステムインターフェースをWebAssemblyの標準ライブラリに利用できません．

> I’ve talked before about how WebAssembly is an assembly language for a conceptual machine, not a real machine. In the same way, WebAssembly needs a system interface for a conceptual operating system, not a real operating system.

WebAssemblyは現実のコンピュータではなく概念コンピュータのアセンブリ言語であると前に話しました．
同様に，WebAssemblyは現実のOSではなく書いねん的なOSのシステムインターフェースを必要としています．

> But there are already runtimes that can run WebAssembly outside the browser, even without having this system interface in place. How do they do it? Let’s take a look.

しかし，既にシステムインターフェースがなくともWebAssemblyをブラウザの外でWebAssemblyを実行するランタイムが存在します．
どのような方法で?
見てみましょう．

> ### How is WebAssembly running outside the browser today?
> The first tool for producing WebAssembly was Emscripten. It emulates a particular OS system interface, POSIX, on the web. This means that the programmer can use functions from the C standard library (libc).

### どのようにWebAssemblyはブラウザの外で動いているのか
初期のWebAssemblyを生成するツールはEmscriptenでした．
これは特定のOSのシステムインターフェースであるPOSIXをウェブ上でエミュレートします．
これはプログラマがCの標準ライブラリである関数を使えるを意味します．

> To do this, Emscripten created its own implementation of libc. This implementation was split in two — part was compiled into the WebAssembly module, and the other part was implemented in JS glue code. This JS glue would then call into the browser, which would then talk to the OS.

これのために，Emscriptenはlibcの独自実装を作成しました．
これはWebAssemblyモジュールのコンパイルする箇所とそれ以外のJSのグルーコードを実装する箇所の2つの実装に分けられました．
このJSのグルーコードはブラウザを呼び出し，ブラウザはOSを呼び出します．

> Most of the early WebAssembly code was compiled with Emscripten. So when people started wanting to run WebAssembly without a browser, they started by making Emscripten-compiled code run.

多くの初期のWebAssemblyのコードがEmscriptenによってコンパイルされていました．
なので，人々がブラウザを用いずにWebAssemblyを実行しようとした時，Emscriptenがコンパイルしたコードを実行するところから始めました．

> So these runtimes needed to create their own implementations for all of these functions that were in the JS glue code.

それらのランタイムはJSのグルーコードの関数を全て独自実装する必要がありました．

> There’s a problem here, though. The interface provided by this JS glue code wasn’t designed to be a standard, or even a public facing interface. That wasn’t the problem it was solving.

ここで問題が発生します．
JSのグルーコードによって提供されるインターフェースは標準用，もしくは公開されるインターフェースとしてデザインされていなかったのです．

> For example, for a function that would be called something like `read` in an API that was designed to be a public interface, the JS glue code instead uses `_system3(which, varargs)`.

例えば，公開用のインターフェースとしてデザインされた`real`と呼ばれるような関数の場合，JSのグルーコードでは `_system3(which, varargs)`で代用されています．

> The first parameter, which, is an integer which is always the same as the number in the name (so 3 in this case).

最初のパラメーターの which は整数で関数名にあるように常に同じ値です(この場合は 3)．

> The second parameter, varargs, are the arguments to use. It’s called varargs because you can have a variable number of them. But WebAssembly doesn’t provide a way to pass in a variable number of arguments to a function. So instead, the arguments are passed in via linear memory. This isn’t type safe, and it’s also slower than it would be if the arguments could be passed in using registers.

2つ目のパラメータの varargs は引数として使います．変数の数を変更できるため，可変長(varargs)と呼ばれます．
しかし，WebAssemblyには関数に可変長の引数を提供する方法がありません．
そのため，引数は線形メモリを代用して渡されます．
これは型安全ではなく，またレジスターを経由して引数を渡すよりも遅くなります．

> That was fine for Emscripten running in the browser. But now runtimes are treating this as a de facto standard, implementing their own versions of the JS glue code. They are emulating an internal detail of an emulation layer of POSIX.

Emscriptenをブラウザ上で動かすのには問題ありませんでした．
しかし，現在ランタイムはこれをデファクトスタンダードとし，独自バージョンのJSのグルーコードを実装しています．
これはPOSIXのエミュレーションレイヤーの内部詳細エミュレーションしています．

> This means they are re-implementing choices (like passing arguments in as heap values) that made sense based on Emscripten’s constraints, even though these constraints don’t apply in their environments.

それは，Emscriptenの制約上では意味があったが，それらの制約がない環境では，それらを再実装することを意味します(引数をヒープを利用して渡すようなもの)．

> If we’re going to build a WebAssembly ecosystem that lasts for decades, we need solid foundations. This means our de facto standard can’t be an emulation of an emulation.

何十年の続くWebAssemblyのエコシステムを作る場合，強力な基盤が必要です．
これは私たちのデファクトスタンダードがエミュレーションのエミュレーションにならないことを意味します．

> But what principles should we apply?

ではどのような原則を適用するべきか?

> ### What principles does a WebAssembly system interface need to uphold?
> There are two important principles that are baked into WebAssembly :
> - portability
> - security

### WebAssemblyのシステムインターフェースは何の原則を守る必要があるか?
それはWebAssemblyが持っている2つの重要な原則です．
- ポータビリティ(移植性)
- セキュリティ(安全性)

> We need to maintain these key principles as we move to outside-the-browser use cases.

ブラウザの外側に移して利用する場合でもこれらのキーとなる原則を維持する必要があります．

> As it is, POSIX and Unix’s Access Control approach to security don’t quite get us there. Let’s look at where they fall short.

POSIXやUnixのアクセス制御のアプローチをそのまま持っていてもセキュリティを満たすことはできません．
何が足りないのかみていましょう．

> ##### Portability
> POSIX provides source code portability. You can compile the same source code with different versions of libc to target different machines.

##### ポータビリティ(移植性)
POSIXのソースコードは移植性を提供します．
同じソースコードを異なるバージョンの libc でコンパイルし，異なるコンピュータをターゲットにできます．

> But WebAssembly needs to go one step beyond this. We need to be able to compile once and run across a whole bunch of different machines. We need portable binaries.

しかし，WebAssemblyはこれを一歩越える必要があります．
一度のコンパイルで様々なコンピュータで実行できる必要があります．
移植性の高いバイナリを必要としているのです．

> This kind of portability makes it much easier to distribute code to users.

この手の移植性はユーザーにコードを配布するのをより簡単にします．

> For example, if Node’s native modules were written in WebAssembly, then users wouldn’t need to run node-gyp when they install apps with native modules, and developers wouldn’t need to configure and distribute dozens of binaries.

例えば，もし Node のネイティブモジュールがWebAssemblyで書かれていた場合，ユーザはネイティブモジュールをアプリにインストールするときに node-gyp を実行する必要がなくなり，開発者は数十のバイナリを構築して配布を行わなくとも良くなります．

> ##### Security
> When a line of code asks the operating system to do some input or output, the OS needs to determine if it is safe to do what the code asks.

##### セキュリティ(安全性)
コード上でOSに問い合わせをし，何かの入力や出力を行う時，OSはコードからの問い合わせが安全に実行できるかどうかを判断する必要があります．

> Operating systems typically handle this with access control that is based on ownership and groups.

OSは通常所有権やグループに基づいてアクセス制御を利用してこれを行います．

> For example, the program might ask the OS to open a file. A user has a certain set of files that they have access to.

例えば，プログラムがOSに問い合わせてファイルを開こうとした場合があり，ユーザーはアクセスできる特定のファイルセットを持っています．

> When the user starts the program, the program runs on behalf of that user. If the user has access to the file — either because they are the owner or because they are in a group with access — then the program has that same access, too.

ユーザーがプログラムを開始した時，プログラムはユーザーの代わりに実行します．
ユーザーがファイルにアクセスできる場合(ファイルを所有しているかアクセスできるグループのどちらか)，プログラムも同じアクセス権を持ちます．

> This protects users from each other. That made a lot of sense when early operating systems were developed. Systems were often multi-user, and administrators controlled what software was installed. So the most prominent threat was other users taking a peek at your files.

これによりユーザー同士が保護されます．
これは初期のOSが開発された時は理にかなっていました．
システムはマルチユーザーで，管理者によってソフトウェアのインストールが管理されており，
最大の脅威は他のユーザーにあなたのファイルを見られることだったからです．

> That has changed. Systems now are usually single user, but they are running code that pulls in lots of other, third party code of unknown trustworthiness. Now the biggest threat is that the code that you yourself are running will turn against you.

状況は変わりました．
現在のシステムは通常シングルユーザーで，たくさんの安全性のわからないサードパーティのコードを取り込んだコードを実行しています．
現在の最大の脅威は，実行しているコードが利用者に敵対することです．

> For example, let’s say that the library you’re using in an application gets a new maintainer (as often happens in open source). That maintainer might have your interest at heart… or they might be one of the bad guys. And if they have access to do anything on your system — for example, open any of your files and send them over the network — then their code can do a lot of damage.

例えば，あなたが使っているアプリケーションのライブラリが新しいメンテナーを迎えました(オープンソースでは良くあること)．
そのメンテナーは利用者に興味を持っているかもしれないし，もしくは悪者かもしれないです．
そしてもし彼らがあなたのシステム上で何かするためのアクセス権を持っている時(ファイルを開いたり，ネットワークの外にファイルを送るなど)，彼らのコードは多くの被害をもたらす可能性があります．

> This is why using third-party libraries that can talk directly to the system can be dangerous.

これがシステムと直接対話できるサーボパーティのライブラリを使うことが危険な理由です．

> WebAssembly’s way of doing security is different. WebAssembly is sandboxed.

WebAssemblyのセキュリティ方法は異なります．
WebAssemblyはサンドボックスです．

> This means that code can’t talk directly to the OS. But then how does it do anything with system resources? The host (which might be a browser, or might be a wasm runtime) puts functions in the sandbox that the code can use.

これはコードが直接OSと対話できないことを意味します．
ではどうやってシステムリソースを処理するのでしょうか?
ホスト(ブラウザやWasmランタイム)がコード尾が利用できる関数をサンドボックスに渡します．

> This means that the host can limit what a program can do on a program-by-program basis. It doesn’t just let the program act on behalf of the user, calling any system call with the user’s full permissions.

これはホストがプログラムができることをプログラムごとに制限できることを意味します．
これはユーザーに代わってプログラムが動作するだけでなく，ユーザーの全権限でシステムコールを呼び出すことができます．

> Just having a mechanism for sandboxing doesn’t make a system secure in and of itself — the host can still put all of the capabilities into the sandbox, in which case we’re no better off — but it at least gives hosts the option of creating a more secure system.

これは仕組みがあるだけで，サンドボックスがシステムを安全にするわけではありません．
ホストは全ての機能をサンドボックスに入れることができ，その場合は何も良くはありませが，少なくとも安全なシステムを構築する手段を提供します．

> In any system interface we design, we need to uphold these two principles. Portability makes it easier to develop and distribute software, and providing the tools for hosts to secure themselves or their users is an absolute must.,

私たちが設計するあらゆるシステムインターフェースは，これら2つの原則を守る必要があります．
移植性はソフトウェアの配布と開発を簡単にし，そしてホスト自身やユーザーを保護するツールの提供は絶対に必要です．

> ### What should this system interface look like?
> Given those two key principles, what should the design of the WebAssembly system interface be?

### このシステムインターフェースはどのようであるべきか?
2つのキーとなる原則を考慮した時，WebAssemblyのシステムインターフェースはどう設計されるべきでしょう?

> That’s what we’ll figure out through the standardization process. We do have a proposal to start with, though:
> - Create a modular set of standard interfaces
> - Start with standardizing the most fundamental module, wasi-core

それは標準化プロセスを通じて明らかになります．
これらの提案を行う必要があります:
-  標準インターフェースのモジュラーセットを作成する
- 最も基本的な wasi-core モジュールの標準化から始める

> What will be in wasi-core?

wasi-core には何が含まれるでしょう?

> wasi-core will contain the basics that all programs need. It will cover much of the same ground as POSIX, including things such as files, network connections, clocks, and random numbers.

wasi-core には全てのプログラムに必要な基本機能が含まれる必要があります．
これはファイル，ネットワーク接続，時間，乱数を含み，POSIXとほぼ同じ領域をカバーします．

> And it will take a very similar approach to POSIX for many of these things. For example, it will use POSIX’s file-oriented approach, where you have system calls such as open, close, read, and write and everything else basically provides augmentations on top.

これらの多くはPOSIXと非常に良く似た方法を取ります．
例えば，POSIXのファイル志向アプローチを使用します．オープン，クローズ，書き込みなどの基本的なシステムコールがあり，その他の多くは基本的にその上に拡張として提供されます．

> But wasi-core won’t cover everything that POSIX does. For example, the process concept does not map clearly onto WebAssembly. And beyond that, it doesn’t make sense to say that every WebAssembly engine needs to support process operations like fork. But we also want to make it possible to standardize fork.

ですが， wasi-core は POSIX の全てをカバーするわけではありません．
プロセスコンセプトが明確に WebAssembly にマッピングされていません．
全ての WebAssembly エンジンが `fork`のような操作を必要としていると言っても意味がないからです．
一方で `fork` の標準化を可能なものを作りたいとも思っています．

> This is where the modular approach comes in. This way, we can get good standardization coverage while still allowing niche platforms to use only the parts of WASI that make sense for them.

ここでモジュラーアプローチが登場します．
この方法は，ニッチなプラットフォームが必要なWASIの一部のみを使いつつ，適切な標準化を行うことができます．

> Languages like Rust will use wasi-core directly in their standard libraries. For example, Rust’s open is implemented by calling __wasi_path_open when it’s compiled to WebAssembly.

Rustのような言語は標準ライブラリからwasi-core を直接扱うことができます．
例えば，Rustの `open`はWebAssemblyにコンパイルするときに `__wasi_path_open`を呼び出すよう実装されます．

> For C and C++, we’ve created a wasi-sysroot that implements libc in terms of wasi-core functions.

CとC++に対しては， wasi-core関数を実装した libc の wasi-sysroot を作成しました．

> We expect compilers like Clang to be ready to interface with the WASI API, and complete toolchains like the Rust compiler and Emscripten to use WASI as part of their system implementations

Clangのようなコンパイラが WASI API のインターフェースを準備し，
RustコンパイラやEmscriptenのような完全なツールチェーンがシステム実装の一部でWASIを使うことを期待しています．

> How does the user’s code call these WASI functions?

どうやってユーザーコードが WASI 関数を呼び出すのでしょう?

> The runtime that is running the code passes the wasi-core functions in as imports.

コードを実行しているランタイムは wasi-core関数をインポートして渡します．

> This gives us portability, because each host can have their own implementation of wasi-core that is specifically written for their platform — from WebAssembly runtimes like Mozilla’s wasmtime and Fastly’s Lucet, to Node, or even the browser.

これは移植性をもたらします．それぞれのホスト(MozillaのwasmtimeやFastlyのLucetのようなWebAssemblyライタイムやNode，その他のブラウザ)はプラットフォームのための独自実装の wasi-core を持つことができます．

> It also gives us sandboxing because the host can choose which wasi-core functions to pass in — so, which system calls to allow — on a program-by-program basis. This preserves security.

ホストはどのwasi-core関数を渡すのか(どのシステムコールを許可するのか)をプログラムごとに選択できるため，サンドボックスを提供できます．
これによりセキュリティを維持できます．

> WASI gives us a way to extend this security even further. It brings in more concepts from capability-based security.

WASIはこの安全性をさらに拡張する方法を提供します．
機能ベースのセキュリティから多くの概念を導入します．

> Traditionally, if code needs to open a file, it calls open with a string, which is the path name. Then the OS does a check to see if the code has permission (based on the user who started the program).

伝統的に，コードがファイルを開く必要がある場合は，ファイルパス名を文字列として`open`を呼び出します．
OSはコードが権限を持っているか(実行したユーザーに基づいて)確認します．

> With WASI, if you’re calling a function that needs to access a file, you have to pass in a file descriptor, which has permissions attached to it. This could be for the file itself, or for a directory that contains the file.

WASIの場合，もしファイルアクセスする必要がある関数を呼び出す場合，権限を付与したファイル記述子を渡す必要があります．
これはファイル自体，もしくはファイルを含むディレクトリに関するものかもしれません．

> This way, you can’t have code that randomly asks to open /etc/passwd. Instead, the code can only operate on the directories that are passed in to it.

この方法では，`/etc/passwd`を開くことをランダムに要求するコードは使用できません．
その代わり，コードは渡された1つのディレクトリ上でのみ動作します．

> This makes it possible to safely give sandboxed code more access to different system calls — because the capabilities of these system calls can be limited.

このようにシステムコールの機能は制限できるため，サンドボックスコードにさまざまなシステムコールへのアクセスを安全に与えることができるようになります．

> And this happens on a module-by-module basis. By default, a module doesn’t have any access to file descriptors. But if code in one module has a file descriptor, it can choose to pass that file descriptor to functions it calls in other modules. Or it can create more limited versions of the file descriptor to pass to the other functions.

そしてこれはモジュールごとに発生します．
デフォルトでは，モジュールはファイル記述子へアクセスできません．
ただし，一つのモジュールのコードがファイル記述子を持っている場合，
そのファイル記述子を他のモジュールで呼び出す関数に渡すことを選択することができます．
もしくはより制限したバージョンのファイル記述子を作成他のモジュールへ渡すことができます．

> So the runtime passes in the file descriptors that an app can use to the top level code, and then file descriptors get propagated through the rest of the system on an as-needed basis.

そのため，ランタイムがトップレベルのコードにアプリが利用できるファイル記述子を渡し，そのファイル記述子をシステムの残りの部分に必要に応じて伝播します．

> This gets WebAssembly closer to the principle of least privilege, where a module can only access the exact resources it needs to do its job.

これによりWebAssemblyは最小権限の原則に近づき，モジュールはジョブを実行するのに必要な正確なリソースのみにアクセスできます．

> These concepts come from capability-oriented systems, like CloudABI and Capsicum. One problem with capability-oriented systems is that it is often hard to port code to them. But we think this problem can be solved.

これらのコンセプトはCloudABIやCapsicumなどの機能志向システムからきています．
機能志向システムの問題の一つは，コードの移植が難しいことです．
しかし，WebAssemblyこの問題を解決できるでしょう．

> If code already uses openat with relative file paths, compiling the code will just work.

もし既にコードが相対ファイルパスで `openat`を利用している場合，コードをコンパイルしても問題なく動きます．

> If code uses open and migrating to the openat style is too much up-front investment, WASI can provide an incremental solution. With libpreopen, you can create a list of file paths that the application legitimately needs access to. Then you can use open, but only with those paths.

もしコードが `open`を使用しており，`openat`を利用する形式に移行するのに多くの先行投資が必要になる場合，
WASIは段階的なソリューションを提供できます．
`libpreopen`を利用すると，アプリケーションが正統にアクセスする必要があるファイルパスのリストを作成できます，
その後も `open`を利用できますが，そのパスのみに制限されます．

> ### What’s next?
> We think wasi-core is a good start. It preserves WebAssembly’s portability and security, providing a solid foundation for an ecosystem.

### 次は何?
wasi-coreは良いスタートだと考えています．
WebAssemblyの移植性と安全性を維持し，強固な基盤をエコシステムに提供します．

> But there are still questions we’ll need to address after wasi-core is fully standardized. Those questions include:
> - asynchronous I/O
> - file watching
> - file locking

しかし wasi-coreが完全に標準化された後にも対処する必要がある問題がまだあります．
- 非同期 I/O
- ファイルかんし
- ファイルロック

> This is just the beginning, so if you have ideas for how to solve these problems, join us!

これはまだ始まりに過ぎません．
これらの問題を解決するアイデアを持っている場合は参画してください．
