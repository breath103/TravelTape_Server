package com.TravelTape.Entity;



import java.io.Serializable;
import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name="TAPE")
public class Tape implements Serializable{
	private static final long serialVersionUID = 1L;
	@Id
	@GeneratedValue(strategy=GenerationType.SEQUENCE,generator="SEQ_TRIGGER")
	@GenericGenerator(name ="SEQ_TRIGGER",strategy="jpl.hibernate.util.TriggerAssignedIdentityGenerator")
	@Column(name = "IDX")
	private Integer idx;
	@Column(name = "USER_ID")
	private String userId;
	@Column(name = "NAME")
	private String name;
	@Column(name = "START_TIME")
	private Timestamp startTime;
	@Column(name = "END_TIME")
	private Timestamp endTime;
	
	
	public Tape(){
		
	}
	public Tape(Integer idx, String userId, String name,
			Timestamp startTime, Timestamp endTime) {
		super();
		this.idx = idx;
		this.userId = userId;
		this.name = name;
		this.startTime = startTime;
		this.endTime = endTime;
	}
	public Integer getIdx() { return idx; }
	public void setIdx(Integer idx) { this.idx = idx; }
	public String getUserId() { return userId; }
	public void setUserId(String userId) { this.userId = userId; }
	public String getName() { return name; }
	public void setName(String name) { this.name = name; }
	public Timestamp getStartTime() { return startTime;}
	public void setStartTime(Timestamp startTime) {this.startTime = startTime;}
	public Timestamp getEndTime() {return endTime;}
	public void setEndTime(Timestamp endTime) {this.endTime = endTime;}
	
	public String toString(){
		return String.format("%s,%s,%s,%s,%s",idx,userId,name,startTime,endTime);
	}
	
	
}
