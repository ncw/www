// Site JS

document.addEventListener("DOMContentLoaded", function() {
  // Add hover links on headings
  document.querySelectorAll("h2, h3, h4, h5, h6").forEach(function(el) {
    var id = el.getAttribute("id");
    if (id) {
      var a = document.createElement("a");
      a.className = "header-link";
      a.href = "#" + id;
      a.innerHTML = '<i class="fa fa-link"></i>';
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
