/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.nha.dashboard;

import com.sun.mail.smtp.SMTPSendFailedException;
import java.io.File;
import java.text.ParseException;
import java.util.Properties;
import javax.activation.CommandMap;
import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.activation.MailcapCommandMap;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

/**
 *
 * @author Admin
 */
public class SendAttachmentMail {

    //String host = "";
    String host = "smtp.gmail.com";
    //String host2 = "smtp.mail.yahoo.com";
    final static String user = "sms.reports.24@gmail.com";//change accordingly    
    final static String password = "jymlbvjaglvdmdvt";

    //final static String to = "vikram@virtuosonetsoft.in";//change accordingly  
    final static String to = "parwinder@virtuosonetsoft.in";
    //final static String to = "himanshu.suryavanshi@virtuosonetsoft.in";
    final static String cc = "";
    final static String bcc = "";
    static String subject = "";
    static String description = "";

    static String filename = "";

    public static void main(String[] args) throws ParseException {

        SendAttachmentMail st = new SendAttachmentMail();

        st.sendmail(to, cc, bcc, subject, description);
        //  }

    }

    public boolean sendmail(String to, String Cc, String Bcc, String sub, String msg) {
        boolean b = false;

        //Get the session object 
        String filename = "";
        String files[] = filename.split(",");
        for (int i = 0; i < files.length; i++) {

            System.out.println(filename + "  <<<<< \n Filename " + i + " >>> " + files[i]);
        }

        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        MailcapCommandMap mc = (MailcapCommandMap) CommandMap.getDefaultCommandMap();
        mc.addMailcap("text/html;; x-java-content-handler=com.sun.mail.handlers.text_html");
        mc.addMailcap("text/xml;; x-java-content-handler=com.sun.mail.handlers.text_xml");
        mc.addMailcap("text/plain;; x-java-content-handler=com.sun.mail.handlers.text_plain");
        mc.addMailcap("multipart/*;; x-java-content-handler=com.sun.mail.handlers.multipart_mixed");
        mc.addMailcap("message/rfc822;; x-java-content-handler=com.sun.mail.handlers.message_rfc822");
        CommandMap.setDefaultCommandMap(mc);
        Thread.currentThread().setContextClassLoader(getClass().getClassLoader());

        Session session = Session.getDefaultInstance(props,
                new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, password);
            }
        });

        //Compose the message  
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(user));
            // message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));

            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));

            if (!(Cc == "" || Cc == null)) {
                message.setRecipients(Message.RecipientType.CC, InternetAddress.parse(Cc));
                // message.addRecipient(Message.RecipientType.CC, new InternetAddress(Cc)); 
            }
            if (!(Bcc == "" || Bcc == null)) {
                message.setRecipients(Message.RecipientType.BCC, InternetAddress.parse(Bcc));
                //  message.addRecipient(Message.RecipientType.BCC, new InternetAddress(Bcc)); 
            }

            if (filename.isEmpty()) {
                message.setText(msg);
                message.setContent(msg, "text/html; charset=utf-8");
                System.out.println("TEXT MESSAGE");
            } else {
                System.out.println("ATTACHMENT MESSAGE");
                BodyPart messageBodyPart = new MimeBodyPart();

                messageBodyPart.setContent(msg, "text/html; charset=utf-8");

                Multipart multipart = new MimeMultipart();
                multipart.addBodyPart(messageBodyPart);

                for (int i = 0; i < files.length; i++) {
                    addAttachment(multipart, files[i]);
                }
                message.setContent(multipart);

            }

            message.setSubject(sub);

            try {
                Transport.send(message);
            } catch (SMTPSendFailedException e) {

            }

            System.out.println("Message sent successfully...");
            b = true;

        } catch (MessagingException e) {
            e.printStackTrace();
            b = false;
        }
        return b;
    }

    public boolean sendmail(String to, String Cc, String Bcc, String sub, String msg, String filename) {
        boolean b = false;

        //Get the session object  
        String files[] = filename.split(",");
        for (int i = 0; i < files.length; i++) {

            System.out.println(filename + "  <<<<< \n Filename " + i + " >>> " + files[i]);
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); // Required for port 587
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.connectiontimeout", "30000"); // Connection timeout
        props.put("mail.smtp.timeout", "30000"); // Timeout

        if (!(filename.equals(""))) {
            MailcapCommandMap mc = (MailcapCommandMap) CommandMap.getDefaultCommandMap();
            mc.addMailcap("text/html;; x-java-content-handler=com.sun.mail.handlers.text_html");
            mc.addMailcap("text/xml;; x-java-content-handler=com.sun.mail.handlers.text_xml");
            mc.addMailcap("text/plain;; x-java-content-handler=com.sun.mail.handlers.text_plain");
            mc.addMailcap("multipart/*;; x-java-content-handler=com.sun.mail.handlers.multipart_mixed");
            mc.addMailcap("message/rfc822;; x-java-content-handler=com.sun.mail.handlers.message_rfc822");
            CommandMap.setDefaultCommandMap(mc);
            Thread.currentThread().setContextClassLoader(getClass().getClassLoader());
        }

        Session session = Session.getDefaultInstance(props,
                new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, password);
            }
        });

        //Compose the message  
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(user));
            // message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));

            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));

            if (!(Cc == "" || Cc == null)) {
                message.setRecipients(Message.RecipientType.CC, InternetAddress.parse(Cc));
                // message.addRecipient(Message.RecipientType.CC, new InternetAddress(Cc)); 
            }
            if (!(Bcc == "" || Bcc == null)) {
                message.setRecipients(Message.RecipientType.BCC, InternetAddress.parse(Bcc));
                //  message.addRecipient(Message.RecipientType.BCC, new InternetAddress(Bcc)); 
            }

            if (filename.isEmpty()) {
                message.setText(msg);
                System.out.println("TEXT MESSAGE");
            } else {
                System.out.println("ATTACHMENT MESSAGE");
                BodyPart messageBodyPart = new MimeBodyPart();

                messageBodyPart.setContent(msg, "text/html; charset=utf-8");

                Multipart multipart = new MimeMultipart();
                multipart.addBodyPart(messageBodyPart);

                for (int i = 0; i < files.length; i++) {
                    addAttachment(multipart, files[i]);
                }
                message.setContent(multipart);

            }

            message.setSubject(sub);

            try {
                Transport.send(message);
            } catch (SMTPSendFailedException e) {

            }

            System.out.println("Message sent successfully...");
            b = true;

        } catch (MessagingException e) {
            e.printStackTrace();
            b = false;
        }
        return b;
    }

    private static void addAttachment(Multipart multipart, String filename) throws MessagingException {
        DataSource source = new FileDataSource(filename);

        MimeBodyPart messageBodyPart = new MimeBodyPart();
        messageBodyPart.setDataHandler(new DataHandler(source));
        messageBodyPart.setFileName(filename.substring(filename.lastIndexOf(File.separator) + 1));
        multipart.addBodyPart(messageBodyPart);
    }
}