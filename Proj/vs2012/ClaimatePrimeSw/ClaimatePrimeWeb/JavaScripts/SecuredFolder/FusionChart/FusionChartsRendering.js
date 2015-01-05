$(document).ready(function () {
});

function fusionChartRender() {
    var currentRenderer = "";

    if (FlashDetect.installed) {
        currentRenderer = "flash";
    }
    else {
        currentRenderer = "javascript";
    }

    // Tmp Lines -- Starts

    //    currentRenderer = "flash";          // Uncomment this line based on testing type
    //    currentRenderer = "javascript";     // Uncomment this line based on testing type

    //    alert(currentRenderer);

    // Tmp Lines -- Ends

    FusionCharts.setCurrentRenderer(currentRenderer);
}