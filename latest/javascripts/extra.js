/* 🕰️ ANIMATION SYNC SYSTEM (SPA-Feel) */
// This script ensures that background animations (gradients and drift) 
// pick up exactly where they left off after an instant-navigation sync.
if (typeof document$ !== 'undefined') {
  document$.subscribe(function() {
    var now = Date.now() / 1000;
    // We use a large negative delay so the animation "started" in the past
    // This perfectly synchronizes the phase across page re-injections.
    document.documentElement.style.setProperty('--sync-clock', now);
  });
}
