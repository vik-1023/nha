function GETOTP() {
         var Result=document.getElementById("result");
    var Username = document.getElementById("exampleInputEmail1").value;

    var Pass = document.getElementById("exampleInputPassword1").value;
    var OTP_DROPDOWN=document.getElementById("OTP_DROPDOWN").value;
    var OTP_VAL = "false";





    var url = "LoginD1?Username=" + Username + "&Pass=" + Pass + "&OTP_VAL=" + OTP_VAL+ "&OTP_DROPDOWN=" + OTP_DROPDOWN;

    var xhr = new XMLHttpRequest();
    document.getElementById("result").innerHTML = "<div class='loader'></div>";
    xhr.onreadystatechange = function () {
        try {
            if (xhr.readyState === 4 && xhr.status === 200) {
                var resp = xhr.responseText;

                    console.log(" reso "+ resp );

                if (resp.startsWith("sent")) {
                   
                   var Sent_Resp=resp.replace('sent','');
                    // alert("OTP Sent Check Your Email !!")
                    document.getElementById("result").innerHTML = "<div style='color:green;'>"+Sent_Resp+"</div>";
                     document.getElementById("OTPTYPE").style.display = "none";
                    document.getElementById("exampleInputEmail1").readOnly = true;
                    document.getElementById("exampleInputPassword1").readOnly = true;
                    document.getElementById("otpDiv").style.display = "block";
                    document.getElementById("OTPDiv").style.display = "none";
                    document.getElementById("LoginBtn").style.display = "block";
                     
                    //  document.getElementById("result").innerHTML=""; 

                }else if(resp.startsWith("InvalidNum")){
                      Result.innerHTML = "<div ></div>";
                    alert("Mobile Number Is Not Linked With This Account !! ");
                     location.reload();
                }
                else if(resp.startsWith("otpIsOn")){
                      document.getElementById("OTPTYPE").style.display = "block";
                       Result.innerHTML = "<div ></div>";
                }
                else if(resp.startsWith("Disable:")){
                    var otp_disabled=resp.trim().replace("Disable:","");
                    console.log("otp_disabled"+otp_disabled);
                    
                    document.getElementById("OTP_VAL").value=otp_disabled;
                    Login_btn();
                    
                }else if(resp.startsWith("OtpSendError")){
                    
                   alert(resp.replace('OtpSendError',''));
                   Result.innerHTML = "<div ></div>";
                     location.reload();
                }else if(resp.startsWith("Under Verification ")){
                    Result.innerHTML = "<div style='color:red;'>Account Is Disabled</div>";
                }
                else if(resp.startsWith("ExipedAccount")){
                    Result.innerHTML = "<div style='color:red;'>Account Is Expired</div>";
                }
                 
                
                else {
                    alert("Error  Please Check Your Email & Password again !!")

                    location.reload();


                }
            } else if (xhr.readyState === 4 && xhr.status !== 200) {
                console.error("Failed to load. Status:", xhr.status);

            }
        } catch (error) {
            console.error("Error:", error);

        }
    };
//        document.getElementById("OTP").style.display = "none";;wait
//            document.getElementById("wait").style.display = "inline";

    xhr.open("GET", url, true);
    xhr.send();
}

function SIGNUP() {


    var Username = document.getElementById("Email").value;
    var Pass = document.getElementById("exampleInputPassword1").value;
    var CPass = document.getElementById("exampleInputPassword2").value;
    var OTP_VAL = document.getElementById("OTP_VAL").value;






    var url = "SighupD1?Username=" + Username + "&Pass=" + Pass + "&OTP_VAL=" + OTP_VAL;

    var xhr = new XMLHttpRequest();

    xhr.onreadystatechange = function () {
        try {
            if (xhr.readyState === 4 && xhr.status === 200) {
                var resp = xhr.responseText;
                // alert(resp+"resp");

                if (resp.startsWith("Rows")) {

                    alert("Your Account Under Verification !!");
                    window.location.href = "Login.jsp";

                } else if (resp.startsWith("Wrong")) {
                    document.getElementById("OTP_VAL").value = "";
                    alert("Wrong_OTP");


                } else {
                    alert("Unable to enter Data");

                }
            } else if (xhr.readyState === 4 && xhr.status !== 200) {
                console.error("Failed to load. Status:", xhr.status);

            }
        } catch (error) {
            console.error("Error:", error);

        }
    };

    xhr.open("GET", url, true);
    xhr.send();
}
// Login 
function Login_btn() {

    var Username = document.getElementById("exampleInputEmail1").value;
    var OTP_VAL = document.getElementById("OTP_VAL").value;
    var Pass = document.getElementById("exampleInputPassword1").value;

    document.getElementById("result").innerHTML = "<div class='loader'></div>";
    var url = "LoginD1?Username=" + Username + "&Pass=" + Pass + "&OTP_VAL=" + OTP_VAL;

    var xhr = new XMLHttpRequest();

    xhr.onreadystatechange = function () {
        try {
            if (xhr.readyState === 4 && xhr.status === 200) {
                var resp = xhr.responseText;


                if (resp.startsWith("Correct")) {

                    window.location.href = "dashboard";

                } else if (resp.startsWith("NoAccount")) {
                    alert("This account is not verified");
                    document.getElementById("result").innerHTML = "<div style='color:red;'>This Account is not verified!!!</div>";


                } else if (resp.includes("Invalid Username or Password!!!")) {
                    document.getElementById("result").innerHTML = resp;
                } else if (resp.includes("Wrong OTP")) {
                    document.getElementById("result").innerHTML = resp;
                } else {
                    document.getElementById("result").innerHTML = "<div style='color:red;'>Your Account Is Still Under Verification Process !!</div>";
                    // alert("Your Account Is Still Under Verification Process !!");

                }
            } else if (xhr.readyState === 4 && xhr.status !== 200) {
                console.error("Failed to load. Status:", xhr.status);

            }
        } catch (error) {
            console.error("Error:", error);

        }
    };

    xhr.open("GET", url, true);
    xhr.send();
}


 








document.addEventListener("keypress", function (event) {

    var OTPDiv = document.getElementById("OTPDiv");
    var LoginBtn = document.getElementById("LoginBtn");
    if (window.getComputedStyle(LoginBtn).display === "none") {
        if (event.keyCode === 13) {
            event.preventDefault(); // Prevent form submission
            GETOTP();

        }


    }
    if (window.getComputedStyle(OTPDiv).display === "none") {
        if (event.keyCode === 13) {
            event.preventDefault(); // Prevent form submission
            Login_btn();

        }


    }


});




