
package com.jiewen.spp.modules.device.service;

import org.springframework.stereotype.Service;

import com.jiewen.base.core.service.CrudService;
import com.jiewen.spp.modules.device.dao.ProductDao;
import com.jiewen.spp.modules.device.entity.Product;

@Service
public class ProductService extends CrudService<ProductDao, Product> {

}
