// Funzione per caricare il file
function leggiFile() {
  return new Promise(function(resolve, reject) {
    const fileInput = document.getElementById('fileInput');
    const file = fileInput.files[0];
    const reader = new FileReader();

    reader.onload = function(event) {
      var text = event.target.result;
      console.log(text);
      postFile(text)
        .then(function() {
          resolve();
        })
        .catch(function(error) {
          reject(error);
        });
    };

    reader.onerror = function(event) {
      console.error("Errore durante la lettura del file:", event.target.error);
      reject(event.target.error);
    };

    reader.readAsText(file);
  });
}

// Connessione ad API via POST
function postFile(testo) {
  var text = testo;

  return new Promise(function(resolve, reject) {
    const URLPOST = 'http://localhost:9020/api/process';
    let request = new XMLHttpRequest();

    request.open('POST', URLPOST);
    request.setRequestHeader('Content-Type', 'text/plain');

    request.onload = function() {
      if (request.status === 200) {
        console.log("Il file è stato caricato correttamente.");
        resolve();
      } else {
        console.error("Il file non è stato caricato. La richiesta non è andata a buon fine. Codice Errore:", request.statusText);
        reject(new Error(request.statusText));
      }
    };

    request.onerror = function() {
      console.error('Il file non è stato caricato. La richiesta non è riuscita ad essere inviata');
      reject(new Error('Errore di connessione'));
    };

    request.send(text);
  });
}

// Connessione ad API via GET
function getFile() {
  return fetch('http://localhost:9020/api/analisi')
    .then(function(response) {
      if (response.ok) {
        return response.json();
      } else {
        throw new Error("Errore durante la richiesta");
      }
    })
    .then(function(data) {
      var dataList = document.getElementById("analisi_testo");
      data.forEach(function(item) {
        var listItem = document.createElement("li");
        listItem.textContent = item;
        dataList.appendChild(listItem);
      });
    })
    .catch(function(error) {
      console.error(error);
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
        console.log("Il file è stato eliminato correttamente.");
        resolve();
      } else {
        console.error("Il file non è stato eliminato. La richiesta non è andata a buon fine. Codice Errore:", request.statusText);
        reject(new Error(request.statusText));
      }
    };

    request.onerror = function() {
      console.error('Il file non è stato eliminato. La richiesta non è riuscita ad essere inviata');
      reject(new Error('Errore di connessione'));
    };

    request.send();
  });
}

// Fa tutte e tre le cose
function callAPI() {
  leggiFile()
    .then(function() {
      return getFile();
    })
    .then(function() {
      return deleteFile();
    })
    .then(function() {
      console.log("Tutte le operazioni sono state completate con successo.");
    })
    .catch(function(error) {
      console.error("Si è verificato un errore durante l'esecuzione delle operazioni:", error);
    });
}
