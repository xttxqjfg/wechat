package com.yb.wechat.pojo;

public class RCToken {

    private String userId;
    
    private String userToken;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? "" : userId.trim();
    }

	public String getUserToken() {
		return userToken == null ? "" : userToken.trim();
	}

	public void setUserToken(String userToken) {
		this.userToken = userToken == null ? "" : userToken.trim();
	}
}
