package com.yb.wechat.service;

import java.util.List;

import com.yb.wechat.pojo.*;

public interface UserService {
	public User getUserById(String userId);
	
	public Boolean addUser(User user);
	
	public RCToken getUserTokenById(String userId);
	
	public Boolean addUserToken(RCToken token);
	
	public List<User> getUserList();
}
