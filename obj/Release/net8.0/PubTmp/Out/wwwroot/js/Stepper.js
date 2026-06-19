function initStepper(containerId, stepNo = 1) {
    const container =
        document.getElementById(containerId);

    if (!container)
        return;

    const steppers = document.querySelectorAll(".steppers > div");

    // HEADER STEPS
    steppers.forEach((step, i) => {

        const current =
            parseInt(step.dataset.step);

        step.classList.remove("active");
        step.classList.remove("completed");

        if (current < stepNo) {
            step.classList.add("completed");
            step.querySelector('.step-icon').innerHTML = '<i class="bi bi-check-lg"></i>';
        }

        if (current === stepNo) {
            step.classList.add("active");
            step.querySelector('.step-icon').innerHTML = stepNo;
        }
    });

    // STEP VIEWS
    container.querySelectorAll(".step-view")
        .forEach(view => {

            view.classList.remove("active");

            const current =
                parseInt(view.dataset.step);

            if (current === stepNo) {
                view.classList.add("active");
            }
        });

    // STORE CURRENT STEP
    container.dataset.currentStep = stepNo;
}

function nextStep(containerId) {

    const container =
        document.getElementById(containerId);

    const current =
        parseInt(container.dataset.currentStep || 1);

    initStepper(containerId, current + 1);
}

function prevStep(containerId) {

    const container =
        document.getElementById(containerId);

    const current =
        parseInt(container.dataset.currentStep || 1);

    initStepper(containerId, current - 1);
}