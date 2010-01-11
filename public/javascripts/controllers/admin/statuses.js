$(function(){
  $('#status_message').livequery('keyup',function(){
      limitChars('status_message', 144, 'chars_left');
  });
})

function limitChars(textid, limit, infodiv)
{
    var text = $('#'+textid).val();    
    var textlength = text.length;
    if(textlength > limit)
    {
        $('#' + infodiv).html('0!');
        $('#'+ textid).val(text.substr(0,limit));
        return false;
    }
    else
    {
        $('#' + infodiv).html((limit - textlength));
        return true;
    }
}
