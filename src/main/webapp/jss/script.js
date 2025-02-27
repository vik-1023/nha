     function  OtpBtnClick() {
                const username = document.getElementById("username").value;
                const password = document.getElementById("password").value;
                const otpType = document.getElementById("otpType").value;
                const otp = document.getElementById("otp").value;
                document.getElementById("loader").style.display = 'block';
                var data = new FormData();
                data.append('username', username);
                data.append('password', password);
                data.append('OtpInpt', 'true');
                data.append('otpType', otpType);
                const url = "telegramLoginServlet";
                var A = new XMLHttpRequest();
                A.onreadystatechange = function () {
                    if ((username != null) && this.readyState == 4 && this.status == 200) {
                        var resp = A.responseText;
                        const div = document.getElementById("test");
                        if (resp.startsWith("OTP Sent")) {

                            //  alert("OTP Sent");

                            div.textContent = resp;
                            document.getElementById("loader").style.display = 'none';


                            document.getElementById("OtpInpt").textContent = "inline";
                            document.getElementById("sendOtp").textContent = "Resend Otp";
                            document.getElementById("otp").style.display = 'inline';
                            document.getElementById("submitt").style.display = 'inline';
                            document.getElementById("password").style.display = "inline";
                            document.getElementById("submitBtn").style.display = "inline";
                            document.getElementById("username").readOnly = true;
                            document.getElementById("loading").style.display = "none";
                            document.getElementById("sendOtp").style.display = "inline";


                        } else {
                            document.getElementById("username").readOnly = false;
                            document.getElementById("sendOtp").style.display = "inline";
                            div.textContent = resp;
                            document.getElementById("otp").style.display = 'none';
                            document.getElementById("submitt").style.display = 'none';


                        }




                    }


                };
                A.open("POST", url, true);
                A.send(data);
            }




            /*-------------------------- Login telegramLogin and EmailLogin-----------------------------------*/



//login Button
            function  loginbtnClick() {
                const username = document.getElementById("username").value;
                const OtpInpt = document.getElementById("OtpInpt").value;
                const password = document.getElementById("password").value;
                var data = new FormData();
                data.append('username', username);
                data.append('password', password);
                data.append('OtpInpt', OtpInpt);

                const url = "telegramLoginServlet";
                const A = new XMLHttpRequest();
                A.onreadystatechange = function () {
                    if (this.readyState == 4 && this.status == 200) {
                        var resp = A.responseText;
                        const div = document.getElementById("test");
                        if (resp.startsWith("Success")) {

                            div.textContent = "Success";


                            window.location.replace("Dashboard");
                        } else {
                            alert("invalid otp");
                            div.textContent = resp;
                            document.getElementById("submitBtn").style.display = "inline";

                        }

                    } else {


                        document.getElementById("submitBtn").style.display = "none";
                    }
                };

                A.open("POST", url, true);

                A.send(data);


            }
        



/*-------------------------- UserBilling data to Excel-----------------------------------*/

//function ExportToExcel(type, fn, dl) {
//    var elt = document.getElementById('test');
//    var wb = XLSX.utils.table_to_book(elt, {sheet: "sheet1"});
//    return dl ?
//            XLSX.write(wb, {bookType: type, bookSST: true, type: 'base64'}) :
//            XLSX.writeFile(wb, fn || ('MySheetName.' + (type || 'xlsx')));
//
//
//}



/*-------------------------- send telegramLogin and EmailLogin OTP-----------------------------------*/




/*---------------------------------------------------------------- - End-------------------------------------------------------------- -*/

// get otion value

