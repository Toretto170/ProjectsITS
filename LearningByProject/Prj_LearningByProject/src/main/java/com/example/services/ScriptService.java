package com.example.services;


import java.util.ArrayList;
import java.util.List;
import java.util.Map;


import com.example.entities.Frase;
import com.example.entities.Parola;

public interface ScriptService {

    void creaParola(String parola, Frase frase);
    Frase creaFrase(String frase);
    ArrayList<String> analisi();
    Map<String, Object> analisiJSON();
    Integer getNumeroParoleJSON(int funzioneCheRestituisceNumero);
    Map<String, Integer> getNumeroParolePerFraseJSON(int numeroFrasi);
    Map<String, Object> getParolaPiuUsataJSON();
    Map<String, Object> getParolaPiuUsataPerFraseJSON(int numeroFrasi);
    Map<String, Object> helpGetParolaPiuUsataPerFraseJSON(int indexFrase);
    Map<String, ArrayList<String>> getParolaPiuLungaPerFraseJSON(int numeroFrasi);
    String stampaArraylist(ArrayList<String> lista);
    void cancellaRecords();
}
