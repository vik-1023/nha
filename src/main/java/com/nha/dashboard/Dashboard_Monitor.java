/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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
                String sql1 = "SELECT SUM(t1.Total) AS Total, SUM(t1.Success) AS Success, SUM(t1.Failed) AS Failed "
                        + "FROM User_Counts_Api t1 "
                        + "JOIN (SELECT date, MAX(last_updated) AS max_last_updated FROM User_Counts_Api "
                        + "WHERE date = CURDATE() GROUP BY date) t2 "
                        + "ON t1.date = t2.date AND t1.last_updated = t2.max_last_updated "
                        + "WHERE t1.date = CURDATE();";

                String sql2 = "SELECT SUM(t1.Total) AS Total, SUM(t1.Success) AS Success, SUM(t1.Failed) AS Failed "
                        + "FROM User_Counts_Api_production t1 "
                        + "JOIN (SELECT date, MAX(last_updated) AS max_last_updated FROM User_Counts_Api_production "
                        + "WHERE date = CURDATE() GROUP BY date) t2 "
                        + "ON t1.date = t2.date AND t1.last_updated = t2.max_last_updated "
                        + "WHERE t1.date = CURDATE();";

                System.out.println("Query 1: for sandbox" + sql1);
                System.out.println("Query 2 for production: " + sql2);

                total1 = executeQuery(db, sql1, "Total");
                success1 = executeQuery(db, sql1, "Success");
                total2 = executeQuery(db, sql2, "Total");
                success2 = executeQuery(db, sql2, "Success");

            } else if ("ABDM".equals(userType)) {

                String sql1 = "SELECT \n"
                        + "    SUM(COALESCE(t1.Total, 0)) AS Total, \n"
                        + "    SUM(COALESCE(t1.Success, 0)) AS Success, \n"
                        + "    SUM(COALESCE(t1.Failed, 0)) AS Failed\n"
                        + "FROM User_Counts_Api t1\n"
                        + "JOIN (\n"
                        + "    SELECT date, MAX(last_updated) AS max_last_updated \n"
                        + "    FROM User_Counts_Api \n"
                        + "    WHERE date = CURDATE() \n"
                        + "    GROUP BY date\n"
                        + ") t2 ON t1.date = t2.date AND t1.last_updated = t2.max_last_updated\n"
                        + "JOIN AccountDetails ad ON ad.accountname = t1.Username\n"
                        + "WHERE t1.date = CURDATE() \n"
                        + "AND ad.department = 'ABDM';";

                String sql2 = "SELECT \n"
                        + "    SUM(COALESCE(t1.Total, 0)) AS Total, \n"
                        + "    SUM(COALESCE(t1.Success, 0)) AS Success, \n"
                        + "    SUM(COALESCE(t1.Failed, 0)) AS Failed\n"
                        + "FROM User_Counts_Api_production t1\n"
                        + "JOIN (\n"
                        + "    SELECT date, MAX(last_updated) AS max_last_updated \n"
                        + "    FROM User_Counts_Api_production \n"
                        + "    WHERE date = CURDATE() \n"
                        + "    GROUP BY date\n"
                        + ") t2 ON t1.date = t2.date AND t1.last_updated = t2.max_last_updated\n"
                        + "JOIN AccountDetails ad ON ad.accountname = t1.Username\n"
                        + "WHERE t1.date = CURDATE() \n"
                        + "AND ad.department = 'ABDM';";

                System.out.println("Query 1: for sandbox" + sql1);
                System.out.println("Query 2 for production: " + sql2);

                total1 = executeQuery(db, sql1, "Total");
                success1 = executeQuery(db, sql1, "Success");
                total2 = executeQuery(db, sql2, "Total");
                success2 = executeQuery(db, sql2, "Success");

            }

            
            else if ("PMJAY".equals(userType)) {

                String sql1 = "SELECT \n"
                        + "    SUM(COALESCE(t1.Total, 0)) AS Total, \n"
                        + "    SUM(COALESCE(t1.Success, 0)) AS Success, \n"
                        + "    SUM(COALESCE(t1.Failed, 0)) AS Failed\n"
                        + "FROM User_Counts_Api t1\n"
                        + "JOIN (\n"
                        + "    SELECT date, MAX(last_updated) AS max_last_updated \n"
                        + "    FROM User_Counts_Api \n"
                        + "    WHERE date = CURDATE() \n"
                        + "    GROUP BY date\n"
                        + ") t2 ON t1.date = t2.date AND t1.last_updated = t2.max_last_updated\n"
                        + "JOIN AccountDetails ad ON ad.accountname = t1.Username\n"
                        + "WHERE t1.date = CURDATE() \n"
                        + "AND ad.department = 'PMJAY';";

                String sql2 = "SELECT \n"
                        + "    SUM(COALESCE(t1.Total, 0)) AS Total, \n"
                        + "    SUM(COALESCE(t1.Success, 0)) AS Success, \n"
                        + "    SUM(COALESCE(t1.Failed, 0)) AS Failed\n"
                        + "FROM User_Counts_Api_production t1\n"
                        + "JOIN (\n"
                        + "    SELECT date, MAX(last_updated) AS max_last_updated \n"
                        + "    FROM User_Counts_Api_production \n"
                        + "    WHERE date = CURDATE() \n"
                        + "    GROUP BY date\n"
                        + ") t2 ON t1.date = t2.date AND t1.last_updated = t2.max_last_updated\n"
                        + "JOIN AccountDetails ad ON ad.accountname = t1.Username\n"
                        + "WHERE t1.date = CURDATE() \n"
                        + "AND ad.department = 'PMJAY';";

                System.out.println("Query 1: for sandbox" + sql1);
                System.out.println("Query 2 for production: " + sql2);

                total1 = executeQuery(db, sql1, "Total");
                success1 = executeQuery(db, sql1, "Success");
                total2 = executeQuery(db, sql2, "Total");
                success2 = executeQuery(db, sql2, "Success");

            }
            
            
            
            System.out.println("total1 :" + total1);
            System.out.println("total2 :" + total2);

            System.out.println("success1 :" + success1);
            System.out.println("success2 :" + success2);
            // Sum the totals and successes
            int totalSum = total1 + total2;
            int successSum = success1 + success2;
            System.out.println("totalSum :" + totalSum);
            System.out.println("successSum :" + successSum);
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
