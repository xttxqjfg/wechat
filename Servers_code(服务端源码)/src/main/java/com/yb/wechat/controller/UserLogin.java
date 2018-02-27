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

import com.yb.wechat.service.impl.*;
import com.yb.wechat.pojo.*;
   
@WebServlet("/userLogin")
public class UserLogin extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	private static UserServiceImpl userServiceImpl;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public UserLogin() {
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
		
		//读取json字符流
		BufferedReader bufReader = new BufferedReader(new InputStreamReader((ServletInputStream)request.getInputStream()));
		StringBuffer buffer = new StringBuffer();  
		String line = "";  
		while ((line = bufReader.readLine()) != null){  
		     buffer.append(line);  
		}
		
		//转换为json对象
		JSONObject paramsMap = JSON.parseObject(buffer.toString());
		if(paramsMap != null)
		{
			if(!paramsMap.containsKey("userid"))
			{
				resultObj.put("code", "200");
				resultObj.put("msg", "参数解析错误!");
				out.write(JSON.toJSONString(resultObj));
				return;
			}
			WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(this.getServletContext()); 
			userServiceImpl = (UserServiceImpl)context.getBean("userServiceImpl");
			
			User user = userServiceImpl.getUserById(paramsMap.get("userid").toString());
			
			if(user != null)
			{
				resultObj.put("code", "200");
				resultObj.put("result", user);
				out.write(JSON.toJSONString(resultObj));
			}
			else
			{
				resultObj.put("code", "200");
				resultObj.put("msg", "用户不存在!");
				out.write(JSON.toJSONString(resultObj));
			}
		}
		else
		{
			resultObj.put("code", "200");
			resultObj.put("msg", "参数解析错误!");
			out.write(JSON.toJSONString(resultObj));
		}
	}
}
