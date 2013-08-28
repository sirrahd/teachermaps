$(document).ready(function() {  



  //////////////////////////////
  //
  // Email list form
  //
  //////////////////////////////
  $(document).on('submit', '#mc-subscribe-form', function(e) {
    e.preventDefault();  
    
    var emailAddress = $('#mc-email').val();

    if(emailAddress == 'undefined' && emailAddress.length == 0) {
      // pushFlash({message:"Email Subscribtion Error", state: 'success', fadeOut: 5000});
      return;
    }

    $.ajax({
      data: { email : $.trim(emailAddress) },
      type: 'POST',
      url: '/subscribe/email',
      dataType: 'html',
      success: function () {
        console.log("Success");
        var success = $('<div style="text-align:center;">Success, you are now subscribed!!</div>');
        $('#mailchimp').html(success);  
        success.effect('highlight',{color:'#DBDBFF'},2000);
      },
      error: function () {
        console.log("Error");
        pushFlash({message:"Email Subscribtion Error", state: 'success', fadeOut: 5000});
      }
    });

    e.stopPropagation();
  });

});