package com.yb.wechat.service;

import java.util.List;

import com.yb.wechat.pojo.PublicServerMenu;

public interface PublicServerMenuService {

	public List<PublicServerMenu> getMenuList(String serverId);
	
}
