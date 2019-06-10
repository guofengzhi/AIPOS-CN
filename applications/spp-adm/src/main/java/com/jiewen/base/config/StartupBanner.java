
package com.jiewen.base.config;

import java.io.PrintStream;

import org.springframework.boot.Banner;
import org.springframework.core.env.Environment;

public class StartupBanner implements Banner {

    @Override
    public void printBanner(Environment environment, Class<?> sourceClass, PrintStream out) {
        StringBuilder sb = new StringBuilder();
        sb.append("\r\n======================================================================\r\n");
        sb.append("\r\n    欢迎使用 " + environment.getProperty("productName") + "  - Powered By "
                + environment.getProperty("netaddress") + " \r\n");
        sb.append("\r\n======================================================================\r\n");
        out.println(sb.toString());
    }

}
