package com.common;

import java.util.List;

public interface CommonDAO<T> {
	public List<T> findAll();

	T insert(T madeleine);
	T findByIdx(Integer idx);
	
	void update(T madeleine);
	void delete(T madeleine);
}
