package com.example.integration;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import com.example.script.Frase;
import com.example.script.Parola;
import com.example.script.Script;
import com.example.script.ScriptException;
import com.example.services.ScriptServiceImpl;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
@RequestMapping("api")
public class ControllerREST {
	
	@Autowired
	private ScriptServiceImpl serviceimpl;
	
	@GetMapping("/analisi")
	public ArrayList<String> getAnalisi() {
		return serviceimpl.analisi();
	}
	
	@GetMapping("/analisiJSON")
	public String getAnalisiJSON() {
		
		Map<String, Object> result = new HashMap<>();
		result = serviceimpl.analisiJSON();
		
		ObjectMapper objectMapper = new ObjectMapper();
		String jsonString = "";
		try {
		    jsonString = objectMapper.writeValueAsString(result);
		    //System.out.println(jsonString);
		    return jsonString;
		} catch (JsonProcessingException e) {
		    e.printStackTrace();
		    jsonString = "Qualcosa è andato storto";
		}
		
		return jsonString;
		
	}
	
	
	@DeleteMapping("/svuota")
	public void svuotaTabelle() {
		serviceimpl.cancellaRecords();
	}
	
    @PostMapping("/process")
    public ResponseEntity<List<Frase>> processText(@RequestBody String text) {
        try {
            // Chiamiamo i metodi nella classe Script per suddividere il testo in parole e frasi
            List<Frase> result = Script.leggiPerFrasiParole(text);
            List<String> result2 = Script.leggiPerFrasi(text);
            
            //Contatore necessario per riuscire ad asscociare le parole alle frasi
            int scorriListaFrasi = 0;
            System.out.println(scorriListaFrasi);

            // Per ogni frase dammi la lista di parole in esso contenuta
            for (Frase frase : result) {
				
                String fraseconpunteggiatura = result2.get(scorriListaFrasi);
                com.example.entities.Frase fraseperdb = serviceimpl.creaFrase(fraseconpunteggiatura);
                
                // Per ogni lista di parole dammi una parola per volta
                for (Parola frase2 : frase.getFrase()) {
                    
                    String parola = frase2.getText();
                    serviceimpl.creaParola(parola, fraseperdb);
                }
                
                scorriListaFrasi++;
			}
            
            
            return ResponseEntity.ok(result);
        
        } catch (ScriptException e) {
            e.printStackTrace();
            
            // Se si verifica un'eccezione, restituisce un errore interno del server
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // Configura il filtro CORS --- altrimenti non funziona l'upload
    @Bean
    public CorsFilter corsFilter() {
        CorsConfiguration config = new CorsConfiguration();
        config.addAllowedOrigin("*");
        config.addAllowedMethod("*");
        config.addAllowedHeader("*");

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);

        return new CorsFilter(source);
    }
}
