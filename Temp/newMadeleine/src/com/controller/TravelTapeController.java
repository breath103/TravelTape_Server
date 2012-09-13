package com.controller;

import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.Facebook.FacebookInfoBiz;
import com.Madeleine.Biz.MadeleineBiz;
import com.Madeleine.Biz.UserBiz;
import com.Madeleine.Entity.User;
import com.Madeleine.Entity.User.USER_TYPE;
import com.Madeleine.service.UserService;

@Controller
@Transactional
public class TravelTapeController {
	private SessionFactory sessionFactory;
	
	
	@Autowired  
	public TravelTapeController(SessionFactory sessionFactory) {
		super();
		this.sessionFactory = sessionFactory;
	}
	
	@RequestMapping(value = "/main.tt",method = RequestMethod.GET)
	public ModelAndView joinWithFacebookInfo(String facebook_id,String access_token,
			String name,String email,HttpSession httpSession){
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/index");
		
		return mav;
	}



}
