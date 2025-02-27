function GetBot() {
 
    // Log that the function has started
   var brand= document.getElementById("brand_val").value;
    

    

    var url = "campDrop?brand="+brand;
 
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

function GetTemplate(){
 
    
      // Log that the function has started
   var bot= document.getElementById("BotList").value;
 
    

    

    var url = "campDrop?bot="+bot;
 
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
                            
                        
                           

                            Drp_val_jsn_call_template(myJSON.Array1);
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


    xhr.open("POST", url, true);
    xhr.send();
    
    
}

function Drp_val_jsn_call_template(Drp_val_jsn) {
    

    // Log that the function has started
 

    var dropdown = document.getElementById('TemplateList');
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