package com.nha.dashboard;

import db.dbcon;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;

public class Dashboard_Monitor extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        dbcon db = new dbcon();
        JSONArray jsonArray = new JSONArray();
        HttpSession session = request.getSession(false);

        if (session == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"User session is not valid or has expired.\"}");
            return;
        }

        String usernameFromSession = (String) session.getAttribute("LogUsername");
        if (usernameFromSession == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"No username found in session.\"}");
            return;
        }

        System.out.println("Username from session: " + usernameFromSession);

        String userType = "";
        ResultSet rsUserType = null;
        Statement stmt = null;

        try {
            db.getCon("nha_cdr");
            stmt = db.getStmt();

            String sqlCheckUserType = "SELECT user_type FROM nha_cdr.users WHERE username = '" + usernameFromSession + "'";
            System.out.println("Executing query: " + sqlCheckUserType);

            rsUserType = stmt.executeQuery(sqlCheckUserType);
            if (rsUserType.next()) {
                userType = rsUserType.getString("user_type");
                System.out.println("UserType: " + userType);
            }

            // SQL queries
            // Initialize sums for both queries
            int total1 = 0;
            int success1 = 0;
            int total2 = 0;
            int success2 = 0;

            // Check user type and execute queries if authorized
            if ("admin".equals(userType)) {

                total1 = executeQuery(db, "SELECT SUM(t1.Total) AS Total FROM User_Counts_Api t1 JOIN (SELECT date, MAX(last_updated) AS max_last_updated FROM User_Counts_Api WHERE date = CURDATE() GROUP BY date) t2 ON t1.date = t2.date AND t1.last_updated = t2.max_last_updated WHERE t1.date = CURDATE()", "Total");
                success1 = executeQuery(db, "SELECT SUM(t1.Success) AS Success FROM User_Counts_Api t1 JOIN (SELECT date, MAX(last_updated) AS max_last_updated FROM User_Counts_Api WHERE date = CURDATE() GROUP BY date) t2 ON t1.date = t2.date AND t1.last_updated = t2.max_last_updated WHERE t1.date = CURDATE()", "Success");
                total2 = executeQuery(db, "SELECT SUM(t1.Total) AS Total FROM User_Counts_Api_production t1 JOIN (SELECT date, MAX(last_updated) AS max_last_updated FROM User_Counts_Api_production WHERE date = CURDATE() GROUP BY date) t2 ON t1.date = t2.date AND t1.last_updated = t2.max_last_updated WHERE t1.date = CURDATE()", "Total");
                success2 = executeQuery(db, "SELECT SUM(t1.Success) AS Success FROM User_Counts_Api_production t1 JOIN (SELECT date, MAX(last_updated) AS max_last_updated FROM User_Counts_Api_production WHERE date = CURDATE() GROUP BY date) t2 ON t1.date = t2.date AND t1.last_updated = t2.max_last_updated WHERE t1.date = CURDATE()", "Success");
                System.out.println("total1 admin: " + total1 + " total2 : " + total2);
            } else if ("ABDM".equals(userType)) {
                total1 = executeQuery(db, "SELECT SUM(t1.Total) AS Total_Sum FROM User_Counts_Api t1 JOIN AccountDetails ad ON ad.accountname = t1.Username WHERE ad.department = 'ABDM' AND t1.last_updated = (SELECT MAX(last_updated) FROM User_Counts_Api WHERE date = CURRENT_DATE) AND t1.date = CURRENT_DATE", "Total_Sum");
                success1 = executeQuery(db, "SELECT SUM(t1.Success) AS Success_Sum FROM User_Counts_Api t1 JOIN AccountDetails ad ON ad.accountname = t1.Username WHERE ad.department = 'ABDM' AND t1.last_updated = (SELECT MAX(last_updated) FROM User_Counts_Api WHERE date = CURRENT_DATE) AND t1.date = CURRENT_DATE", "Success_Sum");
                total2 = executeQuery(db, "SELECT SUM(t1.Total) AS Total_Sum FROM User_Counts_Api_production t1 JOIN AccountDetails ad ON ad.accountname = t1.Username WHERE ad.department = 'ABDM' ANd ad.environment='production' AND t1.last_updated = (SELECT MAX(last_updated) FROM User_Counts_Api_production WHERE date = CURRENT_DATE) AND t1.date = CURRENT_DATE", "Total_Sum");
                success2 = executeQuery(db, "SELECT SUM(t1.Success) AS Success_Sum FROM User_Counts_Api_production t1 JOIN AccountDetails ad ON ad.accountname = t1.Username WHERE ad.department = 'ABDM' ANd ad.environment='production' AND t1.last_updated = (SELECT MAX(last_updated) FROM User_Counts_Api_production WHERE date = CURRENT_DATE) AND t1.date = CURRENT_DATE", "Success_Sum");
                System.out.println("total1 ABDM: " + total1 + " total2 : " + total2);
            } else if ("PMJAY".equals(userType)) {
                total1 = executeQuery(db, "SELECT SUM(COALESCE(t1.Total, 0)) AS Total FROM User_Counts_Api t1 JOIN (SELECT date, MAX(last_updated) AS max_last_updated FROM User_Counts_Api WHERE date = CURDATE() GROUP BY date) t2 ON t1.date = t2.date AND t1.last_updated = t2.max_last_updated JOIN AccountDetails ad ON ad.accountname = t1.Username WHERE t1.date = CURDATE() AND ad.department = 'PMJAY' ANd ad.environment='sandbox'", "Total");
                success1 = executeQuery(db, "SELECT SUM(COALESCE(t1.Success, 0)) AS Success FROM User_Counts_Api t1 JOIN (SELECT date, MAX(last_updated) AS max_last_updated FROM User_Counts_Api WHERE date = CURDATE() GROUP BY date) t2 ON t1.date = t2.date AND t1.last_updated = t2.max_last_updated JOIN AccountDetails ad ON ad.accountname = t1.Username WHERE t1.date = CURDATE() AND ad.department = 'PMJAY' ANd ad.environment='sandbox'", "Success");
                total2 = executeQuery(db, "SELECT SUM(COALESCE(t1.Total, 0)) AS Total FROM User_Counts_Api_production t1 JOIN (SELECT date, MAX(last_updated) AS max_last_updated FROM User_Counts_Api_production WHERE date = CURDATE() GROUP BY date) t2 ON t1.date = t2.date AND t1.last_updated = t2.max_last_updated JOIN AccountDetails ad ON ad.accountname = t1.Username WHERE t1.date = CURDATE() AND ad.department = 'PMJAY' ANd ad.environment='production'", "Total");
                success2 = executeQuery(db, "SELECT SUM(COALESCE(t1.Success, 0)) AS Success FROM User_Counts_Api_production t1 JOIN (SELECT date, MAX(last_updated) AS max_last_updated FROM User_Counts_Api_production WHERE date = CURDATE() GROUP BY date) t2 ON t1.date = t2.date AND t1.last_updated = t2.max_last_updated JOIN AccountDetails ad ON ad.accountname = t1.Username WHERE t1.date = CURDATE() AND ad.department = 'PMJAY' ANd ad.environment='production'", "Success");
                System.out.println("total1 PMJAY: " + total1 + " total2 : " + total2);
            }

            System.out.println("total1: " + total1);
            System.out.println("total2: " + total2);
            System.out.println("success1: " + success1);
            System.out.println("success2: " + success2);

            // Sum the totals and successes
            int totalSum = total1 + total2;
            int successSum = success1 + success2;
            System.out.println("totalSum: " + totalSum);
            System.out.println("successSum: " + successSum);

            // Prepare JSON response
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("Total", totalSum);
            jsonObject.put("Success", successSum);
            jsonArray.put(jsonObject);

            response.getWriter().print(jsonArray.toString());

        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Database query failed.\"}");
        } finally {
            try {
                if (rsUserType != null) {
                    rsUserType.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (db != null) {
                    db.closeConection();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private int executeQuery(dbcon db, String sql, String columnName) throws SQLException {
        int sum = 0;
        try (ResultSet rs = db.getResult(sql)) {
            if (rs != null && rs.next()) {
                sum = rs.getObject(columnName) != null ? rs.getInt(columnName) : 0;
            }
        }
        return sum;
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
