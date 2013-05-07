$(document).ready(function() {  


  // $("#mc-subscribe-form").ajaxForm({url: '<%= email_subscribe_path %>', type: 'post'}) 

  // $("#mc-subscribe-form").submit(function(e){
  //   var form = $(this);
  // //     form.submit();
  // });

  // var timer;
  // $(document).on('keyup input', '#map_standards_filter_resource_search', function() {
  //     var form = $(this);
  //     form.submit();
  // });

  // $(document).on('change', '#map_standards_filter_resource_form', function() {
  //     $(this).submit();
  // });


  $(document)
  .on('ajax:error', '#mc-subscribe-form', function(event, data, status, xhr) {
      pushFlash({message:"<%= I18n.t('resources.filter_failure') %>", state: 'success', fadeOut: 5000});
  })
  .on('ajax:success', '#mc-subscribe-form', function(event, data, status, xhr) {
      var success = $('<div style="text-align:center;">Success, you are now subscribed!!</div>');
      $('#mailchimp').html(success);  
      success.effect('highlight',{color:'#DBDBFF'},2000);
  });

});