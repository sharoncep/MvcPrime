$(document).ready(function () {
    setDatePickerFromTo("DateFrom", false, "DateTo", false);
    showChartAgent('Agent');
});

function fcSearchSub() {
    showChartAgent('Agent');

    return false;
}