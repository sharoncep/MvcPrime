$(document).ready(function () {
    loadSearchResult();
});

function loadSearchResult() {


    if (($('#chkHasRec').is(':checked'))) {


        loadSearch($("#StartBy").val(), $("#OrderByField").val(), $("#OrderByDirection").val(), true);

        var params = "{'pSearchName' : '" + $("#SearchName").val() + "', 'pStartBy' : '" + $("#StartBy").val() + "', 'pOrderByField' : '" + $("#OrderByField").val() + "', 'pOrderByDirection' : '" + $("#OrderByDirection").val() + "', 'pCurrPageNumber' : '" + $("#CurrPageNumber").val() + "'}";   // if no params need to use "{}"
        $.ajax({
            url: (_AppDomainPath + _CtrlrName + "/SearchAjaxCall/0/0/"),
            type: 'POST',
            data: params,
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            success: function (data, status) {
                searchSuccess(data, status);
            },
            error: function (req, status, errorObj) {
                ajaxCallError("UserRoleA_UR --> SearchAjaxCall", req, status, errorObj);
            }
        });
    }

    return false;
}

function searchSuccess(data, status) {


    var retAns = "";
    var i = -1;

    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;
            retAns = retAns + "<table class=\"table-entry\">";
            if (jsonData != null) {
                for (i in jsonData) {
                    var d = jsonData[i];

                    retAns = retAns + "<tr id=\"trSerRes";
                    retAns = retAns + d.ID;
                    retAns = retAns + "\" ";
                    if (!(d.IsActive)) {
                        retAns = retAns + "rel=\"rel-block\" ";
                    }
                    retAns = retAns + ">";

                    retAns = retAns + "<td style=\"width:20%\">";

                    retAns = retAns + d.DISP1;
                    retAns = retAns + "</td>";

                    retAns = retAns + "<td style=\"width:80%\">";
                    retAns = retAns + "<div id=\"divRole";
                    retAns = retAns + d.ID;
                    retAns = retAns + "\"";
                    retAns = retAns + "></div>";
                    retAns = retAns + "</td>";


                    $("#divSearchResult").html(retAns);

                   loadRoleResult(d.ID,retAns);


                }

                retAns = retAns + "</table>";
            }


        }
    }


    //for (i in jsonData) {
    //    var d = jsonData[i];

    //    loadClinicResult();
    //}

    hideSearchLoading();
}

function loadRoleResult(id, sumAns) {

    var params = "{'puserID' : '" + id + "'}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/SearchAjaxCallRoleResult/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            searchSuccessRole(data, status, id, sumAns);
        },
        error: function (req, status, errorObj) {
            // ajaxCallError("DashBoard_R --> SearchAjaxCallDash", req, status, errorObj);      // Here error forcefully suppressed to handing parital loading
        }
    });

    return false;
}
function searchSuccessRole(data, status, id, sumAns) {
    var retAns1 = "";
    var i = -1;

    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;
            if (jsonData != null) {
                //retAns1 = retAns1 + "<tr id=\"trSerRes\">";
                //retAns1 = retAns1 + "<td>";
                retAns1 = retAns1 + "<ul  class=\"ul-flist\">";

                for (i in jsonData) {

                    var d = jsonData[i];

                    retAns1 = retAns1 + "<li style=\"width:30%;\">";
                    retAns1 = retAns1 + d.DISP1;

                    retAns1 = retAns1 + "<span>";
                    if (d.FLAG) {
                        retAns1 = retAns1 + "<input type=\"button\" id=\"btnCheck";
                        retAns1 = retAns1 + d.DISP2;
                        retAns1 = retAns1 + "\"";
                        retAns1 = retAns1 + "class=\"button-checked\" onclick=\"javascript:return valBlockUnBlock";
                        retAns1 = retAns1 + "(";
                        retAns1 = retAns1 + "'";
                        retAns1 = retAns1 + d.DISP2;
                        retAns1 = retAns1 + "'";
                        retAns1 = retAns1 + ",'";
                        retAns1 = retAns1 + "B";
                        retAns1 = retAns1 + "'";
                        retAns1 = retAns1 + ",'";
                        retAns1 = retAns1 + d.ID;
                        retAns1 = retAns1 + "'";
                        retAns1 = retAns1 + ",'";
                        retAns1 = retAns1 + id;
                        retAns1 = retAns1 + "'";
                        retAns1 = retAns1 + ")\"";
                        retAns1 = retAns1 + "></input>";
                    }
                    else {
                        retAns1 = retAns1 + "<input type=\"button\" id=\"btnCheck";
                        retAns1 = retAns1 + d.DISP2;
                        retAns1 = retAns1 + "\"";
                        retAns1 = retAns1 + "class=\"button-unchecked\" onclick=\"javascript:return valBlockUnBlock";
                        retAns1 = retAns1 + "(";
                        retAns1 = retAns1 + "'";
                        retAns1 = retAns1 + d.DISP2;
                        retAns1 = retAns1 + "'";
                        retAns1 = retAns1 + ",'";
                        retAns1 = retAns1 + "U";
                        retAns1 = retAns1 + "'";
                        retAns1 = retAns1 + ",'";
                        retAns1 = retAns1 + d.ID;
                        retAns1 = retAns1 + "'";
                        retAns1 = retAns1 + ",'";
                        retAns1 = retAns1 + id;
                        retAns1 = retAns1 + "'";
                        retAns1 = retAns1 + ")\"";
                        retAns1 = retAns1 + "></input>";
                    }
                    retAns1 = retAns1 + "</span>";
                    retAns1 = retAns1 + "</li>";
                }

                retAns1 = retAns1 + "</ul>";
                //retAns1 = retAns1 + "</td>";

                //retAns1 = retAns1 + "</tr>";

                if (i < 0) {
                    retAns1 = retAns1 + "<tr>";
                    retAns1 = retAns1 + "<td>";
                    retAns1 = retAns1 + "";
                    retAns1 = retAns1 + "</td>";
                    retAns1 = retAns1 + "</tr>";
                }

                retAns1 = retAns1 + "</table>";
            }
        }
    }

    $("#divRole" + id).html(retAns1);




    return false;
}

function valBlockUnBlock(id, ky, rid, uid) {
    // id means PKID
    var params = "{'pID' : '" + id + "', 'pKy' : '" + ky + "', 'rid' : '" + rid + "', 'uid' : '" + uid + "'}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/BlockUnBlockAjaxCall/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            blockUnBlockSuccess(data, status, id, ky, rid, uid);
        },
        error: function (req, status, errorObj) {
            ajaxCallError("CityBlock_UR --> SearchAjaxCall", req, status, errorObj);
        }
    });


    return false;
}
function blockUnBlockSuccess(data, status, id, ky, rid, uid) {
    // id PK ID
    if (data != null) {

        if (status.toLowerCase() == 'success') {
            var jsonData = data;
            if (jsonData != null) {
                var d = jsonData[0];

                if (d.length == 0) {
                    if (ky == "B") {
                        $("#btnCheck" + id).removeAttr("class");
                        $("#btnCheck" + id).removeAttr("onclick");
                        $("#btnCheck" + id).attr("class", "button-unchecked");
                        $("#btnCheck" + id).attr("onclick", "javascript:return valBlockUnBlock('" + id + "', 'U','" + rid + "','" + uid + "')");
                    }
                    else {
                        if (id == 0) {
                            setSearch($("#StartBy").val(), '', '');
                        }
                        else {
                            $("#btnCheck" + id).removeAttr("class");
                            $("#btnCheck" + id).removeAttr("onclick");
                            $("#btnCheck" + id).attr("class", "button-checked");
                            $("#btnCheck" + id).attr("onclick", "javascript:return valBlockUnBlock('" + id + "', 'B','" + rid + "','" + uid + "')");
                        }
                    }
                }
                else {
                    alertErrMsg(AlertMsgs.get("SAVE_ERROR").replace(new RegExp("XKEYX", "g"), d), "");
                }
            }
        }
    }
}