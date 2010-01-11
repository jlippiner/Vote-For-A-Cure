$(function(){
  $('#reset_styles').click(function(){
    $.ajax({
      url: this.href, 
      success: function(html){
        log(html);
        $('#site_styles').attr('value',html);
      }
    });

    return false;
  })
  
})