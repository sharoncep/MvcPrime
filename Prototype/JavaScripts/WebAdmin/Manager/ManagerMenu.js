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
    retAns += "<li><a href=\"MenuPre.html\">Managing</a></li>";

    retAns += "<li><a href=\"MenuAddress.html\">Address</a>";
//    retAns += "<div>";
    retAns += "<ul><li><a href=\"City_Search.html\">City</a></li>";
    retAns += "<li><a href=\"Country_Search.html\">Country</a></li>";
    retAns += "<li><a href=\"County_Search.html\">County</a></li>";
    retAns += "<li><a href=\"State_Search.html\">State</a></li>";
    retAns += "<li><a href=\"ZipCode_Search.html\">Zip Code</a></li>";
    retAns += "</ul></li>";
//    retAns += "</div>";

    retAns += "<li><a href=\"MenuBillingInfo.html\">Billing Info</a>";
//    retAns += "<div>";
    retAns += "<ul><li><a href=\"Billing_IPA_Search.html\">Billing / IPA</a></li>";
    retAns += "<li><a href=\"Entity Type_Search.html\">Entity Type</a></li>";
    retAns += "<li><a href=\"Facility_Done_Search.html\">Facility / POS</a></li>";
    retAns += "<li><a href=\"Hospital_Search.html\">Hospital</a></li>";
    retAns += "<li><a href=\"Nurshing_Home_Search.html\">Nursing Home</a></li>";
    retAns += "<li><a href=\"Clinic_Selection.html\">Practice / Clinic</a></li>";
    retAns += "<li><a href=\"Specialty_Search.html\">Specialty</a></li>";
    retAns += "</ul></li>";
//    retAns += "<div>";
    retAns += "<li><a href=\"Menu.html\">Navigation</a></li>";
    retAns += "<li><a href=\"Provider_Search.html\">Provider</a>";
    retAns += "<ul><li><a href=\"Case_Complexity.html\">Case Complexity</a></li>";
    retAns += "<li><a href=\"Case_Agent.html\">Case Agent</a></li>";
    retAns += "<li><a href=\"Case_Time_Spent.html\">Case Time Spent</a></li>";
    retAns += "</ul></li>";
//    retAns += "</div>";
    
//    retAns += "</div>";


    retAns += "<li><a href=\"Diagnosis_Search.html\">Diagnosis</a>";
    retAns += "<ul><li><a href=\"CPT_Search.html\">CPT</a></li>";
    retAns += "<li><a href=\"MenuDx.html\">Dx</a></li>";
//    retAns += "<div>";

    retAns += "<li><a href=\"Illness_Indicator_Search.html\">Illness Indicator</a></li>";
    retAns += "<li><a href=\"Usage_Indicator_Search.html\">Usage Indicator</a></li>";
    retAns += "</ul></li>";
//    retAns += "</div>";

    retAns += "<li><a href=\"MenuEDI.html\">EDI</a>";
//    retAns += "<div>";
    retAns += "<ul><li><a href=\"Claim_Media_Search.html\">Claim Media</a></li>";
    retAns += "<li><a href=\"EDI_Search.html\">EDI</a></li>";
    retAns += "<li><a href=\"EDI_Reciever_Search.html\">EDI Reciever</a></li>";
    retAns += "<li><a href=\"Print_Pin_Search.html\">Print Pin</a></li>";
    retAns += "<li><a href=\"Print_Sign_Search.html\">Print Sign</a></li>";
    retAns += "</ul></li>";
//    retAns += "</div>";

    retAns += "<li><a href=\"MenuInsurance.html\">Insurance</a>";
    //    retAns += "<div>";
    retAns += "<ul><li><a href=\"Insurance_Search.html\">Insurance</a></li>";
    retAns += "<li><a href=\"Insurance_Type_Search.html\">Insurance Type</a></li>";
    retAns += "<li><a href=\"Relationship_Search.html\">Relationship</a></li>";
    retAns += "</ul></li>";
//    retAns += "</div>";

    retAns += "<li><a href=\"MenuUser.html\">User Info</a>";
//    retAns += "<div>";
    retAns += "<ul><li><a href=\"Role_View.html\">Role</a></li>";
    retAns += "<li><a href=\"User_Search.html\">User</a></li>";
    retAns += "<li><a href=\"User_Clinic.html\">User And Clinic</a></li>";
    retAns += "<li><a href=\"User_Role.html\">User And Role</a></li>";
    retAns += "</ul></li>";
//    retAns += "</div>";

    retAns += "<li><a href=\"MenuTransaction.html\">Transaction</a>";
//    retAns += "<div>";
    retAns += "<ul><li><a href=\"Author_Info_Management.html\">Author Info Qualifier (ISA02)</a></li>";
    retAns += "<li><a href=\"Security_Info_Management.html\">Security Info Qualifier (ISA03)</a></li>";
    retAns += "<li><a href=\"Trans_Purpose_Code_Search.html\">Trans Purpose Code</a></li>";
    retAns += "<li><a href=\"Trans_Type_Code_Search.html\">Trans Type Code</a></li>";
    retAns += "</ul></li>";
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