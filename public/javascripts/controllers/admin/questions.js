$(function(){
  $('#new_section').click(function(){
    url = $(this).attr('rel');
    el = $('#question_section_id');
    answer = prompt('New section name:')
    if(answer != '' && answer != null ) {
       $.ajax({
            type: 'POST',
            dataType: 'json',
            url: url,
            data: 'section[name]='+answer,
            success: function showResponse(responseText, statusText) {
                key = responseText['section']['id']
                value = responseText['section']['name']
                $(el).append($("<option></option>").attr("value",key).text(value)).sortOptions().selectOptions(key);
                $.flash.show();
            }
        });
    } 
    
    return false;
  })
})