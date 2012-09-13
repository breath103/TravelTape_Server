package com.TravelTape.Entity;

import javax.persistence.Entity;
import javax.persistence.Table;

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
@Table(name="TAPE_CONTENTS")
public class TapeContents implements Serializable{
	private static final long serialVersionUID = 1L;
	@Id
	@GeneratedValue(strategy=GenerationType.SEQUENCE,generator="SEQ_TRIGGER")
	@GenericGenerator(name ="SEQ_TRIGGER",strategy="jpl.hibernate.util.TriggerAssignedIdentityGenerator")
	@Column(name = "IDX")
	private Integer idx;
	@Column(name = "JOURNAL_IDX")
	private Integer journalIdx;
	@Column(name = "FACEBOOK_ID")
	private String facebookID;
	@Column(name = "LATITUDE")
	private Double latitude;
	@Column(name = "LONGITUDE")
	private Double longitude;
	
	public TapeContents() {
		super();
	}
	
	public Integer getIdx() {
		return idx;
	}
	public void setIdx(Integer idx) {
		this.idx = idx;
	}
	public Integer getJournalIdx() {
		return journalIdx;
	}
	public void setJournalIdx(Integer journalIdx) {
		this.journalIdx = journalIdx;
	}
	public String getFacebookID() {
		return facebookID;
	}
	public void setFacebookID(String facebookID) {
		this.facebookID = facebookID;
	}
	public Double getLatitude() {
		return latitude;
	}
	public void setLatitude(Double latitude) {
		this.latitude = latitude;
	}
	public Double getLongitude() {
		return longitude;
	}
	public void setLongitude(Double longitude) {
		this.longitude = longitude;
	}
}
