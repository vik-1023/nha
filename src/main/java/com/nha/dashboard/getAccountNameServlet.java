
package com.nha.dashboard;

/**
 *
 * @author vikram
 */
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.google.gson.Gson;
import db.dbcon;
import java.io.IOException;
import java.sql.*;

import java.util.ArrayList;
import java.util.List;

public class getAccountNameServlet extends HttpServlet {

    // Process the request
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set content type to JSON since we're returning JSON data
        response.setContentType("application/json;charset=UTF-8");

        String environment = request.getParameter("environment");
        System.out.println("environment: " + environment);

        // Get the current session (false means don't create a new one)
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"User is not logged in or session has expired.\"}");
            return;
        }

        // Get the username from session
        String usernameFromSession = (String) session.getAttribute("LogUsername");
        if (usernameFromSession == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"No username found in session.\"}");
            return;
        }
        System.out.println("Username from session: " + usernameFromSession);

        // Check user type from the users table (assuming you have a column "user_type" in the users table)
        String userType = "";
        String sqlCheckUserType = "SELECT user_type FROM users WHERE username = '" + usernameFromSession + "'";

        dbcon db = null;
        ResultSet rsUserType = null;
        Statement stmt = null;
        try {
            // Establish the database connection
            db = new dbcon();
            db.getCon("nha_cdr");

            // Create Statement object for executing queries
            stmt = db.getStmt();

            // Get user type
            rsUserType = stmt.executeQuery(sqlCheckUserType);
            if (rsUserType.next()) {
                userType = rsUserType.getString("user_type");
                System.out.println("userType: " + userType);
            }

            if ("admin".equals(userType)) {
                // Admins are allowed to view all account names without filtering by department
                response.setStatus(HttpServletResponse.SC_OK);
                String sql = "";
                if ("PMJAY".equals(environment)) {
                   sql = "SELECT DISTINCT accountname FROM AccountDetails WHERE department = 'PMJAY';";
                } else if ("ABDM".equals(environment)) {
                    
                    sql = "SELECT  DISTINCT accountname FROM AccountDetails WHERE department = 'ABDM';";
                }

                // Execute the SQL query for admin
                executeQueryAndSendResponse(db, sql, response);
                return; // End the processing for admin user here
            } else if (!"ABDM".equals(userType) && !"PMJAY".equals(userType)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"error\":\"User type not authorized to view this data.\"}");
                return;
            }

        } catch (SQLException e) {
            // Handle database error while fetching user type
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Error checking user role.\"}");
            e.printStackTrace();
            return;
        } finally {
            // Close the ResultSet but not Statement yet
            try {
                if (rsUserType != null) {
                    rsUserType.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // Validate the environment parameter
        if (environment == null || (!"production".equals(environment) && !"sandbox".equals(environment))) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Invalid or missing environment parameter\"}");
            return;
        }

        // For non-admin users (ABDM or PMJAY), query the department-specific data
        String sql = "";

// Check if the userType is 'ABDM'
        if ("ABDM".equals(userType)) {
            if ("production".equals(environment)) {
                // If environment is 'production' for 'ABDM', fetch from production
                sql = "SELECT DISTINCT accountname FROM AccountDetails WHERE department = 'ABDM';";
            } else if ("sandbox".equals(environment)) {
                // If environment is 'sandbox' for 'ABDM', fetch from sandbox
               sql = "SELECT DISTINCT accountname FROM AccountDetails WHERE department = 'ABDM';";
            }
        } else if ("PMJAY".equals(userType)) {
            if ("production".equals(environment)) {
                // If environment is 'production' for 'PMJAY', fetch from production
                //sql = "SELECT accountname FROM AccountDetails WHERE environment = 'production' AND department IN ('PMJAY');";
                sql = "SELECT DISTINCT accountname FROM AccountDetails WHERE department = 'PMJAY';";
            } else if ("sandbox".equals(environment)) {
                // If environment is 'sandbox' for 'PMJAY', fetch from sandbox
                //sql = "SELECT accountname FROM AccountDetails WHERE environment = 'sandbox' AND department IN ('PMJAY');";
                sql = "SELECT DISTINCT accountname FROM AccountDetails WHERE department = 'PMJAY';";
            }
        } else {
            // Handle invalid or unauthorized user types
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Invalid user type\"}");
            return;
        }

        System.out.println("sql query for getting account Name :" + sql);
        // Execute the SQL query for ABDM or PMJAY
        executeQueryAndSendResponse(db, sql, response);
    }

    private void executeQueryAndSendResponse(dbcon db, String sql, HttpServletResponse response) throws IOException {
        ResultSet rs = null;
        try {
            // Execute the SQL query
            rs = db.getResult(sql);

            // Create a list to store the account names
            List<String> accountNames = new ArrayList<>();
            while (rs.next()) {
                String accountname = rs.getString("accountname");
                if (accountname != null && !accountname.trim().isEmpty()) {
                    accountNames.add(accountname);
                }
            }

            // Convert the list to a JSON array and send it as the response
            response.getWriter().write(new Gson().toJson(accountNames));

        } catch (SQLException e) {
            // Log and handle database errors
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Database error occurred.\"}");
            e.printStackTrace();
        } catch (Exception e) {
            // Handle any general errors
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"An unexpected error occurred.\"}");
            e.printStackTrace();
        } finally {
            // Ensure that resources are always closed in the correct order
            try {
                if (rs != null) {
                    rs.close();
                }
                if (db != null) {
                    db.closeConection();
                }
            } catch (SQLException e) {
                // Log any errors while closing the resources
                e.printStackTrace();
            }
        }
    }

    // Handle GET request
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    // Handle POST request
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
