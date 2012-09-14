package com.TravelTape.Biz;

import org.hibernate.Session;

import com.TravelTape.Entity.TravelTapeUser;
import com.TravelTape.Entity.TravelTapeUser.USER_TYPE;

public class UserBiz {
	public static TravelTapeUser userWithForeginUserID(Session session,USER_TYPE userType,String foreginUserID){
		return (TravelTapeUser)session.createQuery("from TravelTapeUser where foreginUserID = ? and userType = ?")
				.setParameter(0, foreginUserID)
				.setParameter(1, userType)
				.uniqueResult();
	}
}
