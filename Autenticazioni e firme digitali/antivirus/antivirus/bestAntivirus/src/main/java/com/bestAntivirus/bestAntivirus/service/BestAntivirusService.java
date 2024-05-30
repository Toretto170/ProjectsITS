package com.bestAntivirus.bestAntivirus.service;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BestAntivirusService {

    /*
     * non metto le interfacce perchè mi scoccio
     */

    private final List<String> virusList;

    public BestAntivirusService(@Qualifier("virusList") List<String> virusList) {
        this.virusList = virusList;
    }

    public String analizzaFile(String value) {
        if(virusList.contains(value)) {
            return "Infected";
        }
        return "Clean";
    }
}
