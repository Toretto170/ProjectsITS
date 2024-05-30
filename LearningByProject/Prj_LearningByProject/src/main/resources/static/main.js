const fileInput = document.getElementById('fileInput');
const textArea = document.getElementById('testo');
const bottoneAnalisi = document.getElementById('analisi_testo');
const classeImmettiFile = document.getElementsByClassName('immetti-file');
const formRisposta = document.getElementById('form-risposta');
const formRichiesta = document.getElementsByClassName('analisi')[0];


//Eventlistener per attivare la funzione intoTextArea
fileInput.addEventListener('change', intoTextArea);


// Funzione per caricare il file nella textarea
function intoTextArea(){

    const file = fileInput.files[0];
    const reader = new FileReader();
    reader.onload = function(event) {
      var text = event.target.result;
      console.log(text);
      textArea.value = text;
    };

    reader.onerror = function(event) {
      console.error("Errore durante la lettura del file:", event.target.error);
      $('#myModal').modal('show');
    };

    reader.readAsText(file);

};

// Funzione per gestire la pagina una volta che si clicca Analisi
function modificaPagina(){

  textArea.setAttribute('readonly', true);
  bottoneAnalisi.style.display = "none";
 
  for (var i = 0; i < classeImmettiFile.length; i++) {
    classeImmettiFile[i].style.display = "none";
  }
   


  // formRichiesta.innerHTML += "<button type='button' class='btn btn-danger' id='reset-page' onclick='resetPage()'>RESET</button>"
  newBtn = document.createElement('button')
  newBtn.classList.add('btn')
  newBtn.classList.add('btn-danger') 
  newBtn.id = 'reset-page'
  newBtn.setAttribute("onclick","resetPage();")
  newBtn.textContent = 'RESET'
  formRichiesta.appendChild(newBtn)
}

//Funzione Reset per riutilizzare la pagina
function resetPage() {
  textArea.value = "";
  textArea.removeAttribute('readonly');
  bottoneAnalisi.style.display = "block";
  
  for (var i = 0; i < classeImmettiFile.length; i++) {
    classeImmettiFile[i].style.display = "block";
  }
  
  // Rimuovi il bottone di reset
  var resetButton = document.getElementById('reset-page');
  resetButton.parentNode.removeChild(resetButton);

  // Rimuovi file input
  fileInput.value = null;

  // Rimuovi gli elementi aggiunti dalla funzione getFile()
  while (document.getElementById('risultato').firstChild) {
    document.getElementById('risultato').removeChild(document.getElementById('risultato').firstChild);
  }

  formRisposta.style.display = "none";

}


// Connessione ad API via POST
function postFile() {
  bottoneAnalisi.style.display = 'none';
  var text = textArea.value;
  return new Promise(function(resolve, reject) {
    const URLPOST = 'http://localhost:9020/api/process';
    let request = new XMLHttpRequest();

    request.open('POST', URLPOST);
    request.setRequestHeader('Content-Type', 'text/plain');

    request.onload = function() {  
      if (request.status === 200) {
        console.log("File caricato correttamente.");
        resolve();
      } else {
        console.error("File non caricato. Richiesta POST non andata a buon fine. Codice Errore:", request.statusText);
        reject(new Error(request.statusText));
        $('#myModal').modal('show');
        //Cancella il db quando si crasha
        //deleteFile();
      }
    };

    request.onerror = function() {
      console.error('File non caricato. Richiesta POST non risulta essere inviata');
      reject(new Error('Errore di connessione'));
      $('#myModal').modal('show');
    };

    request.send(text);
  });
}

// Connessione ad API via GET
function getFile() {
  formRisposta.removeAttribute('style');

  return fetch('http://localhost:9020/api/analisi')
    .then(function(response) {
      if (response.ok) {
      	console.log("Dati scaricati correttamente.");
        return response.json();
      } else {
        throw new Error("Errore durante la richiesta GET");
      }
    })
    .then(function(data) {
      data.forEach(function(item) {
        var listItem = document.createElement("li");
        listItem.textContent = item;
        document.getElementById('risultato').appendChild(listItem);
      });
    })
    .catch(function(error) {
      console.error(error);
      $('#myModal').modal('show');
    });
}

// Connessione ad API via GET
function getJSON() {

  return new Promise(function(resolve, reject) {
    const URLGETJSON = 'http://localhost:9020/api/analisiJSON';
    let request = new XMLHttpRequest();

    request.open('GET', URLGETJSON);
    request.setRequestHeader('Content-Type', 'application/json');

    request.onload = function() {
      if (request.status === 200) {
        console.log(request.responseText);
        resolve();
      } else {
        console.error("JSON non scaricato. Codice Errore:", request.statusText);
        reject(new Error(request.statusText));
      }
    };

    request.onerror = function() {
      console.error('JSON non scaricato');
      reject(new Error('Errore di connessione'));
    };

    request.send();
  });

}

// Connessione ad API via DELETE
function deleteFile() {
  return new Promise(function(resolve, reject) {
    const URLDELETE = 'http://localhost:9020/api/svuota';
    let request = new XMLHttpRequest();

    request.open('DELETE', URLDELETE);
    request.setRequestHeader('Content-Type', 'application/json');

    request.onload = function() {
      if (request.status === 200) {
        console.log("File eliminato correttamente.");
        resolve();
      } else {
        console.error("File non eliminato. Richiesta DELETE non andata a buon fine. Codice Errore:", request.statusText);
        reject(new Error(request.statusText));
        document.getElementsByClassName("modal-body text-center").textContent('File non eliminato');
        $('#myModal').modal('show');
      }
    };

    request.onerror = function() {
      console.error('File non eliminato. Richiesta DELETE non risulta essere inviata');
      reject(new Error('Errore di connessione'));
      $('#myModal').modal('show');
    };

    request.send();
  });
}


// Fa tutte e tre le cose e gestisce la modale di errore
function callAPI() {

  if(textArea.value.replace(/\s+/g, "") == "") {
    console.error("Errore: nessun testo da analizzare");
    textArea.value = "";
    $('#myModal').modal('show');}

  else {
  
  postFile()
    .then(function() {
      return getFile();
    })
    .then(function() {
      modificaPagina();
      return deleteFile();
    })
    .then(function() {
      console.log("Tutte le operazioni sono state completate con successo.");
    })
    .catch(function(error) {
      console.error("Errore durante l'esecuzione delle operazioni:", error);
    });
  }
}
