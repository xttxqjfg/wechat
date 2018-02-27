package com.yb.wechat.dao;

import java.util.List;

import com.yb.wechat.pojo.*;

public interface UserDao {
	int deleteByPrimaryKey(String userid);

    int insert(User record);

    User selectByUserId(String userid);

    int updateByPrimaryKey(User record);
    
    List<User> selectAll();
}
