

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
        <%@include file="common_js_css_bootstrap/comman_js_css.jsp" %>
        <style>
            
           /* Body styling */
body {
    background: linear-gradient(135deg, #1e3c72, #2a5298); /* Gradient background */
    color: #fff; /* White text color */
    font-family: 'Arial', sans-serif; /* Professional font */
    margin: 0;
    padding: 0;
    height: 100vh; /* Full viewport height */
    display: flex;
    justify-content: center;
    align-items: center;
}

/* Container for the login box */


/* Login box styling */
.login-box {
    background: rgba(0, 0, 0, 0.7); /* Semi-transparent dark background */
    padding: 30px;
    border-radius: 10px; /* Rounded corners */
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.5); /* Subtle shadow */
    width: 100%;
    max-width: 500px; /* Limit maximum width */
    margin: 0 auto;
}

/* Login title styling */
.login-title {
    font-size: 24px;
    font-weight: bold;
    margin-bottom: 20px;
    text-transform: uppercase; /* Uppercase text */
    letter-spacing: 2px; /* Spacing between letters */
}

/* Form input styling */
.form-control {
    background: rgba(255, 255, 255, 0.1); /* Semi-transparent input background */
    border: none;
    border-radius: 5px;
    color: #fff; /* White text */
    padding: 10px;
    margin-bottom: 15px;
        font-size: 13px;
}

.form-control:focus {
    background: rgba(255, 255, 255, 0.2); /* Slightly lighter on focus */
    box-shadow: none;
    border: none;
    color: #fff;
}

/* Label styling */
.form-control-label {
    font-weight: bold;
    margin-bottom: 5px;
    font-size:12px;
}

/* Button styling */
.btn-outline-primary {
    border: 1px solid #ffffff;
    color: #ffffff;
    background: transparent;
    transition: all 0.3sease;
}

.btn-outline-primary:hover {
    background: #0a0a0a; /* Blue background on hover */
    color: #fff; /* White text on hover */
}

/* Loading spinner styling */
.buttonload {
    background: transparent;
    border: none;
    color: #fff;
    font-size: 14px;
}

/* OTP input styling */
#otp {
    margin-top: 10px;
}

/* Responsive design */
@media (max-width: 768px) {
    .login-box {
        padding: 20px;
    }

    .login-title {
        font-size: 20px;
    }
} 
input[type=text] {
    background-color: #1A2226;
    border: none;
    border-bottom: 0px solid #0DB8DE;
    border-top: 0px;
    border-radius: 0px;
    font-weight: bold;
    outline: 0;
    margin-bottom: 20px;
    padding-left: 10px;
    color: #ECF0F5;
    font-size: 14px;
    text-transform: capitalize;
}
input[type=password] {
    background-color: #1A2226;
    border: none;
    border-bottom: 0px solid #0DB8DE;
    border-top: 0px;
    border-radius: 0px;
    font-weight: bold;
    outline: 0;
    padding-left: 10px;
    margin-bottom: 20px;
    color: #ECF0F5;
}
.form-group {
    margin-bottom: 10px;
    outline: 0px;
}
 .btn {
    display: inline-block;
    font-weight: 400;
    text-align: center;
    white-space: nowrap;
    vertical-align: middle;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    border: 1px solid #fff;
    padding: .375rem .75rem;
    font-size: 12px;
    line-height: 1.5;
    border-radius: .25rem;
    transition: color .15sease-in-out, background-color .15sease-in-out, border-color .15sease-in-out, box-shadow .15sease-in-out;
    margin-right: 14px;
}   
.btn-outline-success:hover {
    color: #fff;
    background-color: #000000;
    border-color: #000000;
    border-radius: 0px;
}
button#submitBtn {
    background-color: #ffffff;
    color: #000;
    font-size: 15px;
    font-weight: bold;
    letter-spacing: 0px;
    text-transform: uppercase;
}
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!--<div class="col-lg-3 col-md-2"></div>-->
                <div class="col-lg-12 col-md-12 login-box mb-5">
                    
                    <div class="col-lg-12 login-title text-center mt-">
                        USER LOGIN
                    </div>
                    <center>
                        <div id="loader" style="display: none;">
                            <div class="loading d-flex justify-content-center" >
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                                <span></span>
                            </div>
                        </div>
                    </center>

                    <div id="test" style="color: white" class="mt-3">

                    </div>

                    <div class="col-lg-12 login-form">
                        <div class="col-lg-12 login-form">
                            <form enctype="multipart/form-data" method="post" action="telegramLoginServlet">
                                <div class="form-group">
                                    <label class="form-control-label text-white">USERNAME</label>
                                    <input type="text" class="form-control" name="username" id="username">
                                </div>
                                <div class="form-group">
                                    <label class="form-control-label text-white">PASSWORD</label>
                                    <input type="password" class="form-control" name="password" id="password">
                                </div>

                                <div class="row">


                                    <div class="col-lg-6">
                                        <div class="form-group btn-outline-warning"style="max-width: 150px;">
                                            <select class="form-control  btn-outline-success " id="otpType">
                                                <option   value="email">EMAIL</option>
                                                <option  value="telegram">TELEGRAM</option>
                                            </select> 
                                        </div>    
                                    </div> 

                                    <div class="col-lg-6 login-btm login-button">
                                        <button type="button" class="btn btn-outline-primary" name="sendOtp" id="sendOtp" onclick="OtpBtnClick()">Send Otp</button>
                                        <button class="buttonload" id="loading" style="display:none;" >
                                            <i class="fa fa-spinner fa-spin"></i>Please Wait...
                                        </button>
                                    </div>


                                </div>



                                <div class="form-group" id="otp" style="display: none">
                                    <label class="form-control-label text-white"  >Enter OTP</label>
                                    <input  type="text" class="form-control" name="OtpInpt" id="OtpInpt">
                                </div>


                        </div>


                        <div class="col-lg-12 loginbttm ml-5" id="submitt" style="display:none;">
                            <div class="col-lg-12 login-btm login-button form-group">
                                <button type="button" class="btn btn-outline-primary form-control" id="submitBtn" name="submitBtn" onclick="loginbtnClick()">Submit</button>
                            </div>
                        </div>


                        </form>
                    </div>
                </div>

            </div>
            
        </div> 
            
        <script src="jss/script.js" type="text/javascript"></script>     
    </body>
   
</html>
