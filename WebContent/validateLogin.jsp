<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%

	String authenticatedUser = null;	
	try
	{
		authenticatedUser = validateLogin(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null)
		response.sendRedirect("index.jsp");		// Successful login
	else
		response.sendRedirect("login.jsp");		// Failed login - redirect back to login page with a message 
%>


<%!
	String validateLogin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String username = request.getParameter("username");
		String password1 = request.getParameter("password");
		String retStr = null;

		if(username == null || password1 == null)
				return null;
		if((username.length() == 0) || (password1.length() == 0))
				return null;

		try 
		{
			getConnection();
			// TODO: Check if userId and password match some customer account. If so, set retStr to be the username.
			PreparedStatement psmt = con.prepareStatement("SELECT userid FROM Customer WHERE userid = ? AND password = ?");
			psmt.setString(1, username);
			psmt.setString(2, password1);

			ResultSet rs = psmt.executeQuery();
			if (rs.next()) {
    			retStr = rs.getString("userid"); 
			}
			rs.close();
			psmt.close();
						
		} 
		catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{
			closeConnection();
		}	
		
		if(retStr != null)
		{	session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser",username);
		}
		else
			session.setAttribute("loginMessage","Could not connect to the system using that username/password.");

		return retStr;
	}
%>

