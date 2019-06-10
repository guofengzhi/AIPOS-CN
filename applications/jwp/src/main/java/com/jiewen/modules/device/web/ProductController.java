package com.jiewen.modules.device.web;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.modules.device.entity.Product;
import com.jiewen.modules.device.service.ProductService;

@Controller
@RequestMapping("${adminPath}/product")
public class ProductController extends BaseController {

    @Autowired
    private ProductService productService;

    /**
     * 设备列表
     * 
     * @param deviceType
     * @param reqObj
     * @return
     * @throws Exception
     */
    @RequestMapping(value = { "devBatchList", "" })
    @ResponseBody
    public Map<String, Object> devBatchList(String reqObj) throws Exception {

        Product product = new ParamResult<Product>(reqObj).getEntity(Product.class);
        PageInfo<Product> pageInfo = productService.findPage(product);
        return resultMap(product, pageInfo);
    }

}
