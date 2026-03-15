const STORAGE_KEY = "admob_banner_dismissed";

function updateLayout() {
    const wrapper = document.getElementById('announcement-wrapper');
    const announce = document.querySelector('[data-md-component="announce"]');

    // Check if banner is dismissed
    if (localStorage.getItem(STORAGE_KEY) === "true") {
        if (wrapper) wrapper.style.display = "none";
        document.documentElement.style.setProperty('--banner-height', '0px');
        return;
    }

    if (wrapper && announce) {
        const height = announce.offsetHeight;
        document.documentElement.style.setProperty('--banner-height', height + 'px');

        // Add close listener
        const closeBtn = document.getElementById('announcement-close');
        if (closeBtn && !closeBtn.dataset.listenerAdded) {
            closeBtn.dataset.listenerAdded = "true";
            closeBtn.onclick = () => {
                announce.classList.add('banner-dismissed');
                document.documentElement.style.setProperty('--banner-height', '0px');
                localStorage.setItem(STORAGE_KEY, "true");
            };
        }
    } else {
        document.documentElement.style.setProperty('--banner-height', '0px');
    }
}

// Initial setup
updateLayout();
window.addEventListener("resize", updateLayout);

// MKDocs Instant Navigation
if (typeof location$ !== "undefined") {
    location$.subscribe(() => {
        setTimeout(updateLayout, 50);
    });
}
