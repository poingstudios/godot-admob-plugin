function updateBannerHeight() {
    const announce = document.querySelector('[data-md-component="announce"]');
    if (announce) {
        const height = announce.offsetHeight;
        document.documentElement.style.setProperty('--banner-height', height + 'px');
    } else {
        document.documentElement.style.setProperty('--banner-height', '0px');
    }
}

// Initial update
document.addEventListener("DOMContentLoaded", updateBannerHeight);

// Observe changes (like window resize or content changes)
window.addEventListener("resize", updateBannerHeight);

// For MkDocs Material navigation.instant, we need to re-run on page load
if (typeof location$ !== "undefined") {
    location$.subscribe(() => {
        setTimeout(updateBannerHeight, 100);
    });
}
