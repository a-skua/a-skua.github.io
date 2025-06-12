import * as React from "npm:react";

export const title = "About";

export const layout = "layouts/main.njk";
declare global {
  namespace JSX {
    interface IntrinsicElements {
      "my-book": React.DetailedHTMLProps<
        React.HTMLAttributes<HTMLElement>,
        HTMLElement
      >;
    }
  }
}

export default (_data: Lume.Data, _helpers: Lume.Helpers) => (
  <>
    <p>
      <a href="https://recruit.monicle.co.jp/" target="_blank">株式会社モニクル</a>に所属するソフトウェアエンジニア．
    </p>
    <section>
      <h2>著書</h2>
      <my-book
        img-alt="「WebAssembly Cookbook vol.3」表紙"
        img-src="https://techbookfest.org/api/image/wrz3KYMyxeB6Pqi02GeQ0j.png?size=432"
      >
        <h3>WebAssembly Cookbook vol.3</h3>
        <p>
          技術書典18にて配布した同人誌．
          <hr />
          <a
            href="https://techbookfest.org/product/eaB0rRWarUMVQNQzdXuT67"
            target="_blank"
          >
            技術書典マーケット
          </a>
        </p>
      </my-book>
      <my-book
        img-alt="「WebAssembly Cookbook vol.2」表紙"
        img-src="https://techbookfest.org/api/image/mEaxJThE6bZF2Sb3KisJ0G.png?size=432"
      >
        <h3>WebAssembly Cookbook vol.2</h3>
        <p>
          技術書典17にて配布した同人誌．
          <hr />
          <a
            href="https://techbookfest.org/product/7CHqqtaeaRYrwDwQNCX0T7"
            target="_blank"
          >
            技術書典マーケット
          </a>
        </p>
      </my-book>
      <my-book
        img-alt="「WebAssembly System Interface入門」表紙"
        img-src="https://nextpublishing.jp/wp-content/uploads/2024/09/N01992.jpg"
      >
        <h3>WebAssembly System Interface入門</h3>
        <p>
          WASI 0.1，0.2の仕様を網羅した解説書．
          <hr />
          <a
            href="https://nextpublishing.jp/book/18115.html"
            target="_blank"
          >
            購入はこちらから
          </a>
        </p>
      </my-book>
      <my-book
        img-alt="「WebAssembly Cookbook vol.1」表紙"
        img-src="https://techbookfest.org/api/image/w8E01zAy5AwP6GSiUdmwAF.png?size=432"
      >
        <h3>WebAssembly Cookbook vol.1</h3>
        <p>
          技術書典16にて配布した同人誌．
          AssemblyScriptとDartを使ったWebAssemblyの使用例などを紹介する本です．
          <hr />
          <a
            href="https://techbookfest.org/product/b0Dp5Remzfe0a6M276Sw0a"
            target="_blank"
          >
            技術書典マーケット
          </a>
        </p>
      </my-book>
      <my-book
        img-alt="「ご注文はWASIですか??」表紙"
        img-src="https://techbookfest.org/api/image/khucwMzFNtMT0ANtsMWdRR.png?size=432"
      >
        <h3>ご注文はWASIですか??</h3>
        <p>
          技術書典16にて配布した同人誌．
          「ご注文はWASIですか?」の続編で，WASI 0.2の仕様を紹介する本です．
          <hr />
          <a
            href="https://techbookfest.org/product/8Fshgy7YrSyQGGYkyb4u0a"
            target="_blank"
          >
            技術書典マーケット
          </a>
        </p>
      </my-book>
      <my-book
        img-alt="「ご注文はWASIですか?」表紙"
        img-src="https://techbookfest.org/api/image/6P7WKtLMNJ46NR7P3VHWGD.png?size=432"
      >
        <h3>ご注文はWASIですか?</h3>
        <p>
          技術書典15にて配布した同人誌．
          WASI 0.1の仕様を紹介する本です．
          <hr />
          <a
            href="https://techbookfest.org/product/acW1EbS9XxshmBnDUeZtxj"
            target="_blank"
          >
            技術書典マーケット
          </a>
        </p>
      </my-book>
      <my-book
        img-alt="「実践入門WebAssembly」表紙"
        img-src="https://nextpublishing.jp/wp-content/uploads/2023/10/N01871.jpg"
      >
        <h3>実践入門WebAssembly</h3>
        <p>
          2023年10月27日発売の商業誌．
          技術書典14にて配布した「WebAssemblyで出来ること」を再編集した内容になります．
          <hr />
          <a href="https://nextpublishing.jp/book/17203.html" target="_blank">
            購入はこちらから
          </a>
        </p>
      </my-book>
      <my-book
        img-alt="「WebAssemblyで出来ること」表紙"
        img-src="https://techbookfest.org/api/image/8SsPrQznVerQtphmDU1HqJ.png?size=432"
      >
        <h3>WebAssemblyで出来ること</h3>
        <p>
          技術書典14にて配布した同人誌．
          WebAssemblyの基本的な仕様を紹介する本です．
          <hr />
          <a
            href="https://techbookfest.org/product/2uwxPNE7mLKksHSFr88X17"
            target="_blank"
          >
            技術書典マーケット
          </a>
        </p>
      </my-book>
    </section>
    <script type="module" src="./about.js"></script>
  </>
);
