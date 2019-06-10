package com.jiewen.spp.dao;

import java.util.List;

import com.jiewen.base.core.Mapper;
import com.jiewen.spp.model.AppSearchLog;

public interface AppSearchLogMapper extends Mapper<AppSearchLog> {

	public List<AppSearchLog> getTopSearchList(AppSearchLog appSearchLog);
}
