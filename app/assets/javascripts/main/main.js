window.onerror = function handleException(msg, url, line) {
  console.error(msg + "\n" + url + ":" + line + ".");

  alert("O sistema encontrou um erro ao processar esta operação. Caso o erro persista favor contactar o administrator do sistema.");

  return false;
};

$(document).ready(function(){
  $(".button-collapse").sideNav();
  $('select').material_select();
})