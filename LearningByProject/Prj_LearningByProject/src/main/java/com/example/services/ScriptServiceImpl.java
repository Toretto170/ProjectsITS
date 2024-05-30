package com.example.services;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.stereotype.Service;

import com.example.entities.Parola;
import com.example.entities.Frase;
import com.example.repos.ParolaDAO;

import jakarta.persistence.EntityManager;

import com.example.repos.FraseDAO;

@Service
public class ScriptServiceImpl implements ScriptService {

    @Autowired
    private FraseDAO fraseDao;
    @Autowired
    private ParolaDAO parolaDao;

    @Override
    public void creaParola(String parola, Frase frase) {
        Parola p = new Parola();
        p.setTestoParola(parola);
        p.setFraseFk(frase);
        parolaDao.save(p);
    }

    @Override
    public Frase creaFrase(String frase) {
        Frase f = new Frase();
        f.setTestoFrase(frase);
        return fraseDao.save(f);
    }
    
    
    @Override
    public ArrayList<String> analisi() {
		
    	ArrayList<String> analisi = new ArrayList<String>();
		int numeroFrasi = fraseDao.getNumeroFrasi();

    	    	
		analisi.add("Numero di parole nel testo: " +  parolaDao.getNumeroParole());
		analisi.add("Numero di frasi nel testo: " + fraseDao.getNumeroFrasi());
		
		for (int i=1; i<=numeroFrasi; i++) {
			
			analisi.add("Per la frase '" + fraseDao.getTestoFrase(i) + "' ci sono: " + parolaDao.getNumeroParolePerFrase(i) + " parole");
			
		}
		
		analisi.add("La parola o parole più usata/e nel testo: " + stampaArraylist(parolaDao.getParolaPiuUsataTesto()) + "per " + parolaDao.getNumeroParolaPiuUsataTesto() + " volta/e");

		
		for (int c=1; c<=numeroFrasi; c++) {
			
			analisi.add("La parola o parole più usata/e per '" + fraseDao.getTestoFrase(c) + "' è o sono: " + (stampaArraylist(parolaDao.getParolaPiuUsataInOgniFrase(c))) + "per " + parolaDao.getNumeroParolaPiuUsataInOgniFrase(c) + " volta/e");
			
		}
		
		analisi.add("La parola più lunga risulta essere: " + stampaArraylist(parolaDao.getContenutoParolaPiuLunga()));
		
		
		for (int k=1; k<=numeroFrasi; k++) {
			
			analisi.add("La parola più lunga o le parole più lunghe per '" + fraseDao.getTestoFrase(k) + "' è o sono: " + (stampaArraylist(parolaDao.getParolaPiuLungaInOgniFrase(k))));
			
		}
		
		
		//Troppa roba meglio togliere -- altrimenti si intasa la pagina
		//analisi.add("Numero di lettere nel testo: " + parolaDao.getNumeroLettereTotali());
		//analisi.add("Numero di caratteri nel testo: " + fraseDao.getNumeroCaratteriTotali());
		//analisi.add("Numero medio caratteri per frase: " + fraseDao.getNumeroMedioCaratteriPerFrase());
		//analisi.add("Numero medio caratteri per parola: " + parolaDao.getNumeroMedioCaratteriPerParola());
		//analisi.add("Numero medio di parole per frase: " + parolaDao.getNumeroMedioParolePerFrase());
		//analisi.add("Numero di caratteri della frase più lunga: " + fraseDao.getNumeroCaratteriFrasePiuLunga());
		//analisi.add("Numero di caratteri della frase più breve: " + fraseDao.getNumeroCaratteriFrasePiuCorta());
		//analisi.add("Numero di caratteri della parola più lunga: " + parolaDao.getNumeroCaratteriParolaPiuLunga());
		//analisi.add("Numero di caratteri della parola più breve: " + parolaDao.getNumeroCaratteriParolaPiuCorta());
    	//analisi.add("La frase più lunga risulta essere: " + stampaArraylist(fraseDao.getContenutoFrasePiuLunga()));
		//analisi.add("La frase più breve risulta essere: " + stampaArraylist(fraseDao.getContenutoFrasePiuBreve()));
		//analisi.add("La parola più breve risulta essere: " + stampaArraylist(parolaDao.getContenutoParolaPiuBreve()));

		
		
		
    	return analisi;
    	
    }

	@Override
	public String stampaArraylist(ArrayList<String> lista) {
		String result = "";
		for (String string : lista) {
			result += "[" + string + "] ";
		}
		return result;
	}

	@Override
	public void cancellaRecords() {
		parolaDao.deleteAll();;
		parolaDao.resetAutoIncrement();
		fraseDao.deleteAll();;
		fraseDao.resetAutoIncrement();
		
	}

	@Override
	public Map<String, Object> analisiJSON() {
		
		int numeroFrasi = fraseDao.getNumeroFrasi();
		Map<String, Object> analisi = new HashMap<>();
		
		analisi.put("paroleInTesto", getNumeroParoleJSON(parolaDao.getNumeroParole()));
		analisi.put("frasiInTesto", getNumeroParoleJSON(fraseDao.getNumeroFrasi()));
		analisi.put("numeroParolePerFrase", getNumeroParolePerFraseJSON(numeroFrasi));
		analisi.put("parolaPiuUsata", getParolaPiuUsataJSON());
		analisi.put("parolaPiuUsataPerFrase", getParolaPiuUsataPerFraseJSON(numeroFrasi));
		analisi.put("parolaPiuLunga", parolaDao.getContenutoParolaPiuLunga());
		analisi.put("parolaPiuLungaPerFrase", getParolaPiuLungaPerFraseJSON(numeroFrasi));
		
		return analisi;
	}

	@Override
	public Integer getNumeroParoleJSON(int funzioneCheRestituisceNumero) {
		
		Integer value = funzioneCheRestituisceNumero;
		
		return value;
	}

	@Override
	public Map<String, Integer> getNumeroParolePerFraseJSON(int numeroFrasi) {
		
		Map<String, Integer> map1 = new HashMap<>();
		
		
		for (int i=1; i<=numeroFrasi; i++) {
			
			map1.put(fraseDao.getTestoFrase(i), parolaDao.getNumeroParolePerFrase(i));
		}
		
		return map1;
	}

	@Override
	public Map<String, Object> getParolaPiuUsataJSON() {
		Map<String, Object> map2 = new HashMap<>();
		
		ArrayList<String> lista1 = new ArrayList<>();
		lista1 = parolaDao.getParolaPiuUsataTesto();

		
			map2.put("parole", lista1);
			map2.put("volte", parolaDao.getNumeroParolaPiuUsataTesto());
			
		
		
		return map2;
	}

	@Override
	public Map<String, Object> getParolaPiuUsataPerFraseJSON(int numeroFrasi) {

		Map<String, Object> map3 = new HashMap<>();
				
		
		for (int c=1; c<=numeroFrasi; c++) {
				
		map3.put(fraseDao.getTestoFrase(c), helpGetParolaPiuUsataPerFraseJSON(c));
		
		
		}
		
		
		return map3;
	}

	

	@Override
	public Map<String, ArrayList<String>> getParolaPiuLungaPerFraseJSON(int numeroFrasi) {
		
		Map<String, ArrayList<String>> map5 = new HashMap<>();
		
		for (int k=1; k<=numeroFrasi; k++) {
			
			map5.put(fraseDao.getTestoFrase(k), parolaDao.getParolaPiuLungaInOgniFrase(k));
		}
		
		return map5;
	}


	@Override
	public Map<String, Object> helpGetParolaPiuUsataPerFraseJSON(int indexFrase) {
		
		Map<String, Object> map4 = new HashMap<>();
		ArrayList<String> lista2 = new ArrayList<>();
		lista2 = parolaDao.getParolaPiuUsataInOgniFrase(indexFrase);
		
		map4.put("parole", lista2);
		map4.put("volte", parolaDao.getNumeroParolaPiuUsataInOgniFrase(indexFrase));
		
		
		
		return map4;
	}





}
