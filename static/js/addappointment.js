$(function () {

    function moveItems(origin, dest) {
        $(origin).find(':selected').appendTo(dest);
        $(dest).find(':selected').removeAttr("selected");
        $(dest).sort_select_box();
    }

    function moveAllItems(origin, dest) {
        $(origin).children("option:visible").appendTo(dest);
        $(dest).find(':selected').removeAttr("selected");
        $(dest).sort_select_box();
    }

    $('.left').on('click', function () {
        var container = $(this).closest('.addremove-multiselect');
        moveItems($(container).find('select.multiselect.selected'), $(container).find('select.multiselect.available'));
    });

    $('.right').on('click', function () {
        var container = $(this).closest('.addremove-multiselect');
        moveItems($(container).find('select.multiselect.available'), $(container).find('select.multiselect.selected'));
    });

    $('.leftall').on('click', function () {
        var container = $(this).closest('.addremove-multiselect');
        moveAllItems($(container).find('select.multiselect.selected'), $(container).find('select.multiselect.available'));
    });

    $('.rightall').on('click', function () {
        var container = $(this).closest('.addremove-multiselect');
        moveAllItems($(container).find('select.multiselect.available'), $(container).find('select.multiselect.selected'));
    });

    $('select.multiselect.selected').on('dblclick keyup',function(e){
        if(e.which == 13 || e.type == 'dblclick') {
          var container = $(this).closest('.addremove-multiselect');
          moveItems($(container).find('select.multiselect.selected'), $(container).find('select.multiselect.available'));
        }
    });

    $('select.multiselect.available').on('dblclick keyup',function(e){
        if(e.which == 13 || e.type == 'dblclick') {
            var container = $(this).closest('.addremove-multiselect');
            moveItems($(container).find('select.multiselect.available'), $(container).find('select.multiselect.selected'));
        }
    });


});

$.fn.sort_select_box = function(){
    // Get options from select box
    var my_options =$(this).children('option');
    // sort alphabetically
    my_options.sort(function(a,b) {
        if (a.text > b.text) return 1;
        else if (a.text < b.text) return -1;
        else return 0
    })
   //replace with sorted my_options;
   $(this).empty().append( my_options );

   // clearing any selections
   $("#"+this.attr('id')+" option").attr('selected', false);
}

function addAppointment()
{
    alert("HALLO");
}
