window.addEventListener('message', function(event) {
    const locationDisplay = document.getElementById('locationDisplay');

    function fadeIn(element) {
        element.style.opacity = 0;
        element.style.display = "block";

        setTimeout(function() {
            element.style.opacity = 1;
        }, 10);
    }

    function fadeOut(element) {
        element.style.opacity = 0;

        setTimeout(function() {
            element.style.display = "none";
        }, 500);
    }

    if (event.data.action === 'updateLocation') {
        document.getElementById('direction').textContent = `Direction: ${event.data.direction}`;
        document.getElementById('street').textContent = `Street: ${event.data.street}`;
        document.getElementById('crossing').textContent = `Crossing: ${event.data.crossing}`;
        
        fadeIn(locationDisplay);
    } else if (event.data.action === 'clearDisplay') {
        fadeOut(locationDisplay);
    }
});