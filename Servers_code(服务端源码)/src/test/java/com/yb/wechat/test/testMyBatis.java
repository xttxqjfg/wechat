package com.yb.wechat.test;

import javax.annotation.Resource;    

import org.apache.log4j.Logger;
import org.junit.Test;    
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;    
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;    
    
import com.alibaba.fastjson.JSON;    
import com.yb.wechat.pojo.*;    
import com.yb.wechat.service.*;

@RunWith(SpringJUnit4ClassRunner.class)     //表示继承了SpringJUnit4ClassRunner类    
@ContextConfiguration(locations = {"classpath:spring-mybatis.xml"})

public class testMyBatis {
	private static Logger logger = Logger.getLogger(testMyBatis.class);      
	
	@Resource    
    private UserService userService = null;    

    @Test    
    public void test1() {    
        User user = userService.getUserById("yibo");  
        logger.info("#########################"); 
        logger.info(user); 
        logger.info(JSON.toJSONString(user));    
    } 
}
