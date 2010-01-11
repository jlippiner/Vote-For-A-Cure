$(function(){
  handle_sold_by_mtt('#product_sold_by_mtt');

  $('#product_sold_by_mtt').click(function(){
    log('here');
    handle_sold_by_mtt(this)
  })
})

function handle_sold_by_mtt(el) {
   if ($(el).attr('checked')) {
     $('#purchase_url').hide();
   } else {
     $('#purchase_url').show();
   }
 }

