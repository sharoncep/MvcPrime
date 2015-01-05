$(document).ready(function () {
    var mySelect = $('#ddlPwdExpDys');
    for (var i = 0; i < 367; i++) {
        mySelect.append($('<option></option>').val(i).html(i));
    }
});