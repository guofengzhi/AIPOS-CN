package com.jiewen.base.sys.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.jiewen.base.common.security.shiro.SessionDAO;
import com.jiewen.base.common.utils.CacheUtils;
import com.jiewen.base.common.web.ServletsUtils;
import com.jiewen.base.config.Global;
import com.jiewen.base.core.entity.TreeNode;
import com.jiewen.base.core.exception.ServiceException;
import com.jiewen.base.core.service.BaseService;
import com.jiewen.base.sys.dao.DeviceMerchantDao;
import com.jiewen.base.sys.dao.MenuDao;
import com.jiewen.base.sys.dao.MerchantDao;
import com.jiewen.base.sys.dao.RoleDao;
import com.jiewen.base.sys.dao.StoreDao;
import com.jiewen.base.sys.dao.TagManagerDao;
import com.jiewen.base.sys.dao.UserDao;
import com.jiewen.base.sys.entity.DeviceMerchant;
import com.jiewen.base.sys.entity.Menu;
import com.jiewen.base.sys.entity.Merchant;
import com.jiewen.base.sys.entity.Office;
import com.jiewen.base.sys.entity.Role;
import com.jiewen.base.sys.entity.Store;
import com.jiewen.base.sys.entity.TagManager;
import com.jiewen.base.sys.entity.User;
import com.jiewen.base.sys.utils.LogUtils;
import com.jiewen.base.sys.utils.UserUtils;
import com.jiewen.jwp.common.security.Digests;
import com.jiewen.jwp.common.utils.Encodes;
import com.jiewen.jwp.common.utils.StringUtils;
import com.jiewen.jwp.common.utils.excel.ExcelReaderUtil;
import com.jiewen.spp.modules.device.dao.DeviceDao;
import com.jiewen.spp.modules.device.entity.Device;
import com.jiewen.spp.utils.LocaleMessageSourceUtil;

/**
 * 系统管理，安全相关实体的管理类,包括用户、角色、菜单.
 */
@Service
@Transactional
public class SystemService extends BaseService implements InitializingBean {

	public static final String HASH_ALGORITHM = "SHA-256";

	public static final int HASH_INTERATIONS = 1024;

	public static final int SALT_SIZE = 8;

	@Resource
	protected LocaleMessageSourceUtil messageSourceUtil;

	@Autowired
	private UserDao userDao;

	@Autowired
	private MerchantDao merchantDao;

	@Autowired
	private StoreDao storeDao;

	@Autowired
	private RoleDao roleDao;

	@Autowired
	private DeviceDao deviceDao;

	@Autowired
	private MenuDao menuDao;

	@Autowired
	private SessionDAO sessionDao;

	@Autowired
	private DeviceMerchantDao deviceMerchantDao;

	@Autowired
	private TagManagerDao tagManagerDao;
	// -- User Service --//

	/**
	 * 获取用户
	 * 
	 * @param id
	 * @return
	 */
	public User getUser(String id) {
		return UserUtils.get(id);
	}

	/**
	 * 根据登录名获取用户
	 * 
	 * @param loginName
	 * @return
	 */
	public User getUserByLoginName(String loginName) {
		return UserUtils.getByLoginName(loginName);
	}

	/**
	 * 无分页查询人员列表
	 * 
	 * @param user
	 * @return
	 */
	public List<User> findUser(User user) {
		// 生成数据权限过滤条件（dsf为dataScopeFilter的简写，在xml中使用 ${sqlMap.dsf}调用权限SQL）
		user.getSqlMap().put("dsf", dataScopeFilter(user.getCurrentUser(), "o", "a"));
		return userDao.findList(user);
	}

	/**
	 * 获取分页查询
	 * 
	 * @param user
	 * @return
	 */
	@Transactional
	public PageInfo<User> findPage(User user) {
		// 生成数据权限过滤条件（dsf为dataScopeFilter的简写，在xml中使用 ${sqlMap.dsf}调用权限SQL）
		user.getSqlMap().put("dsf", dataScopeFilter(user.getCurrentUser(), "o", "a"));
		PageHelper.startPage(user);
		return new PageInfo<>(userDao.findList(user));
	}

	/**
	 * 获取分页查询
	 * 
	 * @param merchant
	 * @return
	 */
	@Transactional
	public PageInfo<Merchant> findMerchantPage(Merchant merchant) {
		// 生成数据权限过滤条件（dsf为dataScopeFilter的简写，在xml中使用 ${sqlMap.dsf}调用权限SQL）
		PageHelper.startPage(merchant);
		List<Merchant> selectMerchantList = merchantDao.selectMerchantList(merchant);
		return new PageInfo<>(selectMerchantList);
	}

	/**
	 * 通过部门ID获取用户列表，仅返回用户id和name（树查询用户时用）
	 * 
	 * @param user
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<User> findUserByOfficeId(String officeId) {
		List<User> list = (List<User>) CacheUtils.get(UserUtils.USER_CACHE,
				UserUtils.USER_CACHE_LIST_BY_OFFICE_ID_ + officeId);
		if (list == null) {
			User user = new User();
			user.setOffice(new Office(officeId));
			list = userDao.findUserByOfficeId(user);
			CacheUtils.put(UserUtils.USER_CACHE, UserUtils.USER_CACHE_LIST_BY_OFFICE_ID_ + officeId, list);
		}
		return list;
	}

	@Transactional(readOnly = false)
	public void saveUser(User user) {
		if (StringUtils.isBlank(user.getId())) {
			user.setPassword(entryptPassword(Global.getConfig("create.user.initpd"))); // 新增用户初始化密码
			user.preInsert();
			userDao.insert(user);
		} else {
			// 清除原用户机构用户缓存
			User oldUser = userDao.get(user.getId());
			if (oldUser.getOffice() != null && oldUser.getOffice().getId() != null) {
				CacheUtils.remove(UserUtils.USER_CACHE,
						UserUtils.USER_CACHE_LIST_BY_OFFICE_ID_ + oldUser.getOffice().getId());
			}
			// 更新用户数据
			user.preUpdate();
			userDao.update(user);
		}
		if (StringUtils.isNotBlank(user.getId())) {
			// 更新用户与角色关联
			userDao.deleteUserRole(user);
			if (user.getRoleList() != null && !user.getRoleList().isEmpty()) {
				userDao.insertUserRole(user);
			} else {
				String message = messageSourceUtil.getMessage("sys.role.noset.roles");
				throw new ServiceException(user.getLoginName() + message);
			}
			// 清除用户缓存
			UserUtils.clearCache(user);
		}
	}

	@Transactional(readOnly = false)
	public void updateUserInfo(User user) {
		user.preUpdate();
		userDao.updateUserInfo(user);
		// 清除用户缓存
		UserUtils.clearCache(user);
	}

	@Transactional(readOnly = false)
	public void deleteUser(String id) {
		User user = new User(id);
		userDao.delete(user);
		// 清除用户缓存
		UserUtils.clearCache(user);
	}

	@Transactional(readOnly = false)
	public void updatePasswordById(String id, String loginName, String newPassword) {
		User user = new User(id);
		user.setPassword(entryptPassword(newPassword));
		userDao.updatePasswordById(user);
		// 清除用户缓存
		user.setLoginName(loginName);
		UserUtils.clearCache(user);
	}

	@Transactional(readOnly = false)
	public void updateUserLoginInfo(User user) {
		// 保存上次登录信息
		user.setOldLoginIp(user.getLoginIp());
		user.setOldLoginDate(user.getLoginDate());
		// 更新本次登录信息
		user.setLoginIp(StringUtils.getRemoteAddr(ServletsUtils.getRequest()));
		user.setLoginDate(new Date());
		userDao.updateLoginInfo(user);
	}

	/**
	 * 生成安全的密码，生成随机的16位salt并经过1024次 sha-256 hash
	 */
	public static String entryptPassword(String plainPassword) {
		String plain = Encodes.unescapeHtml(plainPassword);
		byte[] salt = Digests.generateSalt(SALT_SIZE);
		byte[] hashPassword = Digests.sha256(plain.getBytes(), salt, HASH_INTERATIONS);
		return Encodes.encodeHex(salt) + Encodes.encodeHex(hashPassword);
	}

	/**
	 * 验证密码
	 * 
	 * @param plainPassword
	 *            明文密码
	 * @param password
	 *            密文密码
	 * @return 验证成功返回true
	 */
	public static boolean validatePassword(String plainPassword, String password) {
		String plain = Encodes.unescapeHtml(plainPassword);
		byte[] salt = Encodes.decodeHex(password.substring(0, 16));
		byte[] hashPassword = Digests.sha256(plain.getBytes(), salt, HASH_INTERATIONS);
		return password.equals(Encodes.encodeHex(salt) + Encodes.encodeHex(hashPassword));
	}

	/**
	 * 获得活动会话
	 * 
	 * @return
	 */
	public SessionDAO getSessionDao() {
		return sessionDao;
	}

	// -- Role Service --//

	public Role getRole(String id) {
		return roleDao.get(id);
	}

	public Role getRoleByName(String name) {
		Role r = new Role();
		r.setName(name);
		return roleDao.getByName(r);
	}

	public Role getRoleByEnname(String enname) {
		Role r = new Role();
		r.setEnname(enname);
		return roleDao.getByEnname(r);
	}

	public List<Role> findRole(Role role) {
		return roleDao.findList(role);
	}

	public PageInfo<Role> findPage(Role role) {
		PageHelper.startPage(role);
		return new PageInfo<>(roleDao.findList(role));
	}

	public List<Role> findAllRole() {
		return UserUtils.getRoleList();
	}

	@Transactional(readOnly = false)
	public void saveRole(Role role) {
		if (role.getOffice() == null) {
			role.setOffice(new Office(role.getOfficeId()));
		}
		if (StringUtils.isBlank(role.getId())) {
			role.preInsert();
			roleDao.insert(role);
		} else {
			role.preUpdate();
			roleDao.update(role);
		}
		// 清除用户角色缓存
		UserUtils.removeCache(UserUtils.CACHE_ROLE_LIST);
	}

	@Transactional(readOnly = false)
	public void deleteRole(Role role) {
		roleDao.delete(role);
		// 清除用户角色缓存
		UserUtils.removeCache(UserUtils.CACHE_ROLE_LIST);
	}

	@Transactional(readOnly = false)
	public void assignMenuToRole(Role role) {
		roleDao.deleteRoleMenu(role);
		if (!role.getMenuList().isEmpty()) {
			roleDao.insertRoleMenu(role);
		}
	}

	// -- Menu Service --//

	public Menu getMenu(String id) {
		return menuDao.get(id);
	}

	public List<Menu> findAllMenu() {
		return UserUtils.getMenuList();
	}

	/**
	 * 获取菜单数据结构
	 * 
	 * @return
	 */
	public List<TreeNode> getTreeData() {
		// 获取数据
		List<Menu> funcs = findAllMenu();
		Map<String, TreeNode> nodelist = new LinkedHashMap<>();
		List<TreeNode> tnlist = new ArrayList<>();
		for (Menu func : funcs) {
			TreeNode node = new TreeNode();
			node.setText(func.getName());
			node.setId(func.getId());
			node.setParentId(func.getParentId());
			node.setLevelCode(func.getLevelCode());
			node.setIcon(func.getIcon());
			nodelist.put(node.getId(), node);
		}
		// 构造树形结构
		for (Map.Entry<String, TreeNode> entry : nodelist.entrySet()) {
			TreeNode node = entry.getValue();
			if (StringUtils.equals("0", node.getParentId())) {
				tnlist.add(node);
			} else {
				if (nodelist.get(node.getParentId()).getNodes() == null) {
					nodelist.get(node.getParentId()).setNodes(new ArrayList<TreeNode>());
				}
				nodelist.get(node.getParentId()).getNodes().add(node);
			}
		}
		return tnlist;
	}

	@Transactional(readOnly = false)
	public void saveMenu(Menu menu) {
		// 获取父节点实体
		menu.setParent(this.getMenu(menu.getParentId()));

		if (menu.getParent() == null || menu.getParent().getId() == null) {
			menu.setParent(new Menu(Menu.getRootId()));
		}

		// 获取修改前的parentIds，用于更新子节点的parentIds
		String oldParentIds = StringUtils.isEmpty(menu.getParentIds()) ? StringUtils.SPACE : menu.getParentIds();

		// 设置新的父节点串
		menu.setParentIds((StringUtils.isEmpty(menu.getParent().getParentIds()) ? StringUtils.SPACE
				: menu.getParent().getParentIds()) + menu.getParent().getId() + ",");

		menu.setName(menu.getName() + "|" + StringUtils.defaultString(menu.getEnName(), StringUtils.EMPTY) + "|"
				+ StringUtils.defaultString(menu.getTcName(), StringUtils.EMPTY));

		// 保存或更新实体
		if (StringUtils.isBlank(menu.getId())) {
			menu.preInsert();
			menuDao.insert(menu);
		} else {
			menu.preUpdate();
			menuDao.update(menu);
		}

		// 更新子节点 parentIds
		Menu m = new Menu();
		m.setParentIds("%," + menu.getId() + ",%");
		List<Menu> list = menuDao.findByParentIdsLike(m);
		for (Menu e : list) {
			e.setParentIds(e.getParentIds().replace(oldParentIds, menu.getParentIds()));
			menuDao.updateParentIds(e);
		}
		// 清除用户菜单缓存
		UserUtils.removeCache(UserUtils.CACHE_MENU_LIST);
		// 清除日志相关缓存
		CacheUtils.remove(LogUtils.CACHE_MENU_NAME_PATH_MAP);
	}

	@Transactional(readOnly = false)
	public void updateMenuSort(Menu menu) {
		menuDao.updateSort(menu);
		// 清除用户菜单缓存
		UserUtils.removeCache(UserUtils.CACHE_MENU_LIST);
		// 清除日志相关缓存
		CacheUtils.remove(LogUtils.CACHE_MENU_NAME_PATH_MAP);
	}

	@Transactional(readOnly = false)
	public void deleteMenu(Menu menu) {
		menuDao.delete(menu);
		// 清除用户菜单缓存
		UserUtils.removeCache(UserUtils.CACHE_MENU_LIST);
		// 清除日志相关缓存
		CacheUtils.remove(LogUtils.CACHE_MENU_NAME_PATH_MAP);
	}

	@Override
	public void afterPropertiesSet() throws Exception {
		// Do nothing because of X and Y.
	}

	public PageInfo<Merchant> findPage(Merchant merchant) {
		PageHelper.startPage(merchant);
		return new PageInfo<>();
	}

	public void addMerchant(Merchant merchant) {
		merchantDao.insert(merchant);
	}

	public void deleteMerchant(String id) {
		merchantDao.deleteMerchant(id);
	}

	public void updateMerchant(Merchant merchant) {
		merchantDao.updateMerchant(merchant);
	}

	public List<Merchant> getMerchants(Merchant merchant) {
		return merchantDao.selectMerchantList(merchant);
	}

	public void boundOneTerm(String merId, String deviceId, String storeId) {
		Device deviceParam = new Device();
		deviceParam.setId(deviceId);
		deviceParam.setShopId(storeId);
		deviceParam.setMerId(merId);
		deviceDao.updateBundStateById(deviceParam);
	}

	public List<Merchant> getAllMerchant(Merchant merchant) {
		return merchantDao.getAllMerchant(merchant);
	}

	public PageInfo<DeviceMerchant> findDeviceMerchantPage(DeviceMerchant deviceMerchant) {
		PageHelper.startPage(deviceMerchant);
		List<DeviceMerchant> selectMerchantList = deviceMerchantDao.selectDeviceMerchantList(deviceMerchant);
		return new PageInfo<>(selectMerchantList);
	}

	public void updateBoundState(Device device) {
		deviceDao.updateBoundState(device);
	}

	/**
	 * 获取所有未绑定的终端
	 * 
	 * @param device
	 * @return
	 */
	public List<Device> getUnBoundTerms(Device device) {
		return deviceMerchantDao.getUnBoundTerms(device);
	}

	@Transactional(readOnly = false)
	public void uploadBoundFile(MultipartFile file) throws Exception {
		List<String[]> boundAllList = ExcelReaderUtil.excelToArrayList(file.getOriginalFilename(),
				file.getInputStream(), 0, null);
		if (boundAllList != null && !boundAllList.isEmpty()) {
			String[] devices1 = boundAllList.get(1);
			String cell1 = devices1[0];
			String cell2 = devices1[1];
			if (!"商 户 号".equals(cell1) || !"终 端 SN".equals(cell2)) {
				String message = messageSourceUtil.getMessage("modules.merchant.bound.upload.file.error");
				throw new ServiceException(message);
			}

			List<DeviceMerchant> deviceMerchantList = new ArrayList<>();
			for (int i = 2; i < boundAllList.size(); i++) {

				String[] devices = boundAllList.get(i);
				String merId = devices[0];
				String sn = devices[1];
				DeviceMerchant deviceMerchant = new DeviceMerchant();
				deviceMerchant.setMerId(merId);
				deviceMerchant.setDeviceSn(sn);

				deviceMerchantList.add(deviceMerchant);
			}
			if (deviceMerchantList.size() > 0) {
				deviceMerchantDao.insertList(deviceMerchantList);
			}
		}
	}

	@Transactional(readOnly = false)
	public void uploadMerchantFile(MultipartFile file) throws Exception {
		List<String[]> boundAllList = ExcelReaderUtil.excelToArrayList(file.getOriginalFilename(),
				file.getInputStream(), 0, null);
		if (boundAllList != null && !boundAllList.isEmpty()) {
			String[] devices1 = boundAllList.get(1);
			String cell1 = devices1[0];
			String cell2 = devices1[1];
			if (!"商 户 号".equals(cell1) || !"商 户 名 称".equals(cell2)) {
				String message = messageSourceUtil.getMessage("modules.merchant.bound.upload.file.error");
				throw new ServiceException(message);
			}
			List<Merchant> existMers = merchantDao.getAllMerchant(new Merchant());
			List<String> merIdList = new ArrayList<String>();
			for (Merchant merchant : existMers) {
				merIdList.add(merchant.getMerId());
			}
			List<Merchant> merchants = new ArrayList<>();
			for (int i = 2; i < boundAllList.size(); i++) {

				String[] fields = boundAllList.get(i);
				String merId = fields[0];
				if (StringUtils.isEmpty(merId)) {
					String message = messageSourceUtil.getMessage("modules.device.upload.file.error");
					throw new ServiceException(message);
				}
				if (merIdList.contains(merId)) {
					/*
					 * String message = messageSourceUtil.getMessage(
					 * "modules.device.upload.file.error"); throw new
					 * ServiceException(message);
					 */
					continue;
				}
				String merName = fields[1];
				if (StringUtils.isEmpty(merName)) {
					String message = messageSourceUtil.getMessage("modules.device.upload.file.error");
					throw new ServiceException(message);
				}
				String orgId = fields[2];
				if (merIdList.contains(orgId)) {
					String message = messageSourceUtil.getMessage("modules.device.upload.file.error");
					throw new ServiceException(message);
				}
				String linkMan = fields[3];
				if (StringUtils.isEmpty(linkMan)) {
					String message = messageSourceUtil.getMessage("modules.device.upload.file.error");
					throw new ServiceException(message);
				}
				String linkPhone = fields[4];
				if (StringUtils.isEmpty(linkPhone)) {
					String message = messageSourceUtil.getMessage("modules.device.upload.file.error");
					throw new ServiceException(message);
				}
				String address = fields[5];
				if (StringUtils.isEmpty(address)) {
					String message = messageSourceUtil.getMessage("modules.device.upload.file.error");
					throw new ServiceException(message);
				}
				Merchant merchant = new Merchant();
				merchant.setMerId(merId);
				merchant.setMerName(merName);
				merchant.setOrgId(orgId);
				merchant.setLinkMan(linkMan);
				merchant.setLinkPhone(linkPhone);
				merchant.setAddress(address);
				merchants.add(merchant);
			}
			if (merchants.size() > 0) {
				merchantDao.insertList(merchants);
			}
		}
	}

	public void uploadUnBoundFile(MultipartFile file) throws Exception {
		List<String[]> unBoundAllList = ExcelReaderUtil.excelToArrayList(file.getOriginalFilename(),
				file.getInputStream(), 0, null);
		if (unBoundAllList != null && !unBoundAllList.isEmpty()) {
			String[] devices1 = unBoundAllList.get(1);
			String cell1 = devices1[0];
			String cell2 = devices1[1];
			if (!"商 户 号".equals(cell1) || !"终 端 SN".equals(cell2)) {
				String message = messageSourceUtil.getMessage("modules.merchant.bound.upload.file.error");
				throw new ServiceException(message);
			}

			List<DeviceMerchant> deviceMerchantList = new ArrayList<>();
			for (int i = 2; i < unBoundAllList.size(); i++) {

				String[] devices = unBoundAllList.get(i);
				String merId = devices[0];
				String sn = devices[1];
				DeviceMerchant deviceMerchant = new DeviceMerchant();
				deviceMerchant.setMerId(merId);
				deviceMerchant.setDeviceSn(sn);

				deviceMerchantList.add(deviceMerchant);
			}
			if (deviceMerchantList.size() > 0) {
				deviceMerchantDao.batchUnBound(deviceMerchantList);
			}
		}
	}

	public Merchant getMerchantByMerId(String merId) {
		return merchantDao.getMerchantByMerId(merId);
	}

	public PageInfo<Store> findStorePage(Store store) {
		// 生成数据权限过滤条件（dsf为dataScopeFilter的简写，在xml中使用 ${sqlMap.dsf}调用权限SQL）
		PageHelper.startPage(store);
		List<Store> selectStoreList = storeDao.selectStoreList(store);
		return new PageInfo<>(selectStoreList);
	}

	public void addStore(Store store) {
		storeDao.insert(store);
	}

	public List<Store> findStoreList(Store store) {
		return storeDao.selectStoreList(store);
	}

	public void deleteStore(String id) {
		storeDao.deleteStore(id);
	}

	public void updateStore(Store store) {
		storeDao.updateStore(store);
	}

	public Store getStoreByStoreId(String storeId) {
		return storeDao.getStoreByStoreId(storeId);
	}

	public Merchant getMerchantById(String id) {
		return merchantDao.getMerchantById(id);
	}

	public Store getStoreById(String id) {
		return storeDao.get(id);
	}

	public List<Device> getUnBoundStoreTerms(Device device) {
		return deviceMerchantDao.getUnBoundStoreTerms(device);
	}

	public List<Store> getAllStore(Store store) {
		return storeDao.getAllStore(store);
	}

	/**
	 * 获取分页查询
	 * 
	 * @param tagManager
	 * @return
	 */
	@Transactional
	public PageInfo<TagManager> findTagManagerPage(TagManager tagManager) {
		PageHelper.startPage(tagManager);
		List<TagManager> selectTagManagerList = tagManagerDao.selectTagManagerList(tagManager);
		return new PageInfo<>(selectTagManagerList);
	}

	public TagManager getTagManagerByTagId(String id) {
		return tagManagerDao.getTagManagerByTagId(id);
	}

	public void addTagManager(TagManager tagManager) {
		tagManagerDao.insertTagManager(tagManager);
	}

	public void updateTagManager(TagManager tagManager) {
		tagManagerDao.updateTagManager(tagManager);
	}

	public TagManager getTagManagerByTag(TagManager tagManager) {
		return tagManagerDao.getTagManagerByTag(tagManager);
	}

	public void deleteTagManager(String id) {
		tagManagerDao.deleteTagManager(id);
	}

	public List<TagManager> getTagManagerBundTermByTagId(String tagId) {
		return tagManagerDao.getTagManagerBundTermByTagId(tagId);
	}

	public PageInfo<Device> findTagManagerDevicePage(Device device) {
		PageHelper.startPage(device);
		List<Device> tagManagerDevicesList = tagManagerDao.getTagManagerDevices(device);
		return new PageInfo<>(tagManagerDevicesList);
	}

	public void batchBundTagManagerDevice(List<Device> deviceList) {
		tagManagerDao.batchBundTagManagerDevice(deviceList);
	}

	public void batchUnBundTagManagerDevice(List<Device> deviceList) {
		tagManagerDao.batchUnBundTagManagerDevice(deviceList);
	}

	public PageInfo<DeviceMerchant> findDeviceStorePage(DeviceMerchant deviceMerchant) {
		PageHelper.startPage(deviceMerchant);
		List<DeviceMerchant> selectMerchantList = deviceMerchantDao.selectDeviceStoreList(deviceMerchant);
		return new PageInfo<>(selectMerchantList);
	}

	public DeviceMerchant getBoundTermBySn(String sn) {
		return deviceMerchantDao.getBoundTermBySn(sn);
	}

	public void updateDeviceMerchant(DeviceMerchant dm) {
		deviceMerchantDao.updateDeviceMerchant(dm);
	}

	public PageInfo<DeviceMerchant> findDeviceUnBoundPage(DeviceMerchant deviceMerchant) {
		PageHelper.startPage(deviceMerchant);
		List<DeviceMerchant> selectMerchantList = deviceMerchantDao.findDeviceUnBoundPage(deviceMerchant);
		return new PageInfo<>(selectMerchantList);
	}

	public PageInfo<DeviceMerchant> boundAndUnBound(DeviceMerchant deviceMerchant) {
		PageHelper.startPage(deviceMerchant);
		List<DeviceMerchant> selectDeviceMerchantList = deviceMerchantDao.boundAndUnBound(deviceMerchant);
		return new PageInfo<>(selectDeviceMerchantList);
	}

	public void updateBatchBoundState(List ids) {
		deviceDao.updateBatchBoundState(ids);
	}

	public void batchBundDevice(List<Device> deviceList) {
		deviceDao.batchBundDevice(deviceList);
	}
}
