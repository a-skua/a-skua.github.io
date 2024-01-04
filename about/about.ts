import { css, html, LitElement } from "npm:lit";

export class MyBook extends LitElement {
  private imgAlt: string;
  private imgSrc: string;

  static properties = {
    imgAlt: { attribute: "img-alt" },
    imgSrc: { attribute: "img-src" },
    describe: {},
  };

  static styles = [
    css`
      :host {
        display: flex;
        gap: 1em;
        padding: 1em;
        border: solid 1px;
        margin-top: 1em;
      }
      img {
        max-width: 25%;
      }
      div {
        flex: auto;
      }
    `,
  ];

  constructor() {
    super();
    this.imgAlt = "Undefined Image";
    this.imgSrc = "/undefined.png";
  }

  render() {
    return html`
      <img alt="${this.imgAlt}" src="${this.imgSrc}">
      <div><slot>Undefined Describe</slot></div>
    `;
  }
}

customElements.define("my-book", MyBook);
