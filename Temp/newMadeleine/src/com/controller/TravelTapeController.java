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
import org.springframework.web.servlet.view.RedirectView;

import com.Facebook.FacebookInfoBiz;
import com.TravelTape.Biz.UserBiz;
import com.TravelTape.Entity.TravelTapeUser;
import com.TravelTape.Entity.TravelTapeUser.USER_TYPE;

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
	public ModelAndView mainHandler(){
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/index");
		
		return mav;
	}
	
	
	@RequestMapping(value = "/joinWithFacebookInfo.tt")
	public ModelAndView joinWithFacebookInfo(String facebook_id,
											String access_token,
											String name,
											String email,
											HttpSession httpSession){
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/jsonView");

		Session session = sessionFactory.openSession();
		session.beginTransaction();
		
		TravelTapeUser user;
		user = UserBiz.userWithForeginUserID(session, USER_TYPE.FACEBOOK_USER, facebook_id);
		
		if(user == null)
		{
			user = new TravelTapeUser();
			user.setForeginUserId(facebook_id);
			user.setForeginAccessToken(access_token);
			user.setName(name);
			user.setUserType(USER_TYPE.FACEBOOK_USER);
		
			Integer resultId = (Integer) session.save(user);
			System.out.println("::" + resultId + "::"+user);
		}
		else
		{
			JSONObject object;
		}
		
		session.getTransaction().commit();
		session.close();
		

		httpSession.setAttribute(TravelTapeUser.sessionAttributeName, user);
		
		return mav;
	}
	
	@RequestMapping(value = "/logout.tt")
	public ModelAndView logoutHandler(HttpSession httpSession){
		RedirectView rv = new RedirectView("/TravelTape");
		rv.setExposeModelAttributes(false);

		//logout
		httpSession.setAttribute(TravelTapeUser.sessionAttributeName, null);
		return new ModelAndView(rv);
	}

}
