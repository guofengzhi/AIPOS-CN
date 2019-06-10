
package com.jiewen;

import org.apache.log4j.Logger;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.Banner;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.boot.web.support.SpringBootServletInitializer;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.annotation.EnableAsync;

import com.jiewen.base.config.StartupBanner;

@EnableAsync
@SpringBootApplication
@ServletComponentScan
@MapperScan(basePackages = { "com.jiewen.base.sys", "com.jiewen.spp.modules" })
public class Application extends SpringBootServletInitializer implements CommandLineRunner {

	protected static Logger logger = Logger.getLogger(Application.class);
	
    public static void main(String[] args) {

        SpringApplication application = new SpringApplication(Application.class);
        application.setBanner(new StartupBanner());
        ApplicationContext context = application.run(args);
        String[] activeProfiles = context.getEnvironment().getActiveProfiles();
        for (String profile : activeProfiles) {
        	logger.info(String.format("应用启动使用 profile为:%s", profile));
        }

    }

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        application.bannerMode(Banner.Mode.LOG).banner(new StartupBanner());
        application.sources(Application.class);
        return application;

    }

    @Override
    public void run(String... args) {
    	logger.info("SPP-ADMIN 应用已经启动");
    }

}
