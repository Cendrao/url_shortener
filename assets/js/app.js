import "../css/app.css"

import "phoenix_html"

var copyBtn = document.querySelector('.js-copy-button');

copyBtn.addEventListener('click', function (event) {
  var copyArea = document.querySelector('.js-copyarea');
  copyArea.focus();
  copyArea.select();

  document.execCommand('copy');
});
