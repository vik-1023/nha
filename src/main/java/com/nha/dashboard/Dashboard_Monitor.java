/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.nha.dashboard;

import db.dbcon;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

public class Dashboard_Monitor extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            dbcon db = new dbcon();
            JSONArray jsonArray = new JSONArray();
            String sql = "SELECT     SUM(t1.Total) AS Total,     SUM(t1.Success) AS Success,     SUM(t1.Failed) AS Failed FROM User_Counts_Api t1 JOIN (    SELECT date, MAX(last_updated) AS max_last_updated     FROM User_Counts_Api     WHERE date = CURDATE()     GROUP BY date) t2 ON t1.date = t2.date AND t1.last_updated = t2.max_last_updated WHERE t1.date = CURDATE();";

            db.getCon("nha_cdr");
            try (ResultSet rs = db.getResult(sql)) {
                if (rs == null) {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to retrieve data from the database.");
                    return;
                }

                while (rs.next()) {
                    JSONObject jsonObject = new JSONObject();
                    jsonObject.put("Total", rs.getObject("Total") != null ? rs.getInt("Total") : 0);
                    jsonObject.put("Success", rs.getObject("Success") != null ? rs.getInt("Success") : 0);
                    jsonObject.put("Failed", rs.getObject("Failed") != null ? rs.getInt("Failed") : 0);
                 

                    jsonArray.put(jsonObject);
                }

                out.print(jsonArray.toString());
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database query failed.");
            }
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
    }// </editor-fold>

}
