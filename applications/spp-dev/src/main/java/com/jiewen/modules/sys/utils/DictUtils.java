package com.jiewen.modules.sys.utils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.context.i18n.LocaleContextHolder;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.jiewen.jwp.base.utils.CacheUtils;
import com.jiewen.jwp.common.JsonMapper;
import com.jiewen.jwp.common.SpringUtil;
import com.jiewen.modules.sys.dao.DictDao;
import com.jiewen.modules.sys.entity.Dict;

/**
 * 字典工具类
 */
public class DictUtils {

    private DictUtils() {
        throw new IllegalStateException("Utility class");
    }

    private static DictDao dictDao = SpringUtil.getBean(DictDao.class);

    public static final String CACHE_DICT_MAP = "dictMap";

    public static String getDictLabel(String value, String type, String defaultValue) {
        if (StringUtils.isNotBlank(type) && StringUtils.isNotBlank(value)) {
            for (Dict dict : getDictList(type)) {
                if (type.equals(dict.getType()) && value.equals(dict.getValue())) {
                    return dict.getLabel();
                }
            }
        }
        return defaultValue;
    }

    public static String getDictLabels(String values, String type, String defaultValue) {
        if (StringUtils.isNotBlank(type) && StringUtils.isNotBlank(values)) {
            List<String> valueList = Lists.newArrayList();
            for (String value : StringUtils.split(values, ",")) {
                valueList.add(getDictLabel(value, type, defaultValue));
            }
            return StringUtils.join(valueList, ",");
        }
        return defaultValue;
    }

    public static String getDictValue(String label, String type, String defaultLabel) {
        if (StringUtils.isNotBlank(type) && StringUtils.isNotBlank(label)) {
            for (Dict dict : getDictList(type)) {
                if (type.equals(dict.getType()) && label.equals(dict.getLabel())) {
                    return dict.getValue();
                }
            }
        }
        return defaultLabel;
    }

    public static List<Dict> getDictList(String type) {
        @SuppressWarnings("unchecked")
        Map<String, List<Dict>> dictMap = (Map<String, List<Dict>>) CacheUtils.get(CACHE_DICT_MAP);
        String localLanguage = LocaleContextHolder.getLocale().toString().toLowerCase();
        if (dictMap == null) {
            dictMap = Maps.newHashMap();
            Dict dictObj = new Dict();
            for (Dict dict : dictDao.findAllList(dictObj)) {
                List<Dict> dictList = dictMap.get(dict.getType());
                if (dictList != null) {
                    dictList.add(dict);
                } else {
                    dictMap.put(dict.getType(), Lists.newArrayList(dict));
                }
            }
            CacheUtils.put(CACHE_DICT_MAP, dictMap);
        }
        List<Dict> dictList = dictMap.get(type);
        if (dictList == null) {
            dictList = Lists.newArrayList();
        }else {
        	 List<Dict>  dictListnew = new ArrayList<Dict>();
            for(Dict dict: dictList){
        	if(StringUtils.equals(localLanguage, dict.getLang())){
        		dictListnew.add(dict);
        	}
          }
            dictList = dictListnew;
        }
        return dictList;
    }

    /**
     * 返回字典列表（JSON）
     * 
     * @param type
     * @return
     */
    public static String getDictListJson(String type) {
        return JsonMapper.toJsonString(getDictList(type));
    }

}
