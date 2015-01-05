$(document).ready(function () {
    setTimeout("loadWebAdminMenu()", 50);
});

function loadWebAdminMenu() {
    $("#divMainMenu").html("");

    var retAns = "";

    retAns += "<div id=\"divMainMenuE\">";
    retAns += "<a href=\"\" id=\"aMainMenuE\" title=\"Expand\" onclick=\"javascript:return expandMainMenu();\" class=\"aMenuExpand\"></a>";
    retAns += "<a href=\"\" id=\"aMainMenuC\" title=\"Collapse\" style=\"display:none; color:green;\" onclick=\"javascript:return hideMainMenu();\" class=\"aMenuCollapse\"></a>";
    retAns += "</div>";

    retAns += "<div id=\"divMainMenuC\" style=\"display:none;\">";

    retAns += "<div>";
    retAns += "<ul class=\"ul-vertical-menu\">";

    retAns += "<li><a href=\"../Dashboard.html\">Dashboard</a></li>";
    retAns += "<li><a href=\"../Role_Selection.html\">Role</a></li>";
    retAns += "<li><a href=\"Clinic_Selection.html\">Clinic</a></li>";

    retAns += "<li><a href=\"Menu.html\">Actions</a>";
    //    retAns += "<div>";
    retAns += "<ul><li><a href=\"My_Claims.html\">Created Claims</a></li>";
    retAns += "<li><a href=\"General_Queue.html\">Unassigned Claims</a></li>";
    retAns += "<li><a href=\"General_Queue_NIT.html\">Unassigned Claims- Not in Track</a></li>";
    retAns += "<li><a href=\"My_Queue.html\">Assigned Claims</a></li>";
    retAns += "<li><a href=\"My_Queue_NIT.html\">Assigned Claims - Not In Track</a></li>";

    retAns += "<li><a href=\"Team_Members.html\">Team Member</a>";

    retAns += "<ul><li><a href=\"Team_Members_IPA.html\">Team Member IPA View</a></li>";
    retAns += "<li><a href=\"Team_Members_MA.html\">Team Member Manager View</a></li>";
    retAns += "<li><a href=\"Team_Members_BA.html\">Team Member Billing Agent View</a></li>";
    retAns += "<li><a href=\"Team_Members_QA.html\">Team Member Quality Analyzis Agent View</a></li>";
    retAns += "<li><a href=\"Team_Members_EA.html\">Team Member EDI Agent View</a</li>";
    retAns += "</ul></li>";

    retAns += "<li><a href=\"EDI.html\">EDI</a>";
    retAns += "<ul><li><a href=\"EDI_Create.html\">EDI Create</a></li>";
    retAns += "<li><a href=\"EDI_Respond.html\">EDI Respond</a></li>";
    retAns += "<li><a href=\"EDI_Respond_Paper.html\">EDI Respond - Paper Format</a></li>";
    retAns += "<li><a href=\"EDI_Respond_4010.html\">EDI Respond - ANSI 4010 Format</a></li>";
    retAns += "<li><a href=\"EDI_Respond_5010.html\">EDI Respond - ANSI 5010 Format</a></li>";
    retAns += "</ul></li>";
    //    retAns += "<div


    //    retAns += "<div>";
    //    retAns += "<li><a href=\"Team_Members_IPA.html\">Team Member IPA View</a>";
    //    retAns += "<li><a href=\"Team_Members_MA.html\">Team Member Manager View</a>";
    //    retAns += "<li><a href=\"Team_Members_BA.html\">Team Member Billing Agent View</a>";
    //    retAns += "<li><a href=\"Team_Members_QA.html\">Team Member Quality Analyzis Agent View</a>";
    //        retAns += "<a href=\"Team_Members_EA.html\">Team Member EDI Agent View</a>";
    retAns += "</ul>";

    $("#divMainMenu").html(retAns);
}


function expandMainMenu() {
    $("#aMainMenuE").fadeOut("fast", "linear", function () { $("#aMainMenuC").fadeIn("slow", "linear", function () { }); });
    $("#divMainMenuC").fadeIn("slow", "linear", function () { });

    return false;
}

function hideMainMenu() {
    $("#divMainMenuC").fadeOut("slow", "linear", function () { });
    $("#aMainMenuC").fadeOut("fast", "linear", function () { $("#aMainMenuE").fadeIn("slow", "linear", function () { }); });

    return false;
}