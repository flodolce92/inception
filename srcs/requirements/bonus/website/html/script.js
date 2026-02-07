// Generate random stars
function createStars() {
    const starsContainer = document.getElementById('stars');
    const numberOfStars = 100;

    for (let i = 0; i < numberOfStars; i++) {
        const star = document.createElement('div');
        star.className = 'star';
        star.style.left = Math.random() * 100 + '%';
        star.style.top = Math.random() * 100 + '%';
        star.style.animationDelay = Math.random() * 3 + 's';
        star.style.opacity = Math.random() * 0.7 + 0.3;
        starsContainer.appendChild(star);
    }
}

// Democracy deployment function
function deployDemocracy() {
    const messages = [
        "Inizializzazione sequenza deployment...",
        "Spreading Democracy: 33%",
        "Spreading Democracy: 66%",
        "Spreading Democracy: 100%",
        "✓ DEMOCRAZIA DEPLOYED CON SUCCESSO!",
        "La Super Terra ringrazia per il tuo servizio, Helldiver!"
    ];

    let index = 0;
    const button = event.target.closest('.cta-button');
    const originalText = button.innerHTML;

    button.style.pointerEvents = 'none';

    const interval = setInterval(() => {
        if (index < messages.length) {
            button.innerHTML = `<span>${messages[index]}</span>`;
            index++;
        } else {
            clearInterval(interval);
            setTimeout(() => {
                button.innerHTML = originalText;
                button.style.pointerEvents = 'auto';
            }, 2000);
        }
    }, 800);
}

// Parallax effect on mouse move
document.addEventListener('mousemove', (e) => {
    const stars = document.querySelectorAll('.star');
    const x = e.clientX / window.innerWidth;
    const y = e.clientY / window.innerHeight;

    stars.forEach((star, index) => {
        const speed = (index % 3 + 1) * 0.5;
        const xOffset = (x - 0.5) * speed * 20;
        const yOffset = (y - 0.5) * speed * 20;
        star.style.transform = `translate(${xOffset}px, ${yOffset}px)`;
    });
});

// Stat counter animation
function animateStats() {
    const statValues = document.querySelectorAll('.stat-value');
    
    statValues.forEach((stat) => {
        const target = stat.textContent;
        const isPercentage = target.includes('%');
        const targetNumber = parseFloat(target);
        
        if (!isNaN(targetNumber)) {
            let current = 0;
            const increment = targetNumber / 50;
            const timer = setInterval(() => {
                current += increment;
                if (current >= targetNumber) {
                    stat.textContent = target;
                    clearInterval(timer);
                } else {
                    stat.textContent = Math.floor(current) + (isPercentage ? '%' : '');
                }
            }, 30);
        }
    });
}

// Initialize on load
window.addEventListener('load', () => {
    createStars();
    
    // Trigger stat animation when visible
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                animateStats();
                observer.unobserve(entry.target);
            }
        });
    });

    const statsGrid = document.querySelector('.stats-grid');
    if (statsGrid) {
        observer.observe(statsGrid);
    }
});

// Add glitch effect on title
const title = document.querySelector('h1');
setInterval(() => {
    if (Math.random() > 0.95) {
        title.style.transform = `translate(${Math.random() * 4 - 2}px, ${Math.random() * 4 - 2}px)`;
        setTimeout(() => {
            title.style.transform = 'translate(0, 0)';
        }, 50);
    }
}, 3000);
