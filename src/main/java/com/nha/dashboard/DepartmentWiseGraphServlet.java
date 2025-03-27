/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.nha.dashboard;

import db.dbcon;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;

public class DepartmentWiseGraphServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        dbcon db = new dbcon();
        String sql = "";
        String depType = "";
        try (PrintWriter out = response.getWriter()) {

            String graph = request.getParameter("graph"); // Get the selected value from the dropdown
            System.out.println("selected graph :" + graph);
  LocalDate currentDate = LocalDate.now();
  String formattedDate = currentDate.format(DateTimeFormatter.ofPattern("yyyy-MM")) + "%";
            if ("ABDM".equals(graph) || "PMJAY".equals(graph)) {
                depType = graph;
            }

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

            if ("admin".equals(userType)) {
                sql = "SELECT \n"
                        + "    t1.Username, \n"
                        + "    SUM(t1.Total) AS Total, \n"
                        + "    SUM(t1.Success) AS Success\n"
                        + "FROM sgc_billing t1\n"
                        + "JOIN (\n"
                        + "    SELECT DISTINCT accountname \n"
                        + "    FROM AccountDetails \n"
                        + "    WHERE department = '"+depType+"'\n"
                        + ") ad ON ad.accountname = t1.Username\n"
                        + "WHERE t1.date LIKE '"+formattedDate +"' \n"
                        + "GROUP BY t1.Username;";

                System.out.println("sql :" + sql);
            }

            ResultSet rs = db.getResult(sql);
            JSONArray jsonArray = new JSONArray();

            while (rs.next()) {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("Total", rs.getObject("Total") != null ? rs.getInt("Total") : 0);
                jsonObject.put("Success", rs.getObject("Success") != null ? rs.getInt("Success") : 0);
                jsonObject.put("username", rs.getObject("username") != null ? rs.getString("username") : 0);

                jsonArray.put(jsonObject);
            }

            String jsonResponse = jsonArray.toString();
            System.out.println("JSON Response: " + jsonResponse);
            out.print(jsonResponse);

        } catch (Exception e) {
            e.printStackTrace();
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

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
