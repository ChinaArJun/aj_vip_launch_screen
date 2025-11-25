document.addEventListener('DOMContentLoaded', () => {
    const splashScreen = document.getElementById('splash-screen');
    const appContainer = document.getElementById('app-container');
    const swiperWrapper = document.getElementById('swiper-wrapper');
    const slides = document.querySelectorAll('.slide');
    const bgLayers = document.querySelectorAll('.bg-layer');
    const dots = document.querySelectorAll('.dot');
    const nextBtn = document.getElementById('next-btn');
    const skipBtn = document.getElementById('skip-btn');

    let currentIndex = 0;
    const totalSlides = slides.length;
    let startX = 0;
    let currentTranslate = 0;
    let prevTranslate = 0;
    let isDragging = false;

    // Splash Screen Logic
    setTimeout(() => {
        splashScreen.classList.add('fade-out');
        appContainer.classList.remove('hidden');
        setTimeout(() => {
            appContainer.classList.add('visible');
            updateSlideState(0); // Trigger animation for first slide
        }, 100);
    }, 2500);

    // Navigation Functions
    function updateSlidePosition() {
        swiperWrapper.style.transform = `translateX(-${currentIndex * 25}%)`;
        updatePagination();
        updateBackground();
        updateSlideState(currentIndex);
    }

    function updatePagination() {
        dots.forEach((dot, index) => {
            if (index === currentIndex) {
                dot.classList.add('active');
            } else {
                dot.classList.remove('active');
            }
        });

        // Change Next Button to "Get Started" or similar on last slide?
        // For now, we keep the arrow but maybe change behavior
        if (currentIndex === totalSlides - 1) {
            // Optional: Change icon or style
        }
    }

    function updateBackground() {
        bgLayers.forEach((layer, index) => {
            if (index === currentIndex) {
                layer.classList.add('active');
            } else {
                layer.classList.remove('active');
            }
        });
    }

    function updateSlideState(index) {
        slides.forEach((slide, i) => {
            if (i === index) {
                slide.classList.add('active');
            } else {
                slide.classList.remove('active');
            }
        });
    }

    function nextSlide() {
        if (currentIndex < totalSlides - 1) {
            currentIndex++;
            updateSlidePosition();
        } else {
            // Action for final slide (e.g., go to main app)
            console.log("Onboarding Complete");
        }
    }

    function prevSlide() {
        if (currentIndex > 0) {
            currentIndex--;
            updateSlidePosition();
        }
    }

    // Event Listeners
    nextBtn.addEventListener('click', nextSlide);

    skipBtn.addEventListener('click', () => {
        // Skip to last slide (Subscription)
        currentIndex = totalSlides - 1;
        updateSlidePosition();
    });

    // Simplified Swipe Detection
    let touchStartX = 0;
    let touchEndX = 0;

    appContainer.addEventListener('touchstart', e => {
        touchStartX = e.changedTouches[0].screenX;
    }, { passive: true });

    appContainer.addEventListener('touchend', e => {
        touchEndX = e.changedTouches[0].screenX;
        handleSwipe();
    }, { passive: true });

    function handleSwipe() {
        const threshold = 50;
        if (touchEndX < touchStartX - threshold) {
            nextSlide();
        }
        if (touchEndX > touchStartX + threshold) {
            prevSlide();
        }
    }
});
