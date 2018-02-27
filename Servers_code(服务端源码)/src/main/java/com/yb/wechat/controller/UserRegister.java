package com.yb.wechat.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.ServletInputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.yb.wechat.pojo.*;
import com.yb.wechat.service.impl.*;

import io.rong.RongCloud;
import io.rong.models.TokenResult;

@WebServlet("/userRegister")
public class UserRegister extends HttpServlet {
private static final long serialVersionUID = 1L;
    
	private static UserServiceImpl userServiceImpl;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public UserRegister() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		PrintWriter out = response.getWriter();
		out.write("please request with POST!");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		response.setContentType("text/html");
		response.setCharacterEncoding("utf-8");
		PrintWriter out = response.getWriter();
		Map<String,Object> resultObj = new HashMap<String, Object>();
		
		//读取json串
		BufferedReader bufReader = new BufferedReader(new InputStreamReader((ServletInputStream)request.getInputStream()));
		StringBuffer buffer = new StringBuffer();  
		String line = "";  
		while ((line = bufReader.readLine()) != null){  
		     buffer.append(line);  
		}
		
		//解析json串
		JSONObject paramsMap = JSON.parseObject(java.net.URLDecoder.decode(buffer.toString(), "UTF-8"));
		if(paramsMap != null)
		{
			//参数判断
			if(!(paramsMap.containsKey("userid") && paramsMap.containsKey("username") && paramsMap.containsKey("password")))
			{
				resultObj.put("code", "200");
				resultObj.put("msg", "参数解析异常!");
				out.write(JSON.toJSONString(resultObj));
				return;
			}
			
			WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(this.getServletContext()); 
			userServiceImpl = (UserServiceImpl)context.getBean("userServiceImpl");
			
			User registerUser = new User();
			registerUser.setUserId(paramsMap.get("userid").toString());
			registerUser.setUserName(paramsMap.get("username").toString());
			registerUser.setUserLocation("中国,北京");
			registerUser.setUserSex("男");
			registerUser.setUserSignature("上善若水,厚德载物");
			
			User userCheck = userServiceImpl.getUserById(registerUser.getUserId());
			
			if(userCheck == null)
			{
				try {
					//注册用户不存在则先增加用户，然后刷新token
					Boolean insertMark = userServiceImpl.addUser(registerUser);
					
					if(insertMark)
					{
						//获取token
						RongCloud rongCloud = RongCloud.getInstance();

						try {
							
							TokenResult userGetTokenResult = rongCloud.user.getToken(registerUser.getUserId(), registerUser.getUserName(), "");
							
							RCToken token = userServiceImpl.getUserTokenById(registerUser.getUserId());
							if(token == null)
							{
								token = new  RCToken();
							}
							token.setUserId(registerUser.getUserId());
							token.setUserToken(userGetTokenResult.getToken().toString());
							registerUser.setUserToken(userGetTokenResult.getToken().toString());
							
							//插入token值
							userServiceImpl.addUserToken(token);
							
							resultObj.put("code", "200");
							resultObj.put("result", registerUser);
							out.write(JSON.toJSONString(resultObj));
							
						} catch (Exception e) {
							// TODO Auto-generated catch block
							resultObj.put("code", "200");
							resultObj.put("msg", "获取token失败,请稍后再试!");
							out.write(JSON.toJSONString(resultObj));
						}
					}
					else
					{
						resultObj.put("code", "200");
						resultObj.put("msg", "注册失败,请稍后再试");
						out.write(JSON.toJSONString(resultObj));
					}
				} catch (Exception e) {
					// TODO: handle exception
				}
				
			}
			else
			{
				//注册用户已存在,重新刷新用户token
				RongCloud rongCloud = RongCloud.getInstance();

				try {
					
					TokenResult userGetTokenResult = rongCloud.user.getToken(registerUser.getUserId(), registerUser.getUserName(), "");
					
					RCToken token = userServiceImpl.getUserTokenById(registerUser.getUserId());
					if(token == null)
					{
						token = new  RCToken();
					}
					token.setUserId(registerUser.getUserId());
					token.setUserToken(userGetTokenResult.getToken().toString());
					registerUser.setUserToken(userGetTokenResult.getToken().toString());
					
					//刷新token
					userServiceImpl.addUserToken(token);
					
					resultObj.put("code", "200");
					resultObj.put("msg", "注册用户已存在!");
					out.write(JSON.toJSONString(resultObj));
					
				} catch (Exception e) {
					// TODO Auto-generated catch block
					resultObj.put("code", "200");
					resultObj.put("msg", "获取token失败,请稍后再试!");
					out.write(JSON.toJSONString(resultObj));
				}
			}
		}
		else
		{
			resultObj.put("code", "200");
			resultObj.put("msg", "参数解析异常!");
			out.write(JSON.toJSONString(resultObj));
		}
	}
}