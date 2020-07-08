import "../css/phoenix.css";

document.addEventListener("DOMContentLoaded", () => {
  const url = (document.querySelector(
    'meta[name="original-url"]'
  ) as HTMLMetaElement).content;
  const title = (document.querySelector(
    'meta[name="original-title"]'
  ) as HTMLMetaElement).content;
  const $url = document.querySelector("#original-url") as HTMLAnchorElement;

  $url.href = url;
  $url.innerText = title;
});
