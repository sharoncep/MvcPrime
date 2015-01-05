function collapsePnlDivSuperBill() {
    expandSuperBill();
}

function expandMnuDiv() {
    expandDiv("GoTo");
    collapseGoTo();

    return false;
}

function collapseMnuDiv() {
    collapsePnlDiv("GoTo");

    return false;
}

function expandMenuSuperBill() {
    $("#divDrNoteE").fadeIn("slow", "linear");
    $("#divGoToE").fadeIn("slow", "linear");
    $("#divSuperBillE").fadeIn("slow", "linear");
    $("#divSuperBillC").fadeOut("slow", "linear");

    return false;
}

function collapseSuperBill() {
    $("#divSuperBillE").fadeOut("slow", "linear");
    $("#divDrNoteE").fadeOut("slow", "linear");
    $("#divGoToE").fadeOut("slow", "linear");

    return false;
}
function expandMenuDrNote() {
    $("#divSuperBillE").fadeIn("slow", "linear");
    $("#divGoToE").fadeIn("slow", "linear");
    $("#divDrNoteE").fadeIn("slow", "linear");
    $("#divDrNoteC").fadeOut("slow", "linear");

    return false;
}

function collapseDrNote() {
    $("#divDrNoteE").fadeOut("slow", "linear");
    $("#divSuperBillE").fadeOut("slow", "linear");
    $("#divGoToE").fadeOut("slow", "linear");

    return false;
}
function expandMenuDrNote() {
    $("#divSuperBillE").fadeIn("slow", "linear");
    $("#divGoToE").fadeIn("slow", "linear");
    $("#divDrNoteE").fadeIn("slow", "linear");
    $("#divDrNoteC").fadeOut("slow", "linear");

    return false;
}
function expandMenuGoTo() {
    $("#divGoToC").fadeOut("slow", "linear", function () {
        $("#divGoToE").fadeIn("slow", "linear");
        $("#divSuperBillE").fadeIn("slow", "linear");
        $("#divDrNoteE").fadeIn("slow", "linear");
    });

    return false;
}

function collapseGoTo() {
    $("#divSuperBillE").fadeOut("slow", "linear");
    $("#divDrNoteE").fadeOut("slow", "linear");

    return false;
}

function gotoDiv(ky) {
    expandPnlDiv(ky);
    expandMenuGoTo();

    setTimeout("gotoDivSub('" + ky + "')", 500);

    return false;
}

function gotoDivSub(ky) {
    location.hash = "#a" + ky + "C";
    return false;
}

function expandAllPnlDiv() {
    collapsePnlDiv("GoTo");
    expandPnlDiv("Visit");
    expandPnlDiv("Dx");
    expandPnlDiv("Dxprimary");
    expandPnlDiv("Cpt");
    expandPnlDiv("Visitdoc");
    expandPnlDiv("Notes");
    expandPnlDiv("PatientDoc");
    expandPnlDiv("Patient");
    expandPnlDiv("Claim");
    expandPnlDiv("Settings");
    expandPnlDiv("Ipa");
    expandPnlDiv("Clinic");
    expandPnlDiv("FacilityDone");
    expandPnlDiv("Provider");
    expandPnlDiv("Insurance");
    expandPnlDiv("PrevVisits");
    expandMenuGoTo();

    return false;
}

function collapseAllPnlDiv() {
    collapsePnlDiv("GoTo");
    collapsePnlDiv("Visit");
    collapsePnlDiv("Dx");
    collapsePnlDiv("Dxprimary");
    collapsePnlDiv("Cpt");
    collapsePnlDiv("Visitdoc");
    collapsePnlDiv("Notes");
    collapsePnlDiv("PatientDoc");
    collapsePnlDiv("Patient");
    collapsePnlDiv("Claim");
    collapsePnlDiv("Settings");
    collapsePnlDiv("Ipa");
    collapsePnlDiv("Clinic");
    collapsePnlDiv("FacilityDone");
    collapsePnlDiv("Provider");
    collapsePnlDiv("Insurance");
    collapsePnlDiv("PrevVisits");
    expandMenuGoTo();

    return false;
}

function expandDrNote() {
    collapseDrNote();
    expandPnlDiv("DrNote");

    return false;
}

function expandSuperBill() {
    collapseSuperBill();
    expandPnlDiv("SuperBill");

    return false;
}