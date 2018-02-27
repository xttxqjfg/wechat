package com.yb.wechat.pojo;

public class User {
    private Integer id;

    private String userId;

    private String userName;

    private String userPortrait;

    private String userSex;

    private String userLocation;

    private String userSignature;
    
    private String userToken;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? "" : userId.trim();
    }

    public String getUserName() {
        return userName == null ? "" : userName.trim();
    }

    public void setUserName(String userName) {
        this.userName = userName == null ? "" : userName.trim();
    }

    public String getUserPortrait() {
        return userPortrait == null ? "" : userPortrait.trim();
    }

    public void setUserPortrait(String userPortrait) {
        this.userPortrait = userPortrait == null ? "" : userPortrait.trim();
    }

    public String getUserSex() {
        return userSex == null ? "" : userSex.trim();
    }

    public void setUserSex(String userSex) {
        this.userSex = userSex == null ? "" : userSex.trim();
    }

    public String getUserLocation() {
        return userLocation == null ? "" : userLocation.trim();
    }

    public void setUserLocation(String userLocation) {
        this.userLocation = userLocation == null ? "" : userLocation.trim();
    }

    public String getUserSignature() {
        return userSignature == null ? "" : userSignature.trim();
    }

    public void setUserSignature(String userSignature) {
        this.userSignature = userSignature == null ? "" : userSignature.trim();
    }

	public String getUserToken() {
		return userToken == null ? "" : userToken.trim();
	}

	public void setUserToken(String userToken) {
		this.userToken = userToken == null ? "" : userToken.trim();
	}
}
