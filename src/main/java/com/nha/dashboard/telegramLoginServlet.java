/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.nha.dashboard;

import db.dbcon;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;




/**
 *
 * @author Admin
 */
@MultipartConfig
public class telegramLoginServlet extends HttpServlet {


    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Login</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Login at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    static String generate_otp_method(int n) {

        String Num = "0123456789";
        StringBuilder sb = new StringBuilder(n);

        for (int i = 0; i < n; i++) {
            int index = (int) (Num.length() * Math.random());
            sb.append(Num.charAt(index));

        }
        return sb.toString();

    }

  
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        String Logchat_id = "N/A";
        String LogUsername = "N/A";
        String LogPassword = "N/A";
        String Generated_otp = "N/A";
        String email = "N/A";

        dbcon db = new dbcon();
        db.getCon("nha_cdr");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String OtpInpt = request.getParameter("OtpInpt");
        String otpType = request.getParameter("otpType");

        FileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        List items = null;
        try {
            items = upload.parseRequest(request);
        } catch (FileUploadException ex) {
            ex.printStackTrace();
        }
        Iterator itr = items.iterator();
        while (itr.hasNext()) {
            FileItem item = (FileItem) itr.next();
            if (item.isFormField()) {
                if (item.getFieldName().equalsIgnoreCase("username")) {
                    username = item.getString();
                }

                if (item.getFieldName().equalsIgnoreCase("password")) {
                    password = item.getString();
                }
                if (item.getFieldName().equalsIgnoreCase("OtpInpt")) {
                    OtpInpt = item.getString();
                }
                if (item.getFieldName().equalsIgnoreCase("otpType")) {
                    otpType = item.getString();
                }
            }

        }

        //    String Login_data = "select  name,pass from login where name='" + log + "' and pass='" + pass + "'"; and pswd=MD5(" + pass + ") 
        String Login_data = "select username ,password,chat_id,email from users where username ='" + username + "' and password='" + password + "'and status='true' ";
        System.out.println(Login_data);

        ResultSet rs = db.getResult(Login_data);

        try {
            if (rs.next()) {
                LogUsername = rs.getString("username");
                LogPassword = rs.getString("password");
                Logchat_id = rs.getString("chat_id");
                email = rs.getString("email");

            }
        } catch (SQLException ex) {
            Logger.getLogger(telegramLoginServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        db.closeConection();

        if (username != null && username.equals(LogUsername) && password != null) {

            HttpSession session = request.getSession(false);

            String Session_otp = (String) session.getAttribute("Session_otp");

            if (OtpInpt != null && OtpInpt.equals(Session_otp)) {
                if ((username.equals(LogUsername))) {
                    session.setAttribute("LogUsername", LogUsername);
                  out.println("Success");

                }

            } else if (OtpInpt != null && OtpInpt.equals("true")) {

                /*  Random rnd = new Random();
             int number = rnd.nextInt(999999);
           Session_otp = String.format("%06d", number);*/
                try {
                    Session_otp = generate_otp_method(6);
                    session.setAttribute("Session_otp", Session_otp);
                    String chk = "";
                    if (otpType != null && otpType.equals("telegram")) {
                        chk = sendTelegramMsg(Session_otp, Logchat_id);

                    } else if (otpType != null && otpType.equals("email")) {
                        chk = sendOtpMail(Session_otp, email);
                    }
                    out.println(chk);
                } catch (Exception e) {
                    out.println("Chat Not Found");

                }

            } else {
                out.println("Invalid OTP");
            }

        } else {
            out.println("Invalid User !!");
        }

    }

    public String getJSON(String url, int timeout) {
        HttpURLConnection c = null;
        try {
            URL u = new URL(url);
            c = (HttpURLConnection) u.openConnection();
            c.setRequestMethod("GET");
            c.setRequestProperty("Content-length", "0");
            c.setUseCaches(false);
            c.setAllowUserInteraction(false);
            c.setConnectTimeout(timeout);
            c.setReadTimeout(timeout);
            c.connect();
            int status = c.getResponseCode();

            switch (status) {
                case 200:
                case 201:
                    BufferedReader br = new BufferedReader(new InputStreamReader(c.getInputStream()));
                    StringBuilder sb = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null) {
                        sb.append(line + "\n");
                    }
                    br.close();
                    return sb.toString();
            }

        } catch (MalformedURLException ex) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (c != null) {
                try {
                    c.disconnect();
                } catch (Exception ex) {
                    Logger.getLogger(getClass().getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        return null;
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private String sendTelegramMsg(String Session_otp, String Logchat_id) {
        String returnmsg = "";
        String urlString = "https://api.telegram.org/bot%s/sendMessage?chat_id=%s&text=%s";
        String apiToken = "5845180710:AAEkSX551pLuai4undMCz9OYCfciymLDO-M";
        String chatId = Logchat_id;
        String text = "Your OTP is " + Session_otp + ".";
        urlString = String.format(urlString, apiToken, chatId, text);

        String resp = getJSON(urlString, 10000);
        if (resp.contains(":true")) {

            returnmsg = "OTP Sent !!!";
        } else {
            if (resp.contains("chat not found")) {

                returnmsg = "Chat Not Found";
            } else {

                returnmsg = "Unable to Send Message!!!";
            }
        }
        return returnmsg;
    }

    private String sendOtpMail(String Session_otp, String email) {

        String msg = "Your  Login Otp is:" + Session_otp;

        SendAttachmentMail sm = new SendAttachmentMail();
        boolean flag = sm.sendmail(email, "", "", "Otp", msg);
        if (flag) {
            return "OTP Sent !!!";
        } else {
            return "Unable to Send mail!!!";
        }
    }

}
