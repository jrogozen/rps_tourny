$('#header .drop').hover(
  function(){
    console.log($(this));
    $(this).find('drop-container').addClass('active');
  },
  function(){
    console.log('waht');
  }
)