  const myTimeout = setInterval(recMsg_D, 1000);

 function Test(){
const now = new Date();
const formattedTime = now.toLocaleString();

alert(formattedTime);
 }



// on load 

window.onload = function() {
    // Your function to run when the page is loaded or reloaded
    loadChat();
};
 
function recMsg_D() {
   
const now = new Date();
const formattedTime = now.toLocaleString();
    var url = "ChatPBck";

    var xhr = new XMLHttpRequest();

    xhr.onreadystatechange = function () {
        try {
            if (xhr.readyState === 4 && xhr.status === 200) {

                var resp = xhr.responseText;


                  console.error("Sent",resp);
                if (resp.startsWith("Sent")) {
                    
                    
                    var jsonStr = resp.substring("Sent".length);

                    var responseData = JSON.parse(jsonStr);
                    var User = responseData.User;
                    var Msg = responseData.Msg;
                    var Time = responseData.Time;


                    recPRint(Msg, User,Time);



                } else if (resp.startsWith("alreadySentMessage")) {
                    
                    

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
// sending into db

function Send_DB() {
    var messageInput = document.getElementById("messageInput");
    var message = messageInput.value;
    const now = new Date();
const Time = now.toLocaleString();
var User = "ChatBot";

 


    var url = "inserDB?message=" + message;

    var xhr = new XMLHttpRequest();

    xhr.onreadystatechange = function () {
        try {
            if (xhr.readyState === 4 && xhr.status === 200) {

                var resp = xhr.responseText;



                if (resp.startsWith("DBentered")) {
                    send_msg(message,User,Time);




                } else {
                     
             console.error("DBentered not entered");

                }
            }
        } catch (error) {
          
            console.error("Error:", error);

        }
    };


    xhr.open("GET", url, true);
    xhr.send();


}


// correct script
function send_msg(message,user,time) {


    if (message.trim() !== "") {
        var chatBox = document.getElementById("chatBox");
        var chatContainer = document.getElementById("list");

        // Create a new chat message element
        var newMessage = document.createElement("div");
        newMessage.className = "clientSideDiv";

        // Construct the HTML structure for the new message
        newMessage.innerHTML = `<div class="SendMsg_1" id="SendMsg_1"  >
                     <div class="d-flex justify-content-between">
                                        <p class="small mb-1 text-muted">${time}</p>
                                        <p class="small mb-1">${user}</p>
                                    </div>
                      <div class="d-flex flex-row justify-content-end mb-4 pt-1">
                                        <div>
                                           <p class="small p-2 me-3 mb-3 text-white rounded-3 bg-warning"> ${message}</p></p>
                                        </div>
                                        <img src="https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-chat/ava6-bg.webp"
                                             alt="avatar 1" style="width: 45px; height: 100%;">
                                    </div>
                                </div>
        <br>
                `;

        // Append the new message to the chat container
        chatContainer.appendChild(newMessage);

        // Clear the input field
        messageInput.value = "";

        // Scroll to the bottom to show the latest message
        chatBox.scrollTop = chatBox.scrollHeight;
    }
}

function recPRint(Rmsg,Ruser,Rtime) {

    var message = Rmsg;
    var User = Ruser;
    var Time=Rtime;
    if (message.trim() !== "") {
        var chatBox = document.getElementById("chatBox");
        var chatContainer = document.getElementById("list");

        // Create a new chat message element
        var newMessage = document.createElement("div");
        newMessage.className = "recmsg_1";

        // Construct the HTML structure for the new message
        newMessage.innerHTML = ` 
        
       <div class="recmsg_1" id="recmsg_1">
                     <div class="d-flex justify-content-between">
                                        <p class="small mb-1">${User} </p>
                                        <p class="small mb-1 text-muted">${Time}</p>
                                    </div>
                    <div class="d-flex flex-row justify-content-start" id="FullDiv">
        <img src="https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-chat/ava5-bg.webp"
                                             alt="avatar 1" style="width: 45px; height: 100%;">
                                        <div>
                                            <p class="small p-2 ms-3 mb-3 rounded-3" style="background-color: #f5f6f7; id=txtRec">${message}</p>
                                        </div>
                                    </div>
                                </div>
        <br> 

                `;

        // Append the new message to the chat container
        chatContainer.appendChild(newMessage);

        // Clear the input field


        // Scroll to the bottom to show the latest message
        chatBox.scrollTop = chatBox.scrollHeight;
    }
}


// Reoload Script

function loadChat() {
  
    var url = "ChatPBck";

    var xhr = new XMLHttpRequest();

    xhr.onreadystatechange = function () {
        try {
            if (xhr.readyState === 4 && xhr.status === 200) {
                var resp = xhr.responseText;

               
                if (resp.startsWith("list")) {
                    try {
                        // Extract the JSON part after "list"
                        var jsonPart = resp.substring("list".length);
                        // Parse the JSON
                        var messagesArray = JSON.parse(jsonPart);

                  //      alert("messagesArray.length: " + messagesArray.length);
                    

                        for (var i = 0; i < messagesArray.length; i++) {
                            var message = messagesArray[i];
                        
                            var Msg = message.Msg;
                             var Msg_ID = message.Msg_ID;
                             var User = message.User;
                            var Time = message.Time;
                            var S_R = message.S_R;
                            if(S_R=="R"){
                                recPRint(Msg,User,Time);
                            }
                               if(S_R=="S"){
                                    send_msg(Msg,User,Time);
                               } 
                                  
                         
                         
                        }
                    } catch (error) {
                        
                        console.error("Error parsing JSON:", error);
                    }

                } else if (resp.startsWith("alreadySentMessage")) {
                    console.error("alreadySentMessage:");
                    
                }

            } else if (xhr.readyState === 4 && xhr.status !== 200) {
                console.error("Failed to load. Status:", xhr.status);
            }
        } catch (error) {
            console.error("Error:", error);
        }
    };

    xhr.open("POST", url, true);
    xhr.send();
}
