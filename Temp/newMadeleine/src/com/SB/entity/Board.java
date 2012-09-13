package com.SB.entity;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.Table;

import org.hibernate.Hibernate;
import org.hibernate.annotations.GenericGenerator;

import com.Madeleine.Entity.MadeleinePhoto;
import com.Madeleine.Entity.User;
import com.Madeleine.Entity.Madeleine.MadeleineSendState;


@Entity
@Table(name="SB_BOARD")
public class Board implements Serializable {
	public enum MadeleineSendState{
		NOT_SENDED,
		SENDED,
		OPENED
	};
	private static final long serialVersionUID = 1L;
	@Id
	@GeneratedValue(strategy=GenerationType.SEQUENCE,generator="SEQ_TRIGGER")
	@GenericGenerator(name ="SEQ_TRIGGER",strategy="jpl.hibernate.util.TriggerAssignedIdentityGenerator")
	@Column(name = "idx")
	private Integer idx;
	@Column(name = "title")
	private String title;
	@Column(name = "text")
	private String text;
	@Column(name = "written_time")
	private Timestamp writtenTime;
	@Column(name = "modified_time")
	private Timestamp modifiedTime;
	
	
	public Board(){
		super();
	}
	
	
	public Integer getIdx() {
		return idx;
	}
	public void setIdx(Integer idx) {
		this.idx = idx;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public Timestamp getWrittenTime() {
		return writtenTime;
	}
	public void setWrittenTime(Timestamp writtenTime) {
		this.writtenTime = writtenTime;
	}
	public Timestamp getModifiedTime() {
		return modifiedTime;
	}
	public void setModifiedTime(Timestamp modifiedTime) {
		this.modifiedTime = modifiedTime;
	}
	
	
}