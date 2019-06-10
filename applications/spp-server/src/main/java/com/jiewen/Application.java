package com.jiewen;

import org.mybatis.spring.annotation.MapperScan;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.support.SpringBootServletInitializer;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.web.bind.annotation.RestController;

@EnableAsync
@RestController
@SpringBootApplication
@MapperScan(basePackages = "com.jiewen.spp.dao")
public class Application extends SpringBootServletInitializer implements CommandLineRunner {
    
    private static final Logger logger = LoggerFactory.getLogger(Application.class);
    
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(Application.class);
    }

    public static void main(String[] args) {
        
        ApplicationContext context = SpringApplication.run(Application.class, args);
        String[] activeProfiles = context.getEnvironment().getActiveProfiles();
        for(String profile : activeProfiles){
            logger.info("应用启动使用 profile为:{}", profile);
        }
    }

    @Override
    public void run(String... args) throws Exception {
        logger.info("SPP SERVER 应用已启动完成");
    }
}
