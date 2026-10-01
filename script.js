/**
 * CodeWithTanim: Python Bangla Master Course
 * Frontend Logic & Interactivity
 */

document.addEventListener("DOMContentLoaded", () => {
  // Elements
  const topicSearch = document.getElementById("topicSearch");
  const clearSearch = document.getElementById("clearSearch");
  const quickTags = document.querySelectorAll(".quick-tag");
  const phaseCards = document.querySelectorAll(".phase-card");
  const btnDownloadBook = document.getElementById("btnDownloadBook");
  const btnDownloadBookFinal = document.getElementById("btnDownloadBookFinal");
  const btnCopySample = document.getElementById("btnCopySample");
  const sampleCodeText = document.getElementById("sampleCodeText");
  const toastBox = document.getElementById("toastBox");
  const toastMsg = document.getElementById("toastMsg");

  // Open first 2 phase cards by default for great presentation
  if (phaseCards.length > 0) {
    phaseCards[0].classList.add("open");
    if (phaseCards.length > 1) {
      phaseCards[1].classList.add("open");
    }
  }

  /* ==========================================
     1. ACCORDION TOGGLE FUNCTION
     ========================================== */
  window.togglePhase = function(headerElement) {
    const card = headerElement.closest(".phase-card");
    if (card) {
      card.classList.toggle("open");
    }
  };

  /* ==========================================
     PROJECT TABS SWITCHER (R1-R8 vs P1-P8)
     ========================================== */
  window.switchProjectTab = function(type) {
    const tabIndustry = document.getElementById("tabIndustry");
    const tabCapstone = document.getElementById("tabCapstone");
    const industryGrid = document.getElementById("industryProjectsGrid");
    const capstoneGrid = document.getElementById("capstoneProjectsGrid");

    if (!tabIndustry || !tabCapstone || !industryGrid || !capstoneGrid) return;

    if (type === "industry") {
      tabIndustry.classList.add("active");
      tabCapstone.classList.remove("active");
      industryGrid.style.display = "block";
      capstoneGrid.style.display = "none";
    } else {
      tabCapstone.classList.add("active");
      tabIndustry.classList.remove("active");
      capstoneGrid.style.display = "block";
      industryGrid.style.display = "none";
    }
  };

  /* ==========================================
     2. SEARCH & FILTER TOPICS
     ========================================== */
  function filterTopics(query) {
    const cleanQuery = query.toLowerCase().trim();

    if (cleanQuery.length > 0) {
      clearSearch.style.display = "block";
    } else {
      clearSearch.style.display = "none";
    }

    let matchCount = 0;

    phaseCards.forEach(card => {
      const keywords = card.getAttribute("data-keywords") || "";
      const textContent = card.textContent || "";
      const combined = (keywords + " " + textContent).toLowerCase();

      if (!cleanQuery || combined.includes(cleanQuery)) {
        card.style.display = "block";
        if (cleanQuery) {
          card.classList.add("open"); // Auto expand when searching
        }
        matchCount++;
      } else {
        card.style.display = "none";
      }
    });

    return matchCount;
  }

  if (topicSearch) {
    topicSearch.addEventListener("input", (e) => {
      // Reset active state on quick tags
      quickTags.forEach(t => t.classList.remove("active"));
      filterTopics(e.target.value);
    });
  }

  if (clearSearch) {
    clearSearch.addEventListener("click", () => {
      topicSearch.value = "";
      filterTopics("");
      quickTags.forEach(t => t.classList.remove("active"));
      const allTag = document.querySelector('.quick-tag[data-filter="all"]');
      if (allTag) allTag.classList.add("active");
      topicSearch.focus();
    });
  }

  // Quick Filter Tags
  quickTags.forEach(tag => {
    tag.addEventListener("click", () => {
      quickTags.forEach(t => t.classList.remove("active"));
      tag.classList.add("active");

      const filterValue = tag.getAttribute("data-filter");
      if (filterValue === "all") {
        topicSearch.value = "";
        filterTopics("");
      } else {
        topicSearch.value = filterValue;
        filterTopics(filterValue);
      }
    });
  });

  /* ==========================================
     3. TOAST NOTIFICATION UTILITY
     ========================================== */
  let toastTimer = null;
  function showToast(message, isSuccess = true) {
    if (!toastBox) return;
    
    toastMsg.textContent = message;
    toastBox.classList.add("show");

    if (toastTimer) clearTimeout(toastTimer);
    toastTimer = setTimeout(() => {
      toastBox.classList.remove("show");
    }, 4500);
  }

  // Download Button Feedback
  function handleDownloadClick() {
    showToast("📥 CodeWithTanim Master Book ডাউনলোড শুরু হয়েছে! শুভকামনা আপনার পাইথন যাত্রার জন্য! 🚀", true);
  }

  if (btnDownloadBook) {
    btnDownloadBook.addEventListener("click", handleDownloadClick);
  }
  if (btnDownloadBookFinal) {
    btnDownloadBookFinal.addEventListener("click", handleDownloadClick);
  }

  /* ==========================================
     4. COPY CODE SNIPPET
     ========================================== */
  if (btnCopySample && sampleCodeText) {
    btnCopySample.addEventListener("click", async () => {
      const codeToCopy = sampleCodeText.innerText || sampleCodeText.textContent;
      try {
        await navigator.clipboard.writeText(codeToCopy);
        const originalHtml = btnCopySample.innerHTML;
        btnCopySample.innerHTML = '<i class="fa-solid fa-check"></i> <span>Copied!</span>';
        btnCopySample.style.background = "#10B981";
        btnCopySample.style.borderColor = "#10B981";
        btnCopySample.style.color = "#FFFFFF";

        showToast("✅ কোড সফলভাবে ক্লিপবোর্ডে কপি করা হয়েছে!", true);

        setTimeout(() => {
          btnCopySample.innerHTML = originalHtml;
          btnCopySample.style.background = "";
          btnCopySample.style.borderColor = "";
          btnCopySample.style.color = "";
        }, 2200);
      } catch (err) {
        showToast("কপি করতে সমস্যা হয়েছে, অনুগ্রহ করে ম্যানুয়ালি কপি করুন।", false);
      }
    });
  }

  /* ==========================================
     5. STAT COUNTER ANIMATION ON SCROLL
     ========================================== */
  const statNumbers = document.querySelectorAll(".stat-num");
  let animated = false;

  function runCounters() {
    statNumbers.forEach(stat => {
      const target = parseInt(stat.getAttribute("data-count"), 10);
      if (isNaN(target)) return;

      const duration = 1800; // ms
      const startTime = performance.now();

      function updateNumber(currentTime) {
        const elapsed = currentTime - startTime;
        const progress = Math.min(elapsed / duration, 1);
        
        // Easing: easeOutExpo
        const ease = progress === 1 ? 1 : 1 - Math.pow(2, -10 * progress);
        const currentCount = Math.floor(ease * target);

        if (target > 1000) {
          stat.textContent = currentCount.toLocaleString() + "+";
        } else if (target === 10) {
          stat.textContent = currentCount;
        } else {
          stat.textContent = currentCount + "+";
        }

        if (progress < 1) {
          requestAnimationFrame(updateNumber);
        } else {
          if (target > 1000) {
            stat.textContent = target.toLocaleString() + "+";
          } else if (target === 10) {
            stat.textContent = target;
          } else {
            stat.textContent = target + "+";
          }
        }
      }

      requestAnimationFrame(updateNumber);
    });
  }

  // IntersectionObserver to trigger counter when visible
  if ("IntersectionObserver" in window) {
    const observer = new IntersectionObserver((entries, obs) => {
      entries.forEach(entry => {
        if (entry.isIntersecting && !animated) {
          animated = true;
          runCounters();
          obs.disconnect();
        }
      });
    }, { threshold: 0.3 });

    const statsGrid = document.querySelector(".stats-grid");
    if (statsGrid) {
      observer.observe(statsGrid);
    }
  } else {
    runCounters();
  }

  /* ==========================================
     6. NAVBAR SCROLL EFFECT
     ========================================== */
  const topNav = document.getElementById("topNav");
  window.addEventListener("scroll", () => {
    if (window.scrollY > 40) {
      topNav.style.boxShadow = "0 8px 30px rgba(0, 0, 0, 0.7)";
      topNav.style.background = "rgba(4, 7, 17, 0.95)";
    } else {
      topNav.style.boxShadow = "none";
      topNav.style.background = "rgba(6, 10, 20, 0.85)";
    }
  });
});
