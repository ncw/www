// Site JS

document.addEventListener("DOMContentLoaded", function() {
  // Add hover links on headings
  document.querySelectorAll("h2, h3, h4, h5, h6").forEach(function(el) {
    var id = el.getAttribute("id");
    if (id) {
      var a = document.createElement("a");
      a.className = "header-link";
      a.href = "#" + id;
      a.innerHTML = '<svg class="icon" aria-hidden="true" viewBox="0 0 16 16" fill="currentColor"><path d="M4.715 6.542 3.343 7.914a3 3 0 1 0 4.243 4.243l1.828-1.829A3 3 0 0 0 8.586 5.5L8 6.086a1.002 1.002 0 0 0-.154.199 2 2 0 0 1 .861 3.337L6.88 11.45a2 2 0 1 1-2.83-2.83l.793-.792a4.018 4.018 0 0 1-.128-1.287z"/><path d="M6.586 4.672A3 3 0 0 0 7.414 9.5l.775-.776a2 2 0 0 1-.896-3.346L9.12 3.55a2 2 0 1 1 2.83 2.83l-.793.792c.112.42.155.855.128 1.287l1.372-1.372a3 3 0 1 0-4.243-4.243L6.586 4.672z"/></svg>';
      el.prepend(a);
    }
  });

  // Wire up copy to clipboard buttons
  document.querySelectorAll(".copy-to-clipboard").forEach(function(btn) {
    btn.addEventListener("click", function() {
      var copyText = btn.previousElementSibling;
      copyText.select();
      document.execCommand("copy");
      btn.title = "Copied!";
    });
  });

  // Navbar toggle
  var toggler = document.querySelector(".navbar-toggler");
  var collapse = document.getElementById("navbarSupportedContent");
  if (toggler && collapse) {
    toggler.addEventListener("click", function() {
      collapse.classList.toggle("show");
    });
  }

  // Dropdown toggle (mobile)
  document.querySelectorAll(".dropdown-toggle").forEach(function(toggle) {
    toggle.addEventListener("click", function(e) {
      if (window.innerWidth < 768) {
        e.preventDefault();
        var menu = toggle.nextElementSibling;
        if (menu && menu.classList.contains("dropdown-menu")) {
          menu.classList.toggle("show");
        }
      }
    });
  });

  // Close dropdowns when clicking outside
  document.addEventListener("click", function(e) {
    if (!e.target.closest(".dropdown")) {
      document.querySelectorAll(".dropdown-menu.show").forEach(function(menu) {
        menu.classList.remove("show");
      });
    }
  });
});
