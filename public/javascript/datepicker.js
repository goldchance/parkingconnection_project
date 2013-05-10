// JavaScript Document
 $(function() {
        $( "#from" ).datepicker({
            defaultDate: "+0d",
            changeMonth: false,
            numberOfMonths: 2,
			minDate: 0,
            onClose: function( selectedDate ) {
                $( "#to" ).datepicker( "option", "minDate", selectedDate );
                $("#to").datepicker("show");
            }
        });
        $( "#to" ).datepicker({
            defaultDate: "+0d",
            changeMonth: false,
            numberOfMonths: 2,
			minDate: 0,
            onClose: function( selectedDate ) {
                $( "#from" ).datepicker( "option", "maxDate", selectedDate );
            }
        });
    });
