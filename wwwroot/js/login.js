"use strict";

/* ===========================================
   TransLedger Login
=========================================== */

document.addEventListener("DOMContentLoaded", () => {

    initializePasswordToggle();
    initializeInputEffects();
    initializeCardAnimation();
    initializeButtonEffect();

});

/* ===========================================
   PASSWORD TOGGLE
=========================================== */

function initializePasswordToggle() {

    const password = document.getElementById("password");
    const toggle = document.getElementById("togglePassword");

    if (!password || !toggle) return;

    toggle.addEventListener("click", () => {

        const icon = toggle.querySelector("i");

        if (password.type === "password") {

            password.type = "text";

            icon.classList.remove("bi-eye");
            icon.classList.add("bi-eye-slash");

        }
        else {

            password.type = "password";

            icon.classList.remove("bi-eye-slash");
            icon.classList.add("bi-eye");

        }

    });

}

/* ===========================================
   INPUT ANIMATION
=========================================== */

function initializeInputEffects() {

    const inputs = document.querySelectorAll(".form-control");

    inputs.forEach(input => {

        input.addEventListener("focus", () => {

            input.closest(".input-group")
                ?.classList.add("focused");

        });

        input.addEventListener("blur", () => {

            input.closest(".input-group")
                ?.classList.remove("focused");

        });

    });

}

/* ===========================================
   CARD ANIMATION
=========================================== */

function initializeCardAnimation() {

    const card = document.querySelector(".login-card");

    if (!card) return;

    card.animate(

        [
            {
                opacity: 0,
                transform: "translateY(30px) scale(.96)"
            },
            {
                opacity: 1,
                transform: "translateY(0) scale(1)"
            }
        ],

        {
            duration: 700,
            easing: "cubic-bezier(.22,1,.36,1)",
            fill: "forwards"
        }

    );

}

/* ===========================================
   LOGIN BUTTON
=========================================== */

function initializeButtonEffect() {

    const button = document.querySelector(".login-btn");

    if (!button) return;

    button.addEventListener("click", () => {

        if (button.disabled)
            return;

        button.disabled = true;

        const original = button.innerHTML;

        button.innerHTML =
            '<span class="spinner-border spinner-border-sm me-2"></span>Signing In...';

        setTimeout(() => {

            button.disabled = false;

            button.innerHTML = original;

        }, 1800);

    });

}

/* ===========================================
   ENTER KEY SUPPORT
=========================================== */

document.addEventListener("keydown", function (e) {

    if (e.key !== "Enter")
        return;

    const form = document.querySelector("form");

    if (form)
        form.submit();

});

/* ===========================================
   PARALLAX BACKGROUND
=========================================== */

document.addEventListener("mousemove", (e) => {

    const x = (e.clientX / window.innerWidth - 0.5) * 8;
    const y = (e.clientY / window.innerHeight - 0.5) * 8;

    document.body.style.backgroundPosition =
        `calc(50% + ${x}px) calc(50% + ${y}px)`;

});