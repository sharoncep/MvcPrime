$(document).ready(function () {
    var mySelect = $('.ddl-forms-fixed');
    for (var i = 0; i <= 200; i++) {
        mySelect.append($('<option></option>').val(i).html(i));
    }
});