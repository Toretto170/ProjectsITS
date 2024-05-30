package com.bestAntivirus.bestAntivirus.viruses;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;

import java.util.List;

@Configuration
@ConfigurationProperties(prefix = "virus")
@PropertySource(value = "classpath:virus-list.yml", factory = YamlPropertySourceFactory.class)
public class VirusListConfig {

    List<String> list;

    @Bean("virusList")
    public List<String> virusList() {
        return list;
    }

    public List<String> getList() {
        return list;
    }

    public void setList(List<String> list) {
        this.list = list;
    }
}
