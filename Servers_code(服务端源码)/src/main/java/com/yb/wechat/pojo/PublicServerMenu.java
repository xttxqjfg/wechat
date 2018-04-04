package com.yb.wechat.pojo;

public class PublicServerMenu {

	private String menuId;
    
    private String menuName;

	public String getMenuId() {
		return menuId;
	}

	public void setMenuId(String menuId) {
		this.menuId = menuId == null ? "" : menuId.trim();
	}

	public String getMenuName() {
		return menuName == null ? "" : menuName.trim();
	}

	public void setMenuName(String menuName) {
		this.menuName = menuName == null ? "" : menuName.trim();
	}
    
}
