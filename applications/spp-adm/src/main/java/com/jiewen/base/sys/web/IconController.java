
package com.jiewen.base.sys.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("${adminPath}/icon")
public class IconController {

    @RequestMapping("/nodecorator/select")
    private String index(String iconName, HttpServletRequest request) {

        request.setAttribute("iconName", iconName);
        return "base/icon/icon_selector";
    }
}
