package com.example.script;

import java.util.ArrayList;
import java.util.List;

public class Frase {
    private List<Parola> frase;

    public Frase(List<String> _frase) throws ScriptException {
        setFrase(_frase);
    }

    // Verifica se la lista di stringhe passata come parametro rappresenta una frase valida
    private void isFrase(List<String> _param) throws ScriptException {
        List<Parola> _frase = new ArrayList<Parola>();
        for (String string : _param) {
            Parola temp;
            try {
                temp = new Parola(string);
            } catch (ScriptException e) {
                throw new ScriptException(
                    "Parametro '_frase' non valido, errore all'indice: "
                    .concat(Integer.toString(_param.indexOf(string)))
                    .concat(e.getMessage())
                );
            }
            _frase.add(temp);
        }
        this.frase = _frase;
    }

    // Restituisce la lista di oggetti Parola che compongono la frase
    public List<Parola> getFrase() {
        return this.frase;
    }

    // Imposta la frase utilizzando una lista di stringhe e verifica la validità
    public void setFrase(List<String> _frase) throws ScriptException {
        isFrase(_frase);
    }
}
