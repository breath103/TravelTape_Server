/**
 * 
 */
package com.test;

import static org.junit.Assert.*;

import java.util.List;

import junit.framework.TestCase;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.Madeleine.Entity.User;
import com.Madeleine.Entity.User.USER_TYPE;
import com.Madeleine.service.UserService;
import com.TravelTape.Entity.Tape;

import junit.extensions.TestSetup;
/**
 * @author breath103
 *
 */
public class HibernateTest extends TestCase{
	public static junit.framework.Test suite(){
		HibernateTest testCase = new HibernateTest();
		testCase.setName("test");
	    // Only include short tests
//	    suite.addTest(new TestClassTwo("testShortTest"));
	//    suite.addTest(new TestClassTwo("testAnotherShortTest"));

	    TestSetup wrapper =  new TestSetup(testCase) {
	    // TestSetup 클래스의 setUp과 tearDown() 메서드를 재정의 한다.
	        protected void setUp() {
	        }
	        protected void tearDown() {
	        }
	      };

	    return wrapper.getTest();
	}
	
	private SessionFactory sessionFactory;
	@Autowired  
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}	
	public SessionFactory getSessionFactory() {
		return sessionFactory;
	}

	/**
	 * @throws java.lang.Exception
	 */
	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
	}



	/**
	 * @throws java.lang.Exception
	 */
	@AfterClass
	public static void tearDownAfterClass() throws Exception {
	}

	/**
	 * @throws java.lang.Exception
	 */
	@Before
	public void setUp() throws Exception {
		Session session = sessionFactory.openSession();
		session.beginTransaction();
	
		List<Tape> journals = session.createQuery("from "+Tape.class.getName()).list();
		
		System.out.println(journals);
		
		session.getTransaction().commit();   
		session.close();
	}

	/**
	 * @throws java.lang.Exception
	 */
	@After
	public void tearDown() throws Exception {
	}

	@Test
	public void test() {
		
	}

}
