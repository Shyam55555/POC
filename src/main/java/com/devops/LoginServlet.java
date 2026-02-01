package com.devops;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Properties;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

//@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	 private static final long serialVersionUID = 1L;
	private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());
	    private Properties properties = new Properties();

	    public void init() {
	        InputStream input = getClass().getClassLoader().getResourceAsStream("config.properties");
	        
	        if (input == null) {
	            LOGGER.severe("[ERROR] Property file 'config.properties' not found in the classpath");
	            return;
	        }
	        
	        try {
	            properties.load(input);
	            LOGGER.info("[Success] Properties file loaded successfully.");
	        } catch (IOException e) {
	            LOGGER.severe("[ERROR] Error loading properties file" + e);
	        }
	    }
	    
	    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	        String username = request.getParameter("username");
	        String password = request.getParameter("password");
	        
	        String adminUser = properties.getProperty("admin.username");
	        String adminPass = properties.getProperty("admin.password");
	        
	        LOGGER.info("[Message] Attempted login with username: " + username);
	        
	        if (adminUser != null && adminPass != null && adminUser.equals(username) && adminPass.equals(password)) {
	            LOGGER.info("[Message] Login successful for user: " + username);
	            response.sendRedirect("login-success.jsp");
	        } else {
	            LOGGER.warning("[WARNING] Login failed for user: " + username);
	            response.sendRedirect("login-failed.jsp");
	        }
	    }
}

