package com.jiewen.spp.modules.tms.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.google.common.collect.Lists;
import com.jiewen.base.core.exception.ServiceException;
import com.jiewen.base.core.service.CrudService;
import com.jiewen.jwp.common.utils.StringUtils;
import com.jiewen.spp.modules.tms.dao.TmsDeviceInfoDao;
import com.jiewen.spp.modules.tms.dao.TmsFileStategyDao;
import com.jiewen.spp.modules.tms.dao.UpdateStrategyDao;
import com.jiewen.spp.modules.tms.entity.TmsDeviceInfo;
import com.jiewen.spp.modules.tms.entity.TmsFileStategy;
import com.jiewen.spp.modules.tms.entity.UpdateStrategy;
import com.jiewen.spp.utils.LocaleMessageSourceUtil;

/**
 * 更新策略业务处理
 * 
 * @author guofengzhi
 */
@Service
public class UpdateStrategyService extends CrudService<UpdateStrategyDao, UpdateStrategy> {

	@Autowired
	private UpdateStrategyDao updateStrategyDao;

	@Autowired
	private TmsDeviceInfoDao tmsDeviceInfoDao;

	@Autowired
	private TmsFileStategyDao tmsFileStategyDao;

	@Resource
	private LocaleMessageSourceUtil messageSourceUtil;

	public static final String SPLIT_COMMA = ",";

	public static final String SPLIT_LINE = "-";

	@Transactional(readOnly = false)
	public void save(UpdateStrategy updateStrategy) {
		updateStrategy.setDeviceSnStr(updateStrategy.getDeviceSnStr().replace(" ", ""));
		List<String> list = analysisDeviceSnStr(updateStrategy.getDeviceSnStr());
		if (list.size() > 5000) {
			String message = messageSourceUtil.getMessage("tms.release.device.num.more");
			throw new ServiceException(message);
		}
		if (StringUtils.isBlank(updateStrategy.getId())) {
			updateStrategy.preInsert();
			updateStrategy.setCount(list.size());
			updateStrategyDao.insert(updateStrategy);
		} else {
			updateStrategy.preUpdate();
			updateStrategy.setCount(list.size());
			updateStrategyDao.update(updateStrategy);
		}
	}

	@Transactional(readOnly = false)
	public void saveTmsDevice(List<TmsDeviceInfo> tmsDeviceInfo) {
		tmsDeviceInfoDao.insertList(tmsDeviceInfo);
	}

	@Transactional
	public PageInfo<UpdateStrategy> findPage(UpdateStrategy updateStrategy) {
		if (updateStrategy != null && updateStrategy.getBeginDate() == null
				&& updateStrategy.getEndDate() == null) {
			updateStrategy.setBeginDate(new Date());
		}
		updateStrategy.setOrganId(updateStrategy.getCurrentUser().getOfficeId());
		PageHelper.startPage(updateStrategy);
		return new PageInfo<>(updateStrategyDao.findList(updateStrategy));
	}

	@Transactional(readOnly = false)
	public void deleteById(UpdateStrategy updateStrategy) {
		updateStrategyDao.delete(updateStrategy);
	}

	@Transactional(readOnly = false)
	public void saveFileStategy(String strategyId, String ids) {
		String[] idArray = ids.split(SPLIT_COMMA);
		List<TmsFileStategy> list = Lists.newArrayList();
		for (String id : idArray) {
			TmsFileStategy tmsFileStategy = new TmsFileStategy();
			tmsFileStategy.setFileId(id);
			tmsFileStategy.setStrategyId(strategyId);
			list.add(tmsFileStategy);
		}
		tmsFileStategyDao.insertList(list);

		// 存储设备SN
		saveTmsDeviceInfo(strategyId);
	}

	public Integer getFileById(UpdateStrategy updateStrategy) {
		if (updateStrategy != null) {
			return updateStrategyDao.getFileById(updateStrategy.getId());
		}
		return null;
	}

	/**
	 * 解析设备SN字符串
	 * 
	 * @param deviceSnStr
	 * @param strategyId
	 * @return
	 */
	public List<String> analysisDeviceSnStr(String deviceSnStr) {
		List<String> snList = new ArrayList<String>();
		String[] snStrArray = deviceSnStr.split(SPLIT_COMMA);
		if (snStrArray.length > 0) {
			for (int i = 0; i < snStrArray.length; i++) {
				String snStr = snStrArray[i];
				if (snStr.indexOf(SPLIT_LINE) > 0) {
					addSnIntervalToList(snStr, snList);
				} else {
					snList.add(snStr);
				}
			}
		}
		return snList;
	}

	/**
	 * 解析SN号段中存在的SN，并将这些SN加入到list内
	 * 
	 * @param snInterverStr
	 * @param snList
	 * @param strategyId
	 */
	public void addSnIntervalToList(String snStr, List<String> snList) {
		// SN号段示例:10021000000-10021000020
		String[] snInterval = snStr.split("-");
		// 假如存在的SN号段前面比后面大，例如20021000000-10021000020,将解析值重新排序，用于后续计算长度
		if (snInterval[0].compareTo(snInterval[1]) > 0) {
			String transitStr = snInterval[0];
			snInterval[0] = snInterval[1];
			snInterval[1] = transitStr;
		}

		// 这里计算两个SN之间是从字符串第几位开始不一样
		int differenceIndex = 0;
		for (int j = 0; j < snInterval[1].length(); j++) {
			if (snInterval[0].getBytes()[j] != snInterval[1].getBytes()[j]) {
				differenceIndex = j;
				break;
			}
		}

		// 获得SN号段前面相同的字符串
		String commonStr = snInterval[0].substring(0, differenceIndex);
		// 获取不同字符串的位数
		int differenceLen = snInterval[0].length() - commonStr.length();

		// 计算两个号段之间的差异值，因为SN长度为11位采用long类型
		long snIntervalLen = Long.parseLong(snInterval[1]) - Long.parseLong(snInterval[0]) + 1;
		// 如果差值大于5000视为较大数据，拒绝业务
		if (snIntervalLen > 5000) {
			String message = messageSourceUtil.getMessage("tms.release.device.num.more");
			throw new ServiceException(message);
		}

		for (int i = 0; i < snIntervalLen; i++) {
			int currentSn = Integer
					.parseInt(snInterval[0].substring(differenceIndex, snInterval[0].length())) + i;
			String sn = commonStr
					+ StringUtils.leftPad(String.valueOf(currentSn), differenceLen, '0');
			snList.add(sn);
		}

	}

	/**
	 * 存储设备SN
	 * 
	 * @param stategyId
	 */
	public void saveTmsDeviceInfo(String strategyId) {
		UpdateStrategy updateStrategy = updateStrategyDao.get(strategyId);
		if (updateStrategy == null) {
			String message = messageSourceUtil.getMessage("tms.strategy.not.find");
			throw new ServiceException(message);
		}
		List<TmsDeviceInfo> totalDeviceLists = new ArrayList<>();
		List<String> list = analysisDeviceSnStr(updateStrategy.getDeviceSnStr());
		for (String deviceSn : list) {
			TmsDeviceInfo entity = new TmsDeviceInfo();
			entity.setDeviceSn(deviceSn);
			TmsDeviceInfo tmsDeviceInfo = tmsDeviceInfoDao.get(entity);
			if (tmsDeviceInfo != null) {
				tmsDeviceInfo.setStrategyId(updateStrategy.getId());
				tmsDeviceInfoDao.update(tmsDeviceInfo);
			} else {
				tmsDeviceInfo = new TmsDeviceInfo();
				tmsDeviceInfo.setDeviceSn(deviceSn);
				tmsDeviceInfo.setManuNo(updateStrategy.getManufactureNo());
				tmsDeviceInfo.setStrategyId(updateStrategy.getId());
				tmsDeviceInfo.setCreateDate(new Date());
				tmsDeviceInfo.setDeviceType(updateStrategy.getDeviceType());
				totalDeviceLists.add(tmsDeviceInfo);
			}
		}

		List<TmsDeviceInfo> subDeviceList = Lists.newArrayList();
		for (int i = 0; i < totalDeviceLists.size(); i = i + 1000) {
			if (i + 1000 < totalDeviceLists.size()) {
				subDeviceList = totalDeviceLists.subList(i, i + 1000);
				saveTmsDevice(subDeviceList);
			} else {
				subDeviceList = totalDeviceLists.subList(i, totalDeviceLists.size());
				saveTmsDevice(subDeviceList);
				return;
			}
		}
	}

}
