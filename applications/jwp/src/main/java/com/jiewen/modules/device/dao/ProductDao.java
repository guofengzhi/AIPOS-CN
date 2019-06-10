package com.jiewen.modules.device.dao;

import java.util.List;

import com.jiewen.jwp.base.dao.CrudDao;
import com.jiewen.modules.device.entity.Product;

/**
 * 设备Dao
 * 
 * @author Administrator
 *
 */
public interface ProductDao extends CrudDao<Product> {

    public List<Product> findProductListByIds(List<String> idList);

    public List<Product> findNoImportDeviceList(Product product);
}
