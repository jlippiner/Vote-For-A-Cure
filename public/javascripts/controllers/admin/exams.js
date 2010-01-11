$(function(){
   $('#generate_tags').click(function(){
     var answer = confirm("This will overwrite any tags already entered!");
   
     if (answer) {
       url = $(this).attr('rel');
       var str = $('form').serialize();
       log(url);
       log(str);
       $.ajax({
         type: "POST",
         url: url,
         data: str,
         success: function(msg){
           log(msg);
           $('#exam_tag_list').attr('value',msg)
         }
       });
     }
   })
 })