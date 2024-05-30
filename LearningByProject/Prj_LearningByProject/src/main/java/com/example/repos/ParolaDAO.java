package com.example.repos;

import java.util.ArrayList;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import com.example.entities.Parola;

public interface ParolaDAO extends JpaRepository<Parola, Integer>{
	
	@Query(value = "SELECT AVG(conteggio_caratteri) AS avg_caratteri_parola FROM ( SELECT LENGTH(testo_parola) AS conteggio_caratteri FROM parola ) AS conteggio_tabella;", nativeQuery = true)    
	double getNumeroMedioCaratteriPerParola();
	
	@Query(value = "SELECT MAX(conteggio_caratteri) AS caratteri_parola_piu_lunga FROM (SELECT LENGTH(testo_parola) AS conteggio_caratteri FROM parola) AS conteggio_tabella;", nativeQuery = true)	 
	int getNumeroCaratteriParolaPiuLunga();

	@Query(value = "SELECT MIN(conteggio_caratteri) AS caratteri_parola_piu_corta FROM (SELECT LENGTH(testo_parola) AS conteggio_caratteri FROM parola) AS conteggio_tabella;", nativeQuery = true)	 
	int getNumeroCaratteriParolaPiuCorta();
	 
	@Query(value = "SELECT AVG(numero_parole) AS media_parole_per_frase FROM (SELECT COUNT(*) AS numero_parole FROM parola GROUP BY frase_fk_id) AS conteggio_parole;", nativeQuery = true)	 
	double getNumeroMedioParolePerFrase();
	 
	@Query(value = "SELECT testo_parola FROM parola WHERE LENGTH(testo_parola) = (SELECT MAX(LENGTH(testo_parola)) FROM parola );", nativeQuery = true)	 
	ArrayList<String> getContenutoParolaPiuLunga();

	@Query(value = "SELECT DISTINCT testo_parola FROM parola WHERE LENGTH(testo_parola) = (SELECT MIN(LENGTH(testo_parola)) FROM parola );", nativeQuery = true)	 
	ArrayList<String> getContenutoParolaPiuBreve();
	 
	@Query(value = "SELECT COUNT(*) AS numero_parole FROM parola;", nativeQuery = true)	 
	int getNumeroParole();
	
	@Query(value = "SELECT testo_parola FROM ( SELECT testo_parola, COUNT(*) as conteggio FROM parola GROUP BY testo_parola ) AS conteggi WHERE conteggio = ( SELECT MAX(conteggio) FROM ( SELECT COUNT(*) as conteggio FROM parola GROUP BY testo_parola ) AS max_conteggi );", nativeQuery = true)	 
	ArrayList<String> getParolaPiuUsataTesto();
	
	@Query(value = "SELECT conteggio FROM ( SELECT testo_parola, COUNT(*) as conteggio FROM parola GROUP BY testo_parola ) AS conteggi WHERE conteggio = ( SELECT MAX(conteggio) FROM ( SELECT COUNT(*) as conteggio FROM parola GROUP BY testo_parola ) AS max_conteggi LIMIT 1);", nativeQuery = true)	 
	int getNumeroParolaPiuUsataTesto();
	
	@Query(value = "SELECT SUM(LENGTH(testo_parola)) AS sum_testo FROM parola", nativeQuery = true)	    
    int getNumeroLettereTotali();
	
	@Query(value = "SELECT testo_parola FROM ( SELECT testo_parola, COUNT(*) as conteggio FROM parola WHERE frase_fk_id = :fraseId GROUP BY testo_parola ) AS conteggi WHERE conteggio = ( SELECT MAX(conteggio) FROM ( SELECT COUNT(*) as conteggio FROM parola WHERE frase_fk_id = :fraseId GROUP BY testo_parola ) AS max_conteggi );", nativeQuery = true)	 
	ArrayList<String> getParolaPiuUsataInOgniFrase(@Param("fraseId") int fraseId);
	
	@Query(value = "SELECT conteggio FROM ( SELECT testo_parola, COUNT(*) as conteggio FROM parola WHERE frase_fk_id = :fraseId GROUP BY testo_parola ) AS conteggi WHERE conteggio = ( SELECT MAX(conteggio) FROM ( SELECT COUNT(*) as conteggio FROM parola WHERE frase_fk_id = :fraseId GROUP BY testo_parola ) AS max_conteggi LIMIT 1);", nativeQuery = true)	 
	int getNumeroParolaPiuUsataInOgniFrase(@Param("fraseId") int fraseId);
	
	@Query(value = "SELECT COUNT(*) as numeroParole FROM parola WHERE frase_fk_id = :fraseId GROUP BY frase_fk_id", nativeQuery = true)
	int getNumeroParolePerFrase(@Param("fraseId") int fraseId);
	
	@Query(value = "SELECT testo_parola FROM ( " +
	        "SELECT testo_parola, MAX(LENGTH(testo_parola)) as lunghezza " +
	        "FROM parola WHERE frase_fk_id = :fraseId " +
	        "GROUP BY frase_fk_id, testo_parola) AS parole " +
	        "WHERE lunghezza = (SELECT MAX(lunghezza) " +
	        "FROM (SELECT MAX(LENGTH(testo_parola)) as lunghezza " +
	        "FROM parola WHERE frase_fk_id = :fraseId " +
	        "GROUP BY frase_fk_id, testo_parola) AS max_lunghezza);", nativeQuery = true)
	ArrayList<String> getParolaPiuLungaInOgniFrase(@Param("fraseId") int fraseId);

	
	
    @Modifying
    @Transactional
    @Query(value = "ALTER TABLE parola AUTO_INCREMENT = 1", nativeQuery = true)
    void resetAutoIncrement();
}
