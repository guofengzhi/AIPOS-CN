package com.jiewen.modules.device.service;

import org.springframework.stereotype.Service;

import com.jiewen.jwp.base.service.CrudService;
import com.jiewen.modules.device.dao.ProductDao;
import com.jiewen.modules.device.entity.Product;

@Service
public class ProductService extends CrudService<ProductDao, Product> {

}
