package com.yb.wechat.dao;

import java.util.List;

import com.yb.wechat.pojo.PublicServerMenu;

public interface PublicServerMenuDao {

	List<PublicServerMenu> getMenuListByServerId(String serverId);
    
}
