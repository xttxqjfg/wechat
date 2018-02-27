package com.yb.wechat.service.impl;

import com.alibaba.fastjson.JSON;
import com.yb.wechat.dao.*;
import com.yb.wechat.pojo.*;
import com.yb.wechat.service.*;

import java.util.List;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;    

@Service
public class UserServiceImpl implements UserService{
	
	@Resource
	private UserDao userDao;
	
	@Resource
	private RCTokenDao tokenDao;
	
	private static Logger logger = Logger.getLogger(UserServiceImpl.class);   
	
	@Override
	//根据id获取用户信息
	public User getUserById(String userId)
	{
		try {
			return this.userDao.selectByUserId(userId);
		} catch (Exception e) {
			// TODO: handle exception
			logger.info("#########################"); 
	        logger.info(e); 
	        logger.info("#########################"); 
			return null;
		}
	}
	
	@Override
	//用户注册
	public Boolean addUser(User user)
	{
		try {
			return this.userDao.insert(user) > 0 ? true : false;
		} catch (Exception e) {
			// TODO: handle exception
			logger.info("#########################"); 
	        logger.info(e); 
	        logger.info("#########################");
			return false;
		}
	}
	
	@Override
	//获取用户好友列表
	public List<User> getUserList()
	{
		try {
			return this.userDao.selectAll();
		} catch (Exception e) {
			// TODO: handle exception
			logger.info("#########################"); 
	        logger.info(e); 
	        logger.info("#########################");
			return null;
		}
	}
	
	@Override
	//获取token
	public RCToken getUserTokenById(String userId)
	{
		try {
			return this.tokenDao.selectByUserId(userId);
		} catch (Exception e) {
			// TODO: handle exception
			logger.info("#########################"); 
	        logger.info(e); 
	        logger.info("#########################");
			return null;
		}
	}
	
	@Override
	//token注册
	public Boolean addUserToken(RCToken token)
	{
		try {
			return this.tokenDao.insert(token) > 0 ? true : false;
		} catch (Exception e) {
			// TODO: handle exception
			logger.info("#########################"); 
	        logger.info(e); 
	        logger.info("#########################");
			return false;
		}
	}
}
