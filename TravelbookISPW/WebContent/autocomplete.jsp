<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page language="java" %>
<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@ page import="main.java.travelbook.controller.*" %>
<%
    try
    {
    	ControllerSearch controller=ControllerSearch.getInstance();
    	 String query = (String)request.getParameter("search");
    	 System.out.println(query);
		List <String> l=controller.getCitiesPredictions(query);
        JSONArray json=new JSONArray();
        JSONObject o=new JSONObject();
		int i=0;
		while(i<l.size()){
			o.put("citta", l.get(i));
			i++;
     	 }
		out.print(o);
    } catch(Exception e1)
      {
      out.println(e1);
      }

%>
