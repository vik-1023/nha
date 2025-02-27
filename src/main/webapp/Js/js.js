
// Your JSON object
var jsonData = {
    "contentMessage": {
        "templateMessage": {
            "templateCode": "template_123",
            "customParams": "{\"name:\":\"Vi\"}"
        }
    }
};

// Convert JSON to string and display in HTML
var jsonString = JSON.stringify(jsonData, null, 2);
document.getElementById('jsonContent').textContent = jsonString;


// Your JSON object
var jsonData = {
    "contentMessage": {
        "text": "Welcome to RCS chat!"
    }
};

// Convert JSON to string and display in HTML
var jsonString = JSON.stringify(jsonData, null, 2);
document.getElementById('jsonContent1').textContent = jsonString;


// Your JSON object
var jsonData = {
    "contentMessage": {
        "text": "Welcome to RCS chat!",
        "suggestions": [
            {
                "reply": {
                    "text": "what is RCS?",
                    "postbackData": "user_reply_what_is_rcs"
                }
            },
            {
                "action": {
                    "text": "visit our website",
                    "postbackData": "user_action_open_url",
                    "openUrlAction": {
                        "url": "https://vnsrbm.in/"
                    }
                }
            }
        ]
    }
};

// Convert JSON to string and display in HTML
var jsonString = JSON.stringify(jsonData, null, 2);
document.getElementById('jsonContent3').textContent = jsonString;

// Your JSON object
var jsonData = {
    "contentMessage": {
        "contentInfo": {
            "fileUrl": "https://storage.googleapis.com/kitchen-sink-sample-images/cute-dog.jpg"
        }
    }
};

// Convert JSON to string and display in HTML
var jsonString = JSON.stringify(jsonData, null, 2);
document.getElementById('jsonContent4').textContent = jsonString;

// Your JSON object
var jsonData = {
    "contentMessage": {
        "fileName": "VLXtA7s35cGmyq6g9TcqCSEn2Uqi9QLR"
    }
};

// Convert JSON to string and display in HTML
var jsonString = JSON.stringify(jsonData, null, 2);
document.getElementById('jsonContent5').textContent = jsonString;

// Your JSON object
var jsonData = {
    "contentMessage": {
        "richCard": {
            "standaloneCard": {
                "cardContent": {
                    "media": {
                        "contentInfo": {
                            "fileUrl": "https://storage.googleapis.com/kitchen-sink-sample-images/cute-dog.jpg",
                            "forceRefresh": false,
                            "thumbnailUrl": "https://storage.googleapis.com/kitchen-sink-sample-images/cute-dog.jpg"
                        },
                        "height": "MEDIUM"
                    },
                    "title": "Celebrity",
                    "suggestions": [
                        {
                            "reply": {
                                "text": "Like",
                                "postbackData": "user_like"
                            }
                        }
                    ]
                },
                "thumbnailImageAlignment": "LEFT",
                "cardOrientation": "VERTICAL"
            }
        },
        "suggestions": [
            {
                "reply": {
                    "text": "Know more",
                    "postbackData": "user_query"
                }
            }
        ]
    }
};

// Convert JSON to string and display in HTML
var jsonString = JSON.stringify(jsonData, null, 2);
document.getElementById('jsonContent6').textContent = jsonString;

// Your JSON object
var jsonData = {
    "contentMessage": {
        "richCard": {
            "carouselCard": {
                "cardWidth": "MEDIUM",
                "cardContents": [
                    {
                        "title": "This is the first rich card in a carousel.",
                        "description": "This is the description of the rich card.",
                        "media": {
                            "height": "SHORT",
                            "contentInfo": {
                                "fileUrl": "https://storage.googleapis.com/kitchen-sink-sample-images/cute-dog.jpg",
                                "forceRefresh": false
                            }
                        }
                    },
                    {
                        "title": "This is the second rich card in a carousel.",
                        "media": {
                            "height": "SHORT",
                            "contentInfo": {
                                "fileUrl": "https://www.google.com/logos/doodles/2015/googles-new-logo-5078286822539264.3-hp2x.gif",
                                "forceRefresh": false
                            }
                        }
                    }
                ]
            }
        }
    }
};

// Convert JSON to string and display in HTML
var jsonString = JSON.stringify(jsonData, null, 2);
document.getElementById('jsonContent7').textContent = jsonString;

function getMsg() {


    var username = document.getElementById("username").value;
    var password = document.getElementById("password").value;
    var grant_type = document.getElementById("grant_type").value;

    if (grant_type == null || grant_type == undefined || grant_type == "") {
        alert("Please enter grant_type ")
        return;
    }

    //                var  data = new FormData();
    //                data.append("username", username);
    //                data.append("password", password);


    document.getElementById("test").innerHTML = "Please wait ....";
    var url = "TokenServlet?grant_type=" + grant_type + "&username=" + username + "&password=" + password;
    var xhr = new XMLHttpRequest();

    xhr.open("get", url, true);
    //   xhr.setRequestHeader('Content-type', 'text/plain');

    xhr.onload = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            document.getElementById("test").innerHTML = this.responseText;
        }



    },
            xhr.send();
}

var jsonData = {
    "senderPhoneNumber": "PHONE_NUMBER",
    "messageId": "0a99d150-aae7-4247-aa07-a92cdaaf8ed3",
    "sendTime": "2018-12-31T15:01:23.045123456Z",
    "text": "Hello, world!"
};

// Convert JSON to string and display in HTML
var jsonString = JSON.stringify(jsonData, null, 2);
document.getElementById('json1').textContent = jsonString;

var jsonData = {

    "senderPhoneNumber": "+914253136789",
    "eventType": "IS_TYPING",
    "eventId": "47ace754-3191-4101-b494-658cfb314881"

};

// Convert JSON to string and display in HTML
var jsonString = JSON.stringify(jsonData, null, 2);
document.getElementById('json2').textContent = jsonString;

var jsonData = {

    "senderPhoneNumber": "+914253136789",
    "eventType": "DELIVERED",
    "eventId": "fa2fe5a2-d9a9-4d83-87d3-302ae1014610",
    "messageId": "57bed79e-55ba-46fe-b88a-2755aaee77fc"

};

// Convert JSON to string and display in HTML
var jsonString = JSON.stringify(jsonData, null, 2);
document.getElementById('json3').textContent = jsonString;

var jsonData = {

    "senderPhoneNumber": "+914253136789",
    "messageId": "4a1d7c74-2b3c-4ec7-b6be-ed7205a15aa3",
    "sendTime": "2018-12-31T15:01:23.045123456Z",
    "suggestionResponse": {
        "postbackData": "suggestion_1",
        "text": "Suggestion #1"
    }

};

// Convert JSON to string and display in HTML
var jsonString = JSON.stringify(jsonData, null, 2);
document.getElementById('json4').textContent = jsonString;

var jsonData = {

    "senderPhoneNumber": "+914253136789",
    "messageId": "beed5c85-970d-4661-8476-dbd5eb36bbef",
    "sendTime": "2018-12-31T15:01:23.045123456Z",
    "location": {
        "latitude": 37.422000,
        "longitude": -122.084056
    }

};

// Convert JSON to string and display in HTML
var jsonString = JSON.stringify(jsonData, null, 2);
document.getElementById('json5').textContent = jsonString;

var jsonData = {

    "senderPhoneNumber": "+914253136789",
    "messageId": "0650593d-c0d6-4db9-9723-dd47a584f219",
    "sendTime": "2018-12-31T15:01:23.045123456Z",
    "userFile": {
        "category": "IMAGE",
        "thumbnail": {
            "mimeType": "image/jpeg",
            "fileSizeBytes": 1280,
            "fileUri": "https://storage.googleapis.com/copper_test/77ddb795-24ad-4607-96ae-b08b4d86406a/d2dcc67ab888d34ee272899c020b13402856f81597228322079eb007e8c8",
            "fileName": "4_animated.jpeg"
        },
        "payload": {
            "mimeType": "image/gif",
            "fileSizeBytes": 127806,
            "fileUri": "https://storage.googleapis.com/copper_test/77ddb795-24ad-4607-96ae-b08b4d86406a/d2dcc67ab888d34ee272899c020b13402856f81597228322079eb007e8c9",
            "fileName": "4_animated.gif"
        }
    }

};

// Convert JSON to string and display in HTML
var jsonString = JSON.stringify(jsonData, null, 2);
document.getElementById('json6').textContent = jsonString;

var jsonData = {

    "subscription": "projects/rbm-stagingtestagent-ngu7dtz/subscriptions/rbm-agent-subscription",
    "message": {
        "data": "ewogICJzZW5kZXJQaG9uZU51bWJlciI6ICIrOTE5Njg2OTYwMjc2IiwKICAibWVzc2FnZUlkIjogIk14SWdULTRwV0NRdTJ0SDloTWtTVGxqUSIsCiAgInNlbmRUaW1lIjogIjIwMjItMTEtMTdUMDU6MTU6MTQuMzg0OTYzWiIsCiAgInRleHQiOiAiVGVzdCIsCiAgImFnZW50SWQiOiAic3RhZ2luZ3Rlc3RhZ2VudEByYm0uZ29vZyIKfQ==",
        "attributes": {
            "project_number": "129459109761",
            "product": "RBM",
            "message_type": "TEXT",
            "business_id": "stagingtestagent@rbm.goog",
            "type": "message"
        },
        "messageId": "6267774379637729",
        "publishTime": "2022-11-17T05:15:14.538Z"
    }

};

// Convert JSON to string and display in HTML
var jsonString = JSON.stringify(jsonData, null, 2);
document.getElementById('json7').textContent = jsonString;



function sendTryMsg() {
    var contactNumber = document.getElementById("contactNumber").value;
    var msgId = document.getElementById("msgId").value;
    var botId = document.getElementById("botId").value;
    var doCapCheck = document.getElementById("doCapCheck").value;
    var defaultTextarea = document.getElementById("defaultTextarea").value;

    if (contactNumber === "") {
        alert("Enter contact number");
        return;
    } else if (contactNumber !== null) {
        checkMobile();
    }
    if (botId === "") {
        alert("Enter botId");
        return;
    }



    document.getElementById("msgTest").innerHTML = "Please wait ....";

    var url = "textMessageServlet";
    var params = "contactNumber=" + contactNumber +
            "&msgId=" + msgId +
            "&botId=" + botId +
            "&doCapCheck=" + doCapCheck +
            "&defaultTextarea=" + encodeURIComponent(defaultTextarea);

    var xhr = new XMLHttpRequest();
    xhr.open("POST", url, true);
    xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

    xhr.onload = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            var json = this.responseText;
            console.log(json);
            if (json.includes("{")) {
                const obj = JSON.parse(json);

                if (obj.responseCode === 200) {
                    document.getElementById("msgTest").innerHTML = 'Response Status :' + obj.responseCode;
                    showReady();

                }
                if (obj.responseCode === 400) {
                    document.getElementById("msgTest").innerHTML = 'Response Status :' + obj.responseCode;
                    showInvalid();

                }

                if (obj.responseCode === 401) {
                    document.getElementById("msgTest").innerHTML = 'Response Status :' + obj.responseCode;
                    unauthorized();

                }

                if (obj.responseCode === 403) {
                    document.getElementById("msgTest").innerHTML = 'Response Status :' + obj.responseCode;
                    Invalid_Ip_Address();

                }

                if (obj.responseCode === 500) {
                    document.getElementById("msgTest").innerHTML = ' Response Status :' + obj.responseCode;
                    ServerError();

                }

            }
        }
    };

    xhr.send(params);




    function showReady() {
        // Basic usage of SweetAlert
        Swal.fire({
            title: 'VNS',
            text: 'The request of sending message is accepted by the  VNS Platform and ready to send to the user',
            icon: 'success', // 'success', 'error', 'warning', 'info', 'question'
            confirmButtonText: 'OK'
        });
    }

    function showInvalid() {

        Swal.fire({
            title: 'VNS',
            text: 'This is a bad request with invalid input, invalid object, etc.',
            icon: 'error', // 'success', 'error', 'warning', 'info', 'question'
            confirmButtonText: 'OK'
        });
    }

    function unauthorized() {

        Swal.fire({
            title: 'VNS',
            text: 'This request is unauthorized. cannot be found.',
            icon: 'error', // 'success', 'error', 'warning', 'info', 'question'
            confirmButtonText: 'OK'
        });
    }

    function Invalid_Ip_Address() {

        Swal.fire({
            title: 'VNS',
            text: 'Invalid client Id or Invalid IP address ',
            icon: 'error', // 'success', 'error', 'warning', 'info', 'question'
            confirmButtonText: 'OK'
        });
    }


    function ServerError() {

        Swal.fire({
            title: 'VNS',
            text: 'Server error.',
            icon: 'error', // 'success', 'error', 'warning', 'info', 'question'
            confirmButtonText: 'OK'
        });
    }


    function checkMobile() {

        Swal.fire({
            title: 'VNS',
            text: 'Are you Sure ' + contactNumber,
            icon: 'warning', // 'success', 'error', 'warning', 'info', 'question'
            confirmButtonText: 'OK'
        });
    }
}



function exeBtn() {

    document.getElementById("sch").style.display = "none";
    document.getElementById("defaultTextarea").style.display = "block";
    document.getElementById("textZone").style.display = "block";

}

function schBtn() {

    document.getElementById("sch").style.display = "block";
    document.getElementById("defaultTextarea").style.display = "none";
    document.getElementById("textZone").style.display = "none";


}


function toggleTextarea() {
    var selectElement = document.getElementById("example");
    var selectedOption = selectElement.value;

    if (selectedOption === "1") {
        document.getElementById("tempExample").style.display = "none";
        document.getElementById("msgExample").style.display = "block";
    } else if (selectedOption === "2") {
        document.getElementById("tempExample").style.display = "block";
        document.getElementById("msgExample").style.display = "none";
    }
}

function exe1() {
    document.getElementById("exe1").style.display = "block";
    document.getElementById("sch1").style.display = "none";
}

function sch1() {
    document.getElementById("sch1").style.display = "block";
    document.getElementById("exe1").style.display = "none";

}

function rStatus() {
    clearStatus();
    document.getElementById("resStatus").innerHTML = "The request of sending message is accepted by the VNS RBM Platform and ready to send to the user";
}

function resstatuss() {
    clearStatus();
    document.getElementById("resStatus").innerHTML = "This is a bad request with invalid input, invalid object, etc.";
}

function resstatusss() {
    clearStatus();
    document.getElementById("resStatus").innerHTML = "This request is unauthorized. cannot be found.";
}

function resstatusfzt() {
    clearStatus();
    document.getElementById("resStatus").innerHTML = "Invalid client Id or Invalid IP address";
}

function resstatusFive() {
    clearStatus();
    document.getElementById("resStatus").innerHTML = "Server error.";
}



function clearStatus() {
    document.getElementById("resStatus").innerHTML = "";
}

//==============================================================================================

function rStatusss() {
    clearStatus();
    document.getElementById("resStatuss").innerHTML = "The status of the message has been updated by the VI RBM Platform. For 'READ', a read notification will be sent to the user";
}

function resstatussss() {
    clearStatus();
    document.getElementById("resStatuss").innerHTML = "This is a bad request with invalid input, invalid object, etc.";
}

function resstatusssss() {
    clearStatus();
    document.getElementById("resStatuss").innerHTML = "This request is unauthorized. cannot be found.";
}

function resstatussssss() {
    clearStatus();
    document.getElementById("resStatuss").innerHTML = "Invalid client Id or Invalid IP address";
}

function resstatusssssss() {
    clearStatus();
    document.getElementById("resStatuss").innerHTML = "Server error.";
}



function clearStatuss() {
    document.getElementById("resStatuss").innerHTML = "";
}

//==============================================================================================

function revokeStatus1() {
    clearStatus();
    document.getElementById("revokeStatus").innerHTML = "VI RBM Platform shall try to revoke the message if it has not been delivered to the user.";
}

function revokeStatus2() {
    clearStatus();
    document.getElementById("revokeStatus").innerHTML = "This request is unauthorized.";
}

function revokeStatus3() {
    clearStatus();
    document.getElementById("revokeStatus").innerHTML = "The provided messageId cannot be found";
}

function revokeStatus4() {
    clearStatus();
    document.getElementById("revokeStatus").innerHTML = "Server error.";
}



function clearStatuss() {
    document.getElementById("revokeStatus").innerHTML = "";
}
//===============================================================================================



function fileStatus1() {
    clearStatus();
    document.getElementById("fileStatus").innerHTML = "The file upload request has been accepted. Record the fileId and chatbot can use it in media messages.";
}

function fileStatus2() {
    clearStatus();
    document.getElementById("fileStatus").innerHTML = "This is a bad request with invalid input, invalid object, etc.";
}

function fileStatus3() {
    clearStatus();
    document.getElementById("fileStatus").innerHTML = "This request is unauthorized. cannot be found.";
}

function fileStatus4() {
    clearStatus();
    document.getElementById("fileStatus").innerHTML = "Invalid client Id or Invalid IP address";
}

function fileStatus5() {
    clearStatus();
    document.getElementById("fileStatus").innerHTML = "Server error.";
}



function clearStatuss() {
    document.getElementById("fileStatus").innerHTML = "";
}


//====================================================================================================

function capabilityStatus1() {
    clearStatus();
    document.getElementById("capaStatusCode").innerHTML = "OK";
}

function capabilityStatus2() {
    clearStatus();
    document.getElementById("capaStatusCode").innerHTML = "The request is unauthorized.";
}

function capabilityStatus3() {
    clearStatus();
    document.getElementById("capaStatusCode").innerHTML = "Server error.";
}



function clearStatuss() {
    document.getElementById("capaStatusCode").innerHTML = "";
}





//=====================================================================================================

function bulkStatus1() {
    clearStatus();
    document.getElementById("bulkStatusRes").innerHTML = "OK";
}

function bulkStatus2() {
    clearStatus();
    document.getElementById("bulkStatusRes").innerHTML = "This is a bad request with invalid input, invalid object, etc";
}

function bulkStatus3() {
    clearStatus();
    document.getElementById("bulkStatusRes").innerHTML = "The request is unauthorized.";
}


function clearStatuss() {
    document.getElementById("bulkStatusRes").innerHTML = "";
}



//=======================================================================================================

function notificationRes1() {
    clearStatus();
    document.getElementById("notiRes").innerHTML = "Success";
}

function notificationRes2() {
    clearStatus();
    document.getElementById("notiRes").innerHTML = "This is a bad request with invalid input, invalid object, etc";
}

function notificationRes3() {
    clearStatus();
    document.getElementById("notiRes").innerHTML = "The request is unauthorized.";
}

function notificationRes4() {
    clearStatus();
    document.getElementById("notiRes").innerHTML = "server error.";


}


function clearStatuss() {
    document.getElementById("notiRes").innerHTML = "";
}

//=======================================================================================================

function tryApi() {
    document.getElementById("responseRow").style.display = "block";
    document.getElementById("clearResponse").style.display = "block";
    document.getElementById("responseCard").style.display = "block";


    var username = document.getElementById("username").value;
    var password = document.getElementById("password").value;
    var grant_type = document.getElementById("grant_type").value;

    document.getElementById("body_response").innerHTML = "Please wait ....";

    var url = "TokenServlet?grant_type=" + grant_type + "&username=" + username + "&password=" + password;
    var xhr = new XMLHttpRequest();

    xhr.open("GET", url, true);

    xhr.onload = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            var json = this.responseText;
            console.log(json);

            // Check if the response contains '{' to determine if it's a JSON object
            if (json.includes("{")) {
                const obj = JSON.parse(json);

                console.log(json);
                // Update the innerHTML with the response body
                document.getElementById("body_response").innerHTML = obj.body;

                document.getElementById("Response_header").innerHTML = "Cache-Control: " + obj['Cache-Control'];
                document.getElementById("Response_header").innerHTML += "<br>Content-Type: " + obj['Content-Type'];
                document.getElementById("Response_header").innerHTML += "<br>Pragma: " + obj.Pragma; // No need to use dot notation here

                // Update the innerHTML with the parsed JSON properties
                document.getElementById("body_response").innerHTML = obj.accessToken;

                //        document.getElementById("body_response").innerHTML += "<br>token_type: " + obj.token_type;
                //        document.getElementById("body_response").innerHTML += "<br>expires_in: " + obj.expires_in;
                //        document.getElementById("body_response").innerHTML += "<br>scope: " + obj.scope;
                //        document.getElementById("body_response").innerHTML += "<br>jti: " + obj.jti;




            } else {
                alert("No data access");
            }
        }
    };

    xhr.send();
    responseCurl();
}


function allClear() {


    document.getElementById("applied-key1").style.display = "none";
    document.getElementById("applied-key").style.display = "none";
    document.getElementById("remove-btn").style.display = "none";
    document.getElementById("updateBtn").style.display = "none";
    document.getElementById("naa").style.display = "none";
    document.getElementById("setBtn").style.display = "block";
    document.getElementById("remove-btn1").style.display = "none";
    document.getElementById("setUseUpdate").style.display = "none";
    document.getElementById("setUserPass").style.display = "block";
    document.getElementById("naa1").style.display = "block";
    document.getElementById("naa2").style.display = "block";
    document.getElementById("naa3").style.display = "none";

}

function clearGrantType() {
    var element = document.getElementById("grandType");
    element.reset();
}

function responseHeader() {
    document.getElementById("responseHeaderCard").style.display = "block";
    // document.getElementById("responseCurlCard").style.display = "none"; 
    document.getElementById("responseCard").style.display = "none";
}

function responseBtn() {
    document.getElementById("responseCard").style.display = "block";
    document.getElementById("responseHeaderCard").style.display = "none";
    // document.getElementById("responseCurlCard").style.display = "none";

}

function clrResponse() {

    document.getElementById("clearResponse").style.display = "none";
    document.getElementById("responseRow").style.display = "none";
}

function RemoveBtn1() {

    document.getElementById("clear-btn").style.display = "none";
    document.getElementById("applied-key1").style.display = "none";
    document.getElementById("applied-key").style.display = "none";
    document.getElementById("naa").style.display = "none";
    document.getElementById("remove-btn1").style.display = "none";
    document.getElementById("setUseUpdate").style.display = "none";
    document.getElementById("setUserPass").style.display = "block";
    document.getElementById("naa1").style.display = "none";
    document.getElementById("naa2").style.display = "block";
    document.getElementById("naa3").style.display = "none";
}


function setUserPasss() {
    var naa = document.getElementById("naa");

    var username = document.getElementById("username").value;
    var password = document.getElementById("password").value;
    if (username == null || username == undefined || username == "") {
        alert("Please enter client_id  ");
        return;
    }
    if (password == null || password == undefined || password == "") {
        alert("Please enter client_secret  ");
        return;
    }



    document.getElementById("applied-key1").style.display = "block";
    document.getElementById("remove-btn1").style.display = "block";
    document.getElementById("applied-key1").innerHTML = '<span style="color:#47afe8;">key applied</span>';
    naa.innerHTML = '<span style="color:#47afe8;">1 API key applied</span>';
    document.getElementById("clear-btn").style.display = "block";
    document.getElementById("setUseUpdate").style.display = "block";
    document.getElementById("setUserPass").style.display = "none";
    document.getElementById("naa").style.display = "block";
    document.getElementById("naa2").style.display = "none";
    document.getElementById("naa3").style.display = "block";



}

function RemoveBtn() {

    document.getElementById("applied-key").style.display = "none";
    document.getElementById("clear-btn").style.display = "none";
    document.getElementById("naa").style.display = "none";
    document.getElementById("naa1").style.display = "block";
    document.getElementById("remove-btn").style.display = "none";
    document.getElementById("updateBtn").style.display = "none";
    document.getElementById("setBtn").style.display = "block";
}


function SetToken() {
    var api_token = document.getElementById("api_token").value;
    var naa = document.getElementById("naa");


    if (api_token === "") {
        alert("Please set token");
        return;
    }

    if (api_token.trim().length > 0) {
        naa.innerHTML = '<span style="color:#47afe8;">1 API key applied</span>';
        document.getElementById("remove-btn").style.display = "block";
        document.getElementById("naa").style.display = "block";
        document.getElementById("applied-key").style.display = "block";
        document.getElementById("applied-key").innerHTML = '<span style="color:#47afe8;">key applied</span>';
        document.getElementById("clear-btn").style.display = "block";
        document.getElementById("updateBtn").style.display = "block";
        document.getElementById("setBtn").style.display = "none";

    }
}

function sch2() {
    document.getElementById("ex").style.display = "none";
    document.getElementById("sc").style.display = "block";
}
function exe2() {
    document.getElementById("ex").style.display = "block";
    document.getElementById("sc").style.display = "none";
}

function messageSts() {
    var contactStatusId = document.getElementById("contactStatusId").value;
    var StatusbotId = document.getElementById("StatusbotId").value;
    var messageStatusId = document.getElementById("messageStatusId").value;
    document.getElementById("responseStatusCard").style.display = "block";

    document.getElementById("responseStatus").innerHTML = "Please wait ....";

    var url = "messageStatusServlet?contactStatusId=" + contactStatusId + "&StatusbotId=" + StatusbotId + "&messageStatusId=" + messageStatusId;
    var xhr = new XMLHttpRequest();

    xhr.open("GET", url, true);

    xhr.onload = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            var json = this.responseText;
            console.log(json); // Log the JSON string

            // Check if the response contains '{' to determine if it's a JSON object
            if (json.includes("{")) {
                const obj = JSON.parse(json);

                console.log(obj); // Log the JSON object


                // Stringify the JSON object
                var jsonString = JSON.stringify(obj, null, 2);

                // Update the innerHTML of the responseStatus div with the stringified JSON
                document.getElementById("responseStatus").innerHTML = "<pre>" + jsonString + "</pre>";

                // Display the appropriate property of the response object
                document.getElementById("accessStatus").innerHTML = "Access Status: " + obj.accessStatus;
            } else {
                alert("No data access");
                document.getElementById("responseStatusCard").style.display = "block";
            }
        }
    };

    xhr.send();
}


function tryTester() {
    var testerContactId = document.getElementById("testerContactId").value;
    var testerBotId = document.getElementById("testerBotId").value;

    document.getElementById("testerInvite").style.display = "block";

    document.getElementById("inviteTesterr").innerHTML = "Please wait ....";

    var url = "testerServlet?testerContactId=" + testerContactId + "&testerBotId=" + testerBotId;
    var xhr = new XMLHttpRequest();

    xhr.open("GET", url, true);

    xhr.onload = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            var json = this.responseText;
            console.log(json); // Log the JSON string

            // Check if the response contains '{' to determine if it's a JSON object
            if (json.includes("{")) {
                const obj = JSON.parse(json);

                console.log(obj); // Log the JSON object


                // Stringify the JSON object
                var jsonString = JSON.stringify(obj, null, 2);

                // Update the innerHTML of the inviteTester div with the stringified JSON
                document.getElementById("inviteTesterr").innerHTML = "<pre>" + jsonString + "</pre>";

                // Display the appropriate property of the response object

            } else {
                alert("No data access");
                document.getElementById("testerInvite").style.display = "none";
            }
        }
    };

    xhr.send();
}

function capabilitiesTry() {
    var capabilitiesContact = document.getElementById("capabilitiesContact").value;
    var capabilitiesbotId = document.getElementById("capabilitiesbotId").value;
    document.getElementById("capabilitiesCheckStatus").style.display = "block";

    document.getElementById("capabilitiesCheck").innerHTML = "Please wait ....";

    var url = "capabilitiesServlet?capabilitiesContact=" + capabilitiesContact + "&capabilitiesbotId=" + capabilitiesbotId;
    var xhr = new XMLHttpRequest();

    xhr.open("GET", url, true);

    xhr.onload = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            var json = this.responseText;
            console.log(json); // Log the JSON string

            // Check if the response contains '{' to determine if it's a JSON object
            if (json.includes("{")) {
                const obj = JSON.parse(json);

                console.log(obj); // Log the JSON object


                // Stringify the JSON object
                var jsonString = JSON.stringify(obj, null, 2);

                // Update the innerHTML of the inviteTester div with the stringified JSON
                document.getElementById("capabilitiesCheck").innerHTML = "<pre>" + jsonString + "</pre>";

                // Display the appropriate property of the response object

            } else {
                alert("No data access");
                document.getElementById("capabilitiesCheckStatus").style.display = "none";
            }
        }
    };

    xhr.send();

}


function fileEx() {
    document.getElementById("fileExample").style.display = "block";
    document.getElementById("fileSchema").style.display = "none";
}
function fileSch() {
    document.getElementById("fileSchema").style.display = "block";
    document.getElementById("fileExample").style.display = "none";
}


function fileSendTry() {
    document.getElementById("fileSendTryId").style.display = "block";

    document.getElementById("UploadFile").innerHTML = "Please wait ....";
    var filebotId = document.getElementById("filebotId").value;
    var formData = new FormData();
    formData.append('botId', filebotId)// Create FormData object from form

    if (document.querySelector("#customFile").files.length == 0) {
        alert("Please Choose a File!!!");
        return;
    }

    formData.append('file', document.querySelector("#customFile").files[0])

    // Send formData using Ajax
    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'fileUploadServlet'); // Specify the URL to your servlet
    xhr.onload = function () {

        if (xhr.status === 200) {
            var json = this.responseText;
            console.log(json);


            if (json.includes("{")) {
                const obj = JSON.parse(json);

                console.log(obj); // Log the JSON object


                // Stringify the JSON object
                var jsonString = JSON.stringify(obj, null, 2);

                // Update the innerHTML of the inviteTester div with the stringified JSON
                document.getElementById("UploadFile").innerHTML = "<pre>" + jsonString + "</pre>";

                // Display the appropriate property of the response object

            } else {
                alert("No data access");
                document.getElementById("fileSendTryId").style.display = "none";
            }

        }


    };
    xhr.send(formData);


}



function capSch() {

    document.getElementById("schemaCap").style.display = "block";
    document.getElementById("exeCap").style.display = "none";

}

function capExe() {
    document.getElementById("exeCap").style.display = "block";
    document.getElementById("schemaCap").style.display = "none";

}

function  testerExample() {

    document.getElementById("testExample").style.display = "block";
    document.getElementById("testSch").style.display = "none";

}
function  schemaExample() {
    document.getElementById("testSch").style.display = "block";
    document.getElementById("testExample").style.display = "none";
}


function  bulkExe() {

    document.getElementById("ExeBulk").style.display = "block";
    document.getElementById("schBulk").style.display = "none";

}
function  bulkSch() {
    document.getElementById("schBulk").style.display = "block";
    document.getElementById("ExeBulk").style.display = "none";
}


function notificationex() {

    document.getElementById("nex").style.display = "block";
    document.getElementById("nch").style.display = "none";

}

function notificationsc() {
    document.getElementById("nch").style.display = "block";
    document.getElementById("nex").style.display = "none";
}

function notificationex1() {

    document.getElementById("nex1").style.display = "block";
    document.getElementById("nch1").style.display = "none";

}

function notificationsc1() {
    document.getElementById("nch1").style.display = "block";
    document.getElementById("nex1").style.display = "none";
}


//function BulkcapTry() {
//    var bulktextarea = document.getElementById("bulktextarea").value;
//    var bulktestbotId = document.getElementById("bulktestbotId").value;
//    alert("bulktextarea " + bulktextarea);
//    alert("bulktestbotId " + bulktestbotId);
//
//
//    document.getElementById("bulkcapRes").innerHTML = "Please wait ....";
//
//    var url = "BulkCapabilityServlet?bulktextarea=" + bulktextarea + "&bulktestbotId=" + bulktestbotId;
//    var xhr = new XMLHttpRequest();
//
//    xhr.open("GET", url, true);
//
//    xhr.onload = function () {
//        if (xhr.readyState === 4 && xhr.status === 200) {
//            var json = this.responseText;
//            console.log(json); // Log the JSON string
//
//            // Check if the response contains '{' to determine if it's a JSON object
//            if (json.includes("{")) {
//                const obj = JSON.parse(json);
//
//                console.log(obj); // Log the JSON object
//
//
//                // Stringify the JSON object
//                var jsonString = JSON.stringify(obj, null, 2);
//
//                // Update the innerHTML of the inviteTester div with the stringified JSON
//                document.getElementById("bulkcapRes").innerHTML = "<pre>" + jsonString + "</pre>";
//
//                // Display the appropriate property of the response object
//
//            } else {
//                alert("No data access");
//
//            }
//        }
//    };
//
//    xhr.send();
//
//}




function BulkcapTry() {
   

    document.getElementById("bulkcapRes").innerHTML = "Please wait ....";
     var bulktextarea = document.getElementById("bulktextarea").value;
    var bulktestbotId = document.getElementById("bulktestbotId").value;
    
    alert(bulktextarea);
    alert(bulktestbotId);
    var formData = new FormData();
    formData.append('bulktestbotId', bulktestbotId);
    formData.append('bulktextarea', bulktextarea); 

    // Send formData using Ajax
    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'BulkCapabilityServlet'); // Specify the URL to your servlet
    xhr.onload = function () {

        if (xhr.status === 200) {
            var json = this.responseText;
            console.log(json);


            if (json.includes("{")) {
                const obj = JSON.parse(json);

                console.log(obj); // Log the JSON object


                // Stringify the JSON object
                var jsonString = JSON.stringify(obj, null, 2);

                // Update the innerHTML of the inviteTester div with the stringified JSON
                document.getElementById("bulkcapRes").innerHTML = "<pre>" + jsonString + "</pre>";

                // Display the appropriate property of the response object

            } else {
                alert("No data access");
                document.getElementById("bulkcapRes").style.display = "none";
            }

        }


    };
    xhr.send(formData);


}


