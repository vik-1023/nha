

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
}

/* Button styling */
.btn-outline-primary {
    border: 2px solid #007bff; /* Blue border */
    color: #007bff; /* Blue text */
    background: transparent;
    transition: all 0.3s ease;
}

.btn-outline-primary:hover {
    background: #007bff; /* Blue background on hover */
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
            
            
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <div class="col-lg-3 col-md-2"></div>
                <div class="col-lg-6 col-md-8 login-box mb-5">
                    <div class="col-lg-12 login-key">
                        <i class="fa fa-key" aria-hidden="true"></i>
                    </div>
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
