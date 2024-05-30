package com.example.repos;

import java.util.ArrayList;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import com.example.entities.Frase;

public interface FraseDAO extends JpaRepository<Frase, Integer>{

    	@Query(value = "SELECT AVG(LENGTH(testo_frase)) AS avg_caratteri_frase FROM frase", nativeQuery = true)
	    double getNumeroMedioCaratteriPerFrase();

    	@Query(value = "SELECT MAX(LENGTH(testo_frase)) AS caratteri_frase_piu_lunga FROM frase", nativeQuery = true)	    
    	int getNumeroCaratteriFrasePiuLunga();

	    @Query(value = "SELECT MIN(LENGTH(testo_frase)) AS caratteri_frase_piu_corta FROM frase", nativeQuery = true)	    
	    int getNumeroCaratteriFrasePiuCorta();

	    @Query(value = "SELECT testo_frase FROM frase WHERE LENGTH(testo_frase) = (SELECT MAX(LENGTH(testo_frase)) FROM frase)", nativeQuery = true)	    
	    ArrayList<String> getContenutoFrasePiuLunga();

	    @Query(value = "SELECT testo_frase FROM frase WHERE LENGTH(testo_frase) = (SELECT MIN(LENGTH(testo_frase)) FROM frase)", nativeQuery = true)	    
	    ArrayList<String> getContenutoFrasePiuBreve();
	    
	    @Query(value = "SELECT SUM(LENGTH(testo_frase)) AS sum_testo FROM frase", nativeQuery = true)	    
	    int getNumeroCaratteriTotali();
	    
	    @Query(value = "SELECT COUNT(*) AS numero_frasi FROM frase", nativeQuery = true)	    
	    int getNumeroFrasi();
	    
	    @Query(value = "SELECT testo_frase FROM frase WHERE id = :fraseId", nativeQuery = true)	    
	    String getTestoFrase(@Param("fraseId") int fraseId);
	    
	    
	    @Modifying
	    @Transactional
	    @Query(value = "ALTER TABLE frase AUTO_INCREMENT = 1", nativeQuery = true)
	    void resetAutoIncrement();
	    
	
}
