function GetBot() {
 
    // Log that the function has started
   var brand= document.getElementById("brand_val").value;
    

    

    var url = "detFetch?brand="+brand;
 
    var xhr = new XMLHttpRequest();

    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4) {
  
            if (xhr.status === 200) {
                try {
                    // Log that JSON parsing is about to start
                   

                    var responseText = xhr.responseText;
                    if (responseText) {
                        
                        const myJSON = JSON.parse(responseText);
                        if (myJSON.Array1) {
                            
                        
                           

                            Drp_val_jsn_call_bot(myJSON.Array1);
                        } else {
                            console.error("JSON structure is not as expected:", myJSON);

                        }
                    } else {
                        console.error("Empty response text");

                    }
                    // Log that JSON parsing is completed
                   
                } catch (error) {
                    console.error("Error parsing JSON:", error);

                }
            } else {
                console.error("Request failed with status:", xhr.status);

            }
            // Log that the function has completed
           
        }
    };

    xhr.open("GET", url, true);
    xhr.send();
}


function Drp_val_jsn_call_bot(Drp_val_jsn) {
    

    // Log that the function has started
 


    var dropdown = document.getElementById('BotList');
    dropdown.innerHTML = ''; // Clear existing options

    for (var i = 0; i < Drp_val_jsn.length; i++) {
        var opt = Drp_val_jsn[i];

        var el = document.createElement("option");
        el.textContent = opt;
        el.value = opt;

        dropdown.appendChild(el);
    }
    // Log that the function has completed
   
}



function senderID(){
    
      var BotList= document.getElementById("BotList").value;
      var senderIDPhone=document.getElementById("senderIDPhone");
             senderIDPhone.innerHTML=BotList;
    
    
}

function Text_MSG(){
    
      var txtFeild= document.getElementById("txtFeild").value;
      var txtFeildPhn=document.getElementById("txtFeildPhn");
              txtFeildPhn.innerHTML=txtFeild;
    
    
}

function test(){
    alert("dsbnfkjbs");
     var http = new XMLHttpRequest();
 
var url = 'data_json';
 

http.open('POST', url, true);

// Set the Content-type header
http.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');

http.onreadystatechange = function() {
    if (http.readyState == 4 && http.status == 200) {
        // Handle the response
        console.log(http.responseText);
    }
}

// Send the request with the parameters
http.send( );

    
}
var switchStatus = false;

function toggle_Schedule() {
    var togBtn = document.getElementById('togBtn');
    
    if (togBtn.firstElementChild.checked) {
        switchStatus = true;
      var myElement = document.getElementById('calndr');

    // Change the display style to inline
    myElement.style.display = 'inline';
    } else {
        switchStatus = false;
        var myElement = document.getElementById('calndr');

    // Change the display style to inline
    myElement.style.display = 'none';
    }
}


function ChnageTitle(){
    
      var title= document.getElementById("title").value;
      var title_mobile=document.getElementById("title_mobile");
             title_mobile.innerHTML=title;
    
    
}

 function descriptionChange(){
      var Description= document.getElementById("Description").value;
      var description_mobile=document.getElementById("description_mobile");
             description_mobile.innerHTML=Description;
     
 }
  function Sugestion1IF(){
         
      
      var Sugestion1I= document.getElementById("Sugestion1I").value;
      var suggestion1M=document.getElementById("suggestion1M");
             suggestion1M.innerHTML=Sugestion1I;
      
         
 }
  
   function Sugestion2IF(){
      var Sugestion2I= document.getElementById("Sugestion2I").value;
      var Sugestion2M=document.getElementById("Sugestion2M");
             Sugestion2M.innerHTML=Sugestion2I;
               
     
 }
 
     function updateImage() {
            // Get the URL entered by the user
            var imageURL = document.getElementById("URLimg").value;

            // Update the src attribute of the img tag
            document.getElementById("dynamicImage").src = imageURL;
        }


function submitForm(){
 
     var Template = document.getElementById("Template").value;
        
          var brand_val = document.getElementById("brand_val").value;
       
         
           var BotList = document.getElementById("BotList").value;
        
          
            
        
         
           var title = document.getElementById("title").value;
       
         
            var Description = document.getElementById("Description").value;
       
         
          var URL = document.getElementById("URL").value;
      
           var URLSugestion1I = document.getElementById("Sugestion1I").value;
          
         
            var URLSuggestion_Postback = document.getElementById("Suggestion_Postback").value;
                 var URLsuggestion1 = document.getElementById("URLsuggestion1").value;
      
         
            var URLimg = document.getElementById("URLimg").value;
      
         
            var Dial = document.getElementById("Dial").value;
         
         
           var Sugestion2I = document.getElementById("Sugestion2I").value;
         
         
             var Suggestion_Postback2 = document.getElementById("Suggestion_Postback2").value;
      
         
           
               var Mobile = document.getElementById("Mobile").value;
               
     
     
           
     
            
           
           
            
          
            
   var http = new XMLHttpRequest();
 
var url = 'data_json';
var params = 'Template=' + encodeURIComponent(Template) + '&brand_val=' + encodeURIComponent(brand_val) + '&BotList=' + encodeURIComponent(BotList) +
         '&title=' + encodeURIComponent(title) +'&Description=' + encodeURIComponent(Description) +
        '&URL=' + encodeURIComponent(URL) +
        '&URLSugestion1I=' + encodeURIComponent(URLSugestion1I) +'&URLSuggestion_Postback=' + encodeURIComponent(URLSuggestion_Postback) +'&URLimg=' + encodeURIComponent(URLimg) +
        '&Dial=' + encodeURIComponent(Dial) +'&Sugestion2I=' + encodeURIComponent(Sugestion2I) +'&Suggestion_Postback2=' + encodeURIComponent(Suggestion_Postback2) +
        '&Mobile=' + encodeURIComponent(Mobile)+ '&URLsuggestion1=' + encodeURIComponent(URLsuggestion1);

http.open('POST', url, true);

// Set the Content-type header
http.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');

http.onreadystatechange = function() {
      
    if (http.readyState == 4 && http.status == 200) {
        // Handle the response
        console.log(http.responseText);
      //  alert(http.responseText);
if (http.responseText.trim() === "succ") {
    alert("Template Registered");
    location.reload();
}

        
        
    }
}

// Send the request with the parameters
http.send(params);
        

       
    
}


  window.onload = BrandDetail;
  
  function BrandDetail() {
    // Log that the function has started
     

    var url = "detFetch";
   

    var xhr = new XMLHttpRequest();

    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4) {
            // Log that the request has been completed
         

            if (xhr.status === 200) {
                try {
                    // Log that JSON parsing is about to start
                    

                    var responseText = xhr.responseText;
                    alert("responseText: " + responseText);

                    if (responseText) {
                        const myJSON = JSON.parse(responseText);

                        if (myJSON.Array1) {
                            // Log that JSON parsing is completed successfully
                            alert("JSON parsing successful");

                            Drp_val_jsn_call_brand(myJSON.Array1);
                        } else {
                            console.error("JSON structure is not as expected:", myJSON);
                        }
                    } else {
                        console.error("Empty response text");
                    }
                } catch (error) {
                    console.error("Error parsing JSON:", error);
                }
            } else {
                // Log the failure status and handle errors gracefully
                console.error("Request failed with status:", xhr.status);
                alert("Request failed with status: " + xhr.status);
            }
        }
    };

    xhr.open("POST", url, true);
  
    xhr.send();
}

 

   
  function Drp_val_jsn_call_brand(Drp_val_jsn) {
    

    // Log that the function has started
 


    var dropdown = document.getElementById('brand_val');
    dropdown.innerHTML = ''; // Clear existing options

    for (var i = 0; i < Drp_val_jsn.length; i++) {
        var opt = Drp_val_jsn[i];

        var el = document.createElement("option");
        el.textContent = opt;
        el.value = opt;

        dropdown.appendChild(el);
    }
    // Log that the function has completed
   
}




