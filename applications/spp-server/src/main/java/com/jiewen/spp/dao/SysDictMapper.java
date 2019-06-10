package com.jiewen.spp.dao;

import java.util.List;

import com.jiewen.base.core.Mapper;
import com.jiewen.spp.model.SysDict;

public interface SysDictMapper extends Mapper<SysDict> {

	public List<SysDict> getClassByType();
}
