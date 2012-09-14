package com.TravelTape.Entity;

import java.util.List;
import java.util.Set;
import java.io.Serializable;


import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.SequenceGenerator;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Column;
import javax.persistence.OneToMany;
import javax.persistence.UniqueConstraint;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.annotations.GenericGenerator;

import com.Madeleine.Entity.Madeleine.MadeleineSendState;

@Entity
@Table(
		name="TT_USER"
)
public class TravelTapeUser implements Serializable{
	private static final long serialVersionUID = 1L;
	public static final String sessionAttributeName = "LOGINED_USER_SESSION_KEY";
	public enum USER_TYPE{
		FACEBOOK_USER,
	}
	
	@Id
	@GeneratedValue(strategy=GenerationType.SEQUENCE,generator="SEQ_TRIGGER")
	@GenericGenerator(name ="SEQ_TRIGGER",strategy="jpl.hibernate.util.TriggerAssignedIdentityGenerator")
	@Column(name = "idx")
	private Integer idx;
	@Column(name = "user_type")
	private USER_TYPE userType;
	@Column(name = "foreign_user_id")
	private String foreginUserID;
	@Column(name = "foreign_access_token")
	private String foreginAccessToken;
	@Column(name = "name")
	private String name;
	
	
	
	public TravelTapeUser() {
		super();
	}
	
	
	public Integer getIdx() {
		return idx;
	}
	public void setIdx(Integer idx) {
		this.idx = idx;
	}
	public USER_TYPE getUserType() {
		return userType;
	}
	public void setUserType(USER_TYPE userType) {
		this.userType = userType;
	}
	public String getForeginUserID() {
		return foreginUserID;
	}
	public void setForeginUserId(String foreginUserID) {
		this.foreginUserID = foreginUserID;
	}
	public String getForeginAccessToken() {
		return foreginAccessToken;
	}
	public void setForeginAccessToken(String foreginAccessToken) {
		this.foreginAccessToken = foreginAccessToken;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
}

