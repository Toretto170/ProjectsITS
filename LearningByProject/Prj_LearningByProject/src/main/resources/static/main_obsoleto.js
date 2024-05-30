// Seleziono il div del risultato usando il suo id
var risultato = document.getElementById("risultato");

// Aggiungo un evento al div del risultato quando il mouse passa sopra
risultato.addEventListener("mouseover", function() {
  // Cambio il colore di sfondo del div del risultato a rosa
  risultato.style.backgroundColor = "pink";
});

// Aggiungo un altro evento al div del risultato quando il mouse esce
risultato.addEventListener("mouseout", function() {
  // Cambio il colore di sfondo del div del risultato a quello originale
  risultato.style.backgroundColor = "lightblue";
});