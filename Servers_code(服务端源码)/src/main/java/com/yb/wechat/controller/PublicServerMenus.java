package com.yb.wechat.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
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
import com.yb.wechat.pojo.PublicServerMenu;
import com.yb.wechat.service.impl.PublicServerMenuServiceImpl;

@WebServlet("/pubSerMenu")
public class PublicServerMenus extends HttpServlet {

	private static final long serialVersionUID = 1L;
	
	private static PublicServerMenuServiceImpl menuServiceImpl;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public PublicServerMenus() {
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
		JSONObject paramsMap = JSON.parseObject(buffer.toString());
		if(paramsMap != null)
		{
			if(!(paramsMap.containsKey("userid") && paramsMap.containsKey("serverid")))
			{
				resultObj.put("code", "200");
				resultObj.put("msg", "参数解析异常!");
				out.write(JSON.toJSONString(resultObj));
				return;
			}
			WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(this.getServletContext()); 
			menuServiceImpl = (PublicServerMenuServiceImpl)context.getBean("publicServerMenuServiceImpl");
			
			List<PublicServerMenu> menus = menuServiceImpl.getMenuList(paramsMap.get("serverid").toString());
			
			if(menus != null)
			{
				resultObj.put("code", "200");
				resultObj.put("result", menus);
				out.write(JSON.toJSONString(resultObj));
			}
			else
			{
				resultObj.put("code", "200");
				resultObj.put("msg", "参数解析异常!");
				out.write(JSON.toJSONString(resultObj));
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
