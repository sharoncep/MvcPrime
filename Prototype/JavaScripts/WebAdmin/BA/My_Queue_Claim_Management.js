$(document).ready(function () {
    expandDiv('visit');
});

function expandPnlDiv(ky) {
    return expandDiv(ky);
}

function collapsePnlDiv(ky) {
    return collapseDiv(ky);


}
function collapsePnlDivSuperBill() {
    expandSuperBill();

}
function expandMnuDiv() {
    expandDiv('divGoTo');
    collapseGoTo();

    return false;
}

function collapseMnuDiv() {
    collapseDiv('divGoTo');

    return false;
}

function expandDiv(ky) {
    $("#" + ky + "E").fadeOut("slow", "linear", function () { $("#" + ky + "C").fadeIn("slow", function () { $("#" + ky + "A").focus(); }); });

    return false;
}

function collapseDiv(ky) {
    $("#" + ky + "C").fadeOut("slow", "linear", function () { $("#" + ky + "E").fadeIn("slow"); });

    return false;
}

function expandMenuSuperBill() {
    $("#divDoctorNoteE").fadeIn("slow", "linear");
    $("#divGoToE").fadeIn("slow", "linear");
    $("#divSuperBillE").fadeIn("slow", "linear");
    $("#divSuperBillC").fadeOut("slow", "linear");
    return false;
}

function collapseSuperBill() {
    $("#divDoctorNoteE").fadeOut("slow", "linear");
    $("#divGoToE").fadeOut("slow", "linear");
    return false;
}
function expandMenuDoctorNote() {
    $("#divSuperBillE").fadeIn("slow", "linear");
    $("#divGoToE").fadeIn("slow", "linear");
    $("#divDoctorNoteE").fadeIn("slow", "linear");
    $("#divDoctorNoteC").fadeOut("slow", "linear");
    return false;
}

function collapseDoctorNote() {
    $("#divSuperBillE").fadeOut("slow", "linear");
    $("#divGoToE").fadeOut("slow", "linear");
    return false;
}
function expandMenuDoctorNote() {
    $("#divSuperBillE").fadeIn("slow", "linear");
    $("#divGoToE").fadeIn("slow", "linear");
    $("#divDoctorNoteE").fadeIn("slow", "linear");
    $("#divDoctorNoteC").fadeOut("slow", "linear");
    return false;
}
function expandMenuGoTo() {
    $("#divGoToC").fadeOut("slow", "linear", function () {
        $("#divGoToE").fadeIn("slow", "linear");
        $("#divSuperBillE").fadeIn("slow", "linear");
        $("#divDoctorNoteE").fadeIn("slow", "linear");

    });

    return false;
}

function collapseGoTo() {
    $("#divSuperBillE").fadeOut("slow", "linear");
    $("#divDoctorNoteE").fadeOut("slow", "linear");
    return false;
}

function gotoDiv(ky) {
    collapseDiv('divGoTo');
    expandDiv(ky);
    expandMenuGoTo();
    var sb = "gotoDivSub('" + ky + "')";
    setTimeout(sb, 660);

    return false;
}

function gotoDivSub(ky) {
    location.hash = "#" + ky

    return false;
}

function expandAllPnlDiv() {
    collapseDiv('divGoTo');
    expandDiv('visit');
    expandDiv('dx');
    expandDiv('dxprimary');
    expandDiv('cpt');
    expandDiv('documents');
    expandDiv('Notes');
    expandDiv('patDocument');
    expandDiv('patient');
    expandDiv('claimStatus');
    expandDiv('agents');
    expandDiv('rank');
    expandDiv('settings');
    expandDiv('ipa');
    expandDiv('clinic');
    expandDiv('hospital');
    expandDiv('nursing');
    expandDiv('provider');
    expandDiv('insurance');
    expandMenuGoTo();
    return false;
}

function collapseAllPnlDiv() {
    collapseDiv('divGoTo');
    collapseDiv('visit');
    collapseDiv('dx');
    collapseDiv('dxprimary');
    collapseDiv('cpt');
    collapseDiv('documents');
    collapseDiv('Notes');
    collapseDiv('patDocument');
    collapseDiv('patient');
    collapseDiv('claimStatus');
    collapseDiv('agents');
    collapseDiv('rank');
    collapseDiv('settings');
    collapseDiv('ipa');
    collapseDiv('clinic');
    collapseDiv('hospital');
    collapseDiv('nursing');
    collapseDiv('provider');
    collapseDiv('insurance');
    expandMenuGoTo();

    return false;

}

function expandDrNote() {
    collapseDoctorNote();
    expandDiv('divDoctorNote');

    return false;
}

function expandSuperBill() {
    expandDiv('divSuperBill');

    collapseSuperBill();


    return false;
}