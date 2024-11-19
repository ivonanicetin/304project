

 <%@ page trimDirectiveWhitespaces="true" import="java.sql.*,java.io.*" %><%@ include file="jdbc.jsp" %><%

 //added null check to avoid having blank image showing up when these wasn't binary data
 //refacotred code to avoid a refresh issue where image would not show up until refreshing the page

// Indicate that we are sending a JPG picture
response.setContentType("image/jpeg");  

// Get the image id
String id = request.getParameter("id");

if (id == null)
	return;

int idVal = -1;
try {
	idVal = Integer.parseInt(id);
} catch (Exception e) {
	out.println("Invalid image id: " + id + " Error: " + e);
	return; 
}

String sql = "SELECT productImage FROM Product P WHERE productId = ?";

InputStream istream = null; 
OutputStream ostream = null; 

try {
	getConnection();

	PreparedStatement stmt = con.prepareStatement(sql);
	stmt.setInt(1, idVal);
	ResultSet rst = stmt.executeQuery();		

	int BUFFER_SIZE = 10000;
	byte[] data = new byte[BUFFER_SIZE];

	if (rst.next()) {
		// Copy stream of bytes from database to output stream for JSP/Servlet
		istream = rst.getBinaryStream(1); 

		// Check if the stream is null 
		if (istream == null) {
			return; 
		}

		ostream = response.getOutputStream(); // Get response output stream

		int count;
		while ((count = istream.read(data, 0, BUFFER_SIZE)) != -1) {
			ostream.write(data, 0, count);
		}
		ostream.flush(); // all data is written
	}
} 
catch (SQLException e) {
	out.println("SQL Error: " + e); 
} 

finally {
	closeConnection(); // Close the database connection
}
%>

