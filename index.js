function laCajaDePandora(numero){
  if(numero % 2 === 0){
    return numero.toString(2); // binario
  } else {
    return numero.toString(16); // hexadecimal
  }
}

function eliana(){
  return {
    nombre: "Eliana",
    edad: 34,
    nacionalidad: "Argentina"
  }
}

