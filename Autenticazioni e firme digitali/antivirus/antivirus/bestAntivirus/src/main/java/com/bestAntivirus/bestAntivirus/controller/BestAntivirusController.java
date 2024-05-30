package com.bestAntivirus.bestAntivirus.controller;

import com.bestAntivirus.bestAntivirus.service.BestAntivirusService;
import org.springframework.web.bind.annotation.*;

@RestController("BestAntivirusController")
@RequestMapping("/be")
public class BestAntivirusController {

    private BestAntivirusService bestAntivirusService;

    public BestAntivirusController(BestAntivirusService bestAntivirusService) {
        this.bestAntivirusService = bestAntivirusService;
    }

    @PostMapping("/analizzaFile")
    public String analizzaFile(@ModelAttribute File fileContent) {
        return bestAntivirusService.analizzaFile(fileContent.getValue());
    }

    static class File {
        private String value;

        public String getValue() {
            return value;
        }

        public void setValue(String value) {
            this.value = value;
        }
    }
}
