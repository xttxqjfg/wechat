package com.yb.wechat.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.yb.wechat.dao.PublicServerMenuDao;
import com.yb.wechat.pojo.PublicServerMenu;
import com.yb.wechat.service.PublicServerMenuService;

@Service
public class PublicServerMenuServiceImpl implements PublicServerMenuService {

	@Resource
	private PublicServerMenuDao menuDao;
	
	private static Logger logger = Logger.getLogger(PublicServerMenuServiceImpl.class);

	@Override
	//根据公众号id获取公众号菜单
	public List<PublicServerMenu> getMenuList(String serverId) {
		// TODO Auto-generated method stub
		try {
			return this.menuDao.getMenuListByServerId(serverId);
		} catch (Exception e) {
			// TODO: handle exception
			logger.info("#########################"); 
	        logger.info(e); 
	        logger.info("#########################"); 
			return null;
		}
	}
}
