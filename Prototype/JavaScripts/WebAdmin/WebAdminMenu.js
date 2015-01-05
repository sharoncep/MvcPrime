$(document).ready(function () {
    setTimeout("loadWebAdminMenu()", 50);
});

function loadWebAdminMenu() {
    $("#divMainMenu").html("");

    var retAns = "";

    retAns += "<div>";
    retAns += "<a href=\"\" id=\"aMainMenuE\" title=\"Expand\" onclick=\"javascript:return expandMainMenu();\" class=\"aMenuExpand\"></a>";
    retAns += "<a href=\"\" id=\"aMainMenuC\" title=\"Collapse\" style=\"display:none; color:green;\" onclick=\"javascript:return hideMainMenu();\" class=\"aMenuCollapse\"></a>";
    retAns += "</div>";

    retAns += "<div id=\"divMainMenuC\">";

    retAns += "<div>";
    retAns += "<ul class=\"ul-vertical-menu\">";
    retAns += "<li><a href=\"Dashboard.html\">Dashboard</a></li>";
    retAns += "<li><a href=\"Role_Selection.html\">Role</a></li>";
    retAns += "<li><a href=\"Menu.html\">Administration</a></li>";

    retAns += "<li><a href=\"MenuAddress.html\">Address</a>";
    //    retAns += "<div>";
    retAns += "<ul><li><a href=\"City_Block.html\">City</a></li>";
    retAns += "<li><a href=\"Country_Block.html\">Country</a></li>";
    retAns += "<li><a href=\"County_Block.html\">County</a>";
    retAns += "<li><a href=\"State_Block.html\">State</a></li>";
    retAns += "<li><a href=\"ZipCode_Block.html\">Zip Code</a></li>";
    retAns += "</ul></li>";
    ////    retAns += "</div>";
   

    retAns += "<li><a href=\"MenuBillingInfo.html\">Billing Info</a>";
//    retAns += "<div>";
    retAns += "<ul><li><a href=\"Billing_IPA_Search.html\">Billing / IPA</a></li>";
    retAns += "<li><a href=\"Clinic_Search.html\">Clinic</a></li>";
    retAns += "<li><a href=\"Entity Type_Block.html\">Entity Type</a></li>";
    retAns += "<li><a href=\"Insurance_Block.html\">Insurance</a></li>";
    retAns += "<li><a href=\"Provider_Block.html\">Provider</a></li>";
    retAns += "<li><a href=\"Specialty_Block.html\">Specialty</a></li>";
    retAns += "</ul></li>";
//    retAns += "</div>";

    retAns += "<li><a href=\"MenuConfig.html\">Configurations</a>";
    //    retAns += "<div>";
    retAns += "<ul><li><a href=\"Excel_Import_Export.html\">Excel Import / Export</a></li>";
    retAns += "<li><a href=\"Alert_Configuration.html\">General Configuration</a></li>";
    retAns += "<li><a href=\"Password_Complexity.html\">Password Complexity</a></li>";
    retAns += "</ul></li>";
//    retAns += "</div>";

    retAns += "<li><a href=\"MenuUser.html\">User Info</a>";
    retAns += "<div>";
    retAns += "<ul><li><a href=\"Role_Management.html\">Role</a></li>";
    retAns += "<li><a href=\"User_Search.html\">User</a></li>";
    retAns += "<li><a href=\"User_Clinic_Management.html\">User And Clinic</a></li>";
    retAns += "<li><a href=\"User_Role_Management.html\">User And Role</a></li>";
    retAns += "</ul></li>";
    retAns += "</ul>";
//    retAns += "</div>";

    retAns += "</div>";

    retAns += "</div>";

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