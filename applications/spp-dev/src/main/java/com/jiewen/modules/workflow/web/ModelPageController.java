
package com.jiewen.modules.workflow.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class ModelPageController {

    // modeler.html内嵌的编辑界面
    @RequestMapping(value = "/editor-app/{pagename}", method = RequestMethod.GET)
    public String editor(@PathVariable("pagename") String pagename) {

        return "modules/workflow/editor-app/" + pagename;
    }

    @RequestMapping(value = "/editor-app/partials/{pagename}", method = RequestMethod.GET)
    public String partials(@PathVariable("pagename") String pagename) {

        return "modules/workflow/editor-app/partials/" + pagename;
    }

    @RequestMapping(value = "/editor-app/popups/{pagename}", method = RequestMethod.GET)
    public String popups(@PathVariable("pagename") String pagename) {

        return "modules/workflow/editor-app/popups/" + pagename;
    }
}
