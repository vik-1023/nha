package com.nha.dashboard;

import db.dbcon;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;

public class NhaServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        dbcon db = new dbcon();
        response.setContentType("application/json;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {

            String accountname = request.getParameter("accountname");
            String fromDate = request.getParameter("fromDate");
            String toDate = request.getParameter("toDate");
            String environment = request.getParameter("environment");
            String groupBy = request.getParameter("groupBy3");

            // Select the appropriate table based on the environment
            String tbl = ("production".equals(environment)) ? "User_Counts_Api_production" : "User_Counts_Api";
            System.out.println("accountname: " + accountname);
            System.out.println("fromDate: " + fromDate);
            System.out.println("toDate: " + toDate);
            System.out.println("environment: " + environment);
            System.out.println("groupBy: " + groupBy);

            HttpSession session = request.getSession(false);
            if (session == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\":\"User is not logged in or session has expired.\"}");
                return;
            }

            String usernameFromSession = (String) session.getAttribute("LogUsername");
            if (usernameFromSession == null){
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\":\"No username found in session.\"}");
                return;
            }
            db.getCon("nha_cdr");
            System.out.println("Username from session: " + usernameFromSession);

            // Get user type
            String userType = "";
            String sqlCheckUserType = "SELECT user_type FROM users WHERE username = '" + usernameFromSession + "'";
            Statement stmt = db.getStmt();
            ResultSet rsUserType = stmt.executeQuery(sqlCheckUserType);

            if (rsUserType.next()) {
                userType = rsUserType.getString("user_type");
                System.out.println("userType: " + userType);
            }

            // Start building the SQL query
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT ");

// Adjust SELECT columns based on groupBy condition
            if ("date".equals(groupBy)) {
                sql.append("t1.date, SUM(t1.Total) AS Total, SUM(t1.Success) AS Success, SUM(t1.Failed) AS Failed ");
            } else if ("account".equals(groupBy)) {
                sql.append("t1.Username, SUM(t1.Total) AS Total, SUM(t1.Success) AS Success, SUM(t1.Failed) AS Failed ");
            } else { // If groupBy is "none" or not provided
                sql.append("t1.date, t1.Username, t1.Total, t1.Success, t1.Failed ");
            }

            sql.append("FROM ").append(tbl).append(" t1 ");

// Join for latest records
            sql.append("JOIN ( ")
                    .append("    SELECT date, MAX(last_updated) AS max_last_updated ")
                    .append("    FROM ").append(tbl).append(" ")
                    .append("    GROUP BY date ")
                    .append(") t2 ON t1.date = t2.date AND t1.last_updated = t2.max_last_updated ");

// Apply filtering based on accountname
            if ("All".equals(accountname)) {
                if ("ABDM".equals(userType)) {
                    sql.append("JOIN AccountDetails ad ON ad.accountname = t1.Username ")
                            .append("WHERE ad.department = 'ABDM' AND ad.environment = '").append(environment).append("' ");
                } else if ("PMJAY".equals(userType)) {
                    sql.append("JOIN AccountDetails ad ON ad.accountname = t1.Username ")
                            .append("WHERE ad.department = 'PMJAY' AND ad.environment = '").append(environment).append("' ");
                }
            } else if (accountname != null && !accountname.isEmpty()) {
                sql.append("WHERE t1.Username = '").append(accountname).append("' ");
            }

// Apply date filter
            if (fromDate != null && !fromDate.isEmpty() && toDate != null && !toDate.isEmpty()) {
                if (fromDate.length() == 7 && toDate.length() == 7) {
                    sql.append("AND DATE_FORMAT(t1.date, '%Y-%m') BETWEEN '").append(fromDate).append("' AND '").append(toDate).append("' ");
                } else if (fromDate.length() == 10 && toDate.length() == 10) {
                    sql.append("AND t1.date BETWEEN '").append(fromDate).append("' AND '").append(toDate).append("' ");
                }
            }

// Apply GROUP BY based on the `groupBy` parameter
            if ("date".equals(groupBy)) {
                sql.append("GROUP BY t1.date ");
            } else if ("account".equals(groupBy)) {
                sql.append("GROUP BY t1.Username ");
            }

// Apply dynamic ORDER BY to avoid SQL error
            if ("date".equals(groupBy)) {
                sql.append("ORDER BY t1.date ");
            } else if ("account".equals(groupBy)) {
                sql.append("ORDER BY t1.Username ");
            }

            // Execute the SQL query
            ResultSet rs = stmt.executeQuery(sql.toString());
            System.out.println("SQL Query: " + sql.toString());

            // Prepare the JSON response
            JSONArray jsonArray = new JSONArray();

            // Iterate through the result set and construct JSON objects
            while (rs.next()) {
                JSONObject jsonObject = new JSONObject();

                if (!"account".equals(groupBy)) { // Show date only if not grouped by account
                    String date = rs.getString("date");
                    if (date != null) {
                        SimpleDateFormat originalFormat = new SimpleDateFormat("yyyy-MM-dd");
                        Date parsedDate = originalFormat.parse(date);
                        SimpleDateFormat targetFormat = new SimpleDateFormat("dd-MM-yyyy");
                        jsonObject.put("date", targetFormat.format(parsedDate));
                    }
                }

                if (!"date".equals(groupBy)) { // Show username only if not grouped by date
                    jsonObject.put("username", rs.getString("Username"));
                }

                // Remove decimal points or points from total, success, and failed values
                String total = rs.getString("Total");
                String success = rs.getString("Success");
                String failed = rs.getString("Failed");

                if (total != null) {
                    total = total.split("\\.")[0]; // Remove decimals if present
                    jsonObject.put("total", total);
                }

                if (success != null) {
                    success = success.split("\\.")[0]; // Remove decimals if present
                    jsonObject.put("success", success);
                }

                if (failed != null) {
                    failed = failed.split("\\.")[0]; // Remove decimals if present
                    jsonObject.put("failed", failed);
                }

                jsonArray.put(jsonObject);
            }

            // Output the JSON response
            out.print(jsonArray.toString());
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"error\": \"An error occurred while processing your request.\"}");
        } finally {
            db.closeConection();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
