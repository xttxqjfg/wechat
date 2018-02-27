package com.yb.wechat.dao;

import com.yb.wechat.pojo.*;

public interface RCTokenDao {

	int deleteByPrimaryKey(String userid);

    int insert(RCToken record);

    RCToken selectByUserId(String userid);
    
}
