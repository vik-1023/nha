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
            String environment = "production";
            String department = request.getParameter("environment");
            String groupBy = request.getParameter("groupBy3");

//      
            // Select the appropriate table based on the environment
            String tbl = ("production".equals(environment)) ? "User_Counts_Api_production" : "User_Counts_Api_production";
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
            if (usernameFromSession == null) {
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

            // Build SQL query dynamically
            String sql = "SELECT ";

            // Adjust SELECT columns based on groupBy condition
            if ("date".equals(groupBy)) {
                sql += "t1.date, SUM(t1.Total) AS Total, SUM(t1.Success) AS Success, SUM(t1.Failed) AS Failed ";
            } else if ("account".equals(groupBy)) {
                sql += "t1.Username, SUM(t1.Total) AS Total, SUM(t1.Success) AS Success, SUM(t1.Failed) AS Failed ";
            } else { // If groupBy is "none" or not provided
                sql += "t1.date, t1.Username, t1.Total, t1.Success, t1.Failed ";
            }

            sql += "FROM " + tbl + " t1 "
                    + "JOIN (SELECT date, MAX(last_updated) AS max_last_updated FROM " + tbl + " GROUP BY date) t2 "
                    + "ON t1.date = t2.date AND t1.last_updated = t2.max_last_updated ";

            // Apply filtering based on accountname
            System.out.println("Account:" + accountname);
            if ("All".equals(accountname)) {
                if ("ABDM".equals(userType)) {
                    sql += "JOIN AccountDetails ad ON ad.accountname = t1.Username WHERE ad.department = '" + userType + "' AND ad.environment = '" + environment + "' ";
                } else if ("PMJAY".equals(userType)) {
                    sql += "JOIN AccountDetails ad ON ad.accountname = t1.Username WHERE ad.department = '" + userType + "' AND ad.environment = '" + environment + "' ";
                } else {
                    sql += "JOIN AccountDetails ad ON ad.accountname = t1.Username WHERE ad.department = '" + department + "' AND ad.environment = '" + environment + "' ";

                }
            } else if (accountname != null && !accountname.isEmpty()) {
                sql += "JOIN AccountDetails ad ON ad.accountname = t1.Username WHERE ad.department = '" + department + "' AND ad.environment = '" + environment + "' and t1.Username = '" + accountname + "' ";

            }

            // Apply date filter
            if (fromDate != null && !fromDate.isEmpty() && toDate != null && !toDate.isEmpty()) {

                if (fromDate.length() == 7 && toDate.length() == 7) {

                    sql += " AND DATE_FORMAT(t1.date, '%Y-%m') BETWEEN '" + fromDate + "' AND '" + toDate + "' ";
                    //sql += " JOIN AccountDetails ad ON ad.accountname = t1.Username WHERE ad.department = '" + department + "' ";

                } else if (fromDate.length() == 10 && toDate.length() == 10) {
                    sql += "AND t1.date BETWEEN '" + fromDate + "' AND '" + toDate + "' ";
                } else {
                    sql += "JOIN AccountDetails ad ON ad.accountname = t1.Username WHERE ad.department = '" + department + "' AND ad.environment = '" + environment + "' and t1.Username = '" + accountname + "' ";

                }
            }

            // Apply GROUP BY based on the groupBy parameter
            if ("date".equals(groupBy)) {
                sql += "GROUP BY t1.date ";
            } else if ("account".equals(groupBy)) {
                sql += "GROUP BY t1.Username ";
            }

            // Apply dynamic ORDER BY to avoid SQL error
            if ("date".equals(groupBy)) {
                sql += "ORDER BY t1.date ";
            } else if ("account".equals(groupBy)) {
                sql += "ORDER BY t1.Username ";
            }
            System.out.println("Exexcuting:" + sql);

            // Execute the SQL query
            ResultSet rs = stmt.executeQuery(sql);
            System.out.println("SQL Query: " + sql);

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
                String total = rs.getInt("Total") + "";
                String success = rs.getInt("Success") + "";
                String failed = rs.getInt("Failed") + "";

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
