package com.jiewen.jwp.base.config;

import org.springframework.boot.Banner;
import org.springframework.core.env.Environment;

import java.io.PrintStream;

public class StartupBanner implements Banner {
    @Override
    public void printBanner(Environment environment, Class<?> aClass, PrintStream printStream) {
        StringBuilder sb = new StringBuilder();
        sb.append("======================================================================");
        sb.append("\n    欢迎使用 " + environment.getProperty("productName"));
        sb.append("\n======================================================================\n");

        printStream.println(sb.toString());
    }
}
