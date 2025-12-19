/**
 * Responsive & Mobile-Friendly JavaScript
 * Jubba Hospital Management System
 */

(function () {
    'use strict';

    // ============================================
    // 1. MOBILE MENU TOGGLE
    // ============================================
    function initMobileMenu() {
        // Create mobile menu toggle button if it doesn't exist
        if (!document.querySelector('.mobile-menu-toggle')) {
            const toggleBtn = document.createElement('button');
            toggleBtn.className = 'mobile-menu-toggle';
            toggleBtn.innerHTML = '<i class="fas fa-bars"></i>';
            toggleBtn.setAttribute('aria-label', 'Toggle navigation menu');
            document.body.appendChild(toggleBtn);
        }

        // Create sidebar overlay if it doesn't exist
        if (!document.querySelector('.sidebar-overlay')) {
            const overlay = document.createElement('div');
            overlay.className = 'sidebar-overlay';
            document.body.appendChild(overlay);
        }

        const toggleBtn = document.querySelector('.mobile-menu-toggle');
        const sidebar = document.querySelector('.sidebar');
        const overlay = document.querySelector('.sidebar-overlay');

        if (toggleBtn && sidebar) {
            // Toggle sidebar on button click
            toggleBtn.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                sidebar.classList.toggle('active');
                overlay.classList.toggle('active');

                // Update icon
                const icon = toggleBtn.querySelector('i');
                if (sidebar.classList.contains('active')) {
                    icon.className = 'fas fa-times';
                } else {
                    icon.className = 'fas fa-bars';
                }
            });

            // Close sidebar when clicking overlay
            overlay.addEventListener('click', function () {
                sidebar.classList.remove('active');
                overlay.classList.remove('active');
                const icon = toggleBtn.querySelector('i');
                icon.className = 'fas fa-bars';
            });

            // Close sidebar when clicking a link (mobile only)
            if (window.innerWidth <= 991) {
                const sidebarLinks = sidebar.querySelectorAll('a');
                sidebarLinks.forEach(link => {
                    link.addEventListener('click', function () {
                        if (window.innerWidth <= 991) {
                            sidebar.classList.remove('active');
                            overlay.classList.remove('active');
                            const icon = toggleBtn.querySelector('i');
                            icon.className = 'fas fa-bars';
                        }
                    });
                });
            }
        }
    }

    // ============================================
    // 2. RESPONSIVE TABLES
    // ============================================
    function initResponsiveTables() {
        const tables = document.querySelectorAll('table:not(.dataTable)');

        tables.forEach(table => {
            // Wrap table in responsive container if not already wrapped
            if (!table.parentElement.classList.contains('table-responsive')) {
                const wrapper = document.createElement('div');
                wrapper.className = 'table-responsive';
                table.parentNode.insertBefore(wrapper, table);
                wrapper.appendChild(table);
            }

            // Add data-label attributes for mobile card view
            if (window.innerWidth <= 768) {
                const headers = table.querySelectorAll('thead th');
                const rows = table.querySelectorAll('tbody tr');

                rows.forEach(row => {
                    const cells = row.querySelectorAll('td');
                    cells.forEach((cell, index) => {
                        if (headers[index]) {
                            cell.setAttribute('data-label', headers[index].textContent);
                        }
                    });
                });
            }
        });
    }

    // ============================================
    // 3. TOUCH-FRIENDLY ENHANCEMENTS
    // ============================================
    function initTouchEnhancements() {
        // Add touch class to body for touch devices
        if ('ontouchstart' in window || navigator.maxTouchPoints > 0) {
            document.body.classList.add('touch-device');
        }

        // Prevent double-tap zoom on buttons
        const buttons = document.querySelectorAll('button, .btn, a');
        buttons.forEach(button => {
            button.addEventListener('touchend', function (e) {
                e.preventDefault();
                this.click();
            }, { passive: false });
        });
    }

    // ============================================
    // 4. VIEWPORT HEIGHT FIX (Mobile browsers)
    // ============================================
    function setViewportHeight() {
        // Fix for mobile browsers where 100vh includes address bar
        const vh = window.innerHeight * 0.01;
        document.documentElement.style.setProperty('--vh', `${vh}px`);
    }

    // ============================================
    // 5. RESPONSIVE FORM ENHANCEMENTS
    // ============================================
    function initResponsiveForms() {
        // Auto-focus on first input when modal opens
        const modals = document.querySelectorAll('.modal');
        modals.forEach(modal => {
            modal.addEventListener('shown.bs.modal', function () {
                const firstInput = this.querySelector('input:not([type="hidden"]), textarea, select');
                if (firstInput && window.innerWidth > 768) {
                    firstInput.focus();
                }
            });
        });

        // Prevent zoom on input focus for iOS
        if (/iPad|iPhone|iPod/.test(navigator.userAgent)) {
            const inputs = document.querySelectorAll('input, select, textarea');
            inputs.forEach(input => {
                if (input.style.fontSize < '16px') {
                    input.style.fontSize = '16px';
                }
            });
        }
    }

    // ============================================
    // 6. SMOOTH SCROLL TO TOP
    // ============================================
    function initScrollToTop() {
        // Create scroll to top button if it doesn't exist
        if (!document.querySelector('.scroll-to-top')) {
            const scrollBtn = document.createElement('button');
            scrollBtn.className = 'scroll-to-top';
            scrollBtn.innerHTML = '<i class="fas fa-arrow-up"></i>';
            scrollBtn.setAttribute('aria-label', 'Scroll to top');
            scrollBtn.style.cssText = `
                position: fixed;
                bottom: 20px;
                right: 20px;
                width: 50px;
                height: 50px;
                border-radius: 50%;
                background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
                color: white;
                border: none;
                cursor: pointer;
                display: none;
                align-items: center;
                justify-content: center;
                z-index: 1000;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                transition: all 0.3s ease;
            `;
            document.body.appendChild(scrollBtn);

            // Show/hide button based on scroll position
            window.addEventListener('scroll', function () {
                if (window.pageYOffset > 300) {
                    scrollBtn.style.display = 'flex';
                } else {
                    scrollBtn.style.display = 'none';
                }
            });

            // Scroll to top on click
            scrollBtn.addEventListener('click', function () {
                window.scrollTo({
                    top: 0,
                    behavior: 'smooth'
                });
            });

            // Hover effect
            scrollBtn.addEventListener('mouseenter', function () {
                this.style.transform = 'scale(1.1)';
            });

            scrollBtn.addEventListener('mouseleave', function () {
                this.style.transform = 'scale(1)';
            });
        }
    }

    // ============================================
    // 7. RESPONSIVE NAVIGATION COLLAPSE
    // ============================================
    function initResponsiveNavigation() {
        const navItems = document.querySelectorAll('.nav-item');

        navItems.forEach(item => {
            const link = item.querySelector('a[data-bs-toggle="collapse"]');
            if (link) {
                link.addEventListener('click', function (e) {
                    // On mobile, ensure only one submenu is open at a time
                    if (window.innerWidth <= 991) {
                        const allCollapses = document.querySelectorAll('.nav-collapse.show');
                        const targetId = this.getAttribute('href');

                        allCollapses.forEach(collapse => {
                            if (collapse.id !== targetId.substring(1)) {
                                const bsCollapse = bootstrap.Collapse.getInstance(collapse);
                                if (bsCollapse) {
                                    bsCollapse.hide();
                                }
                            }
                        });
                    }
                });
            }
        });
    }

    // ============================================
    // 8. RESPONSIVE DATATABLES
    // ============================================
    function initResponsiveDataTables() {
        // Check if DataTables is loaded
        if (typeof $.fn.dataTable !== 'undefined') {
            // Configure default responsive settings
            $.extend(true, $.fn.dataTable.defaults, {
                responsive: {
                    details: {
                        type: 'inline',
                        display: $.fn.dataTable.Responsive.display.childRowImmediate,
                        renderer: function (api, rowIdx, columns) {
                            var data = $.map(columns, function (col, i) {
                                return col.hidden ?
                                    '<tr data-dt-row="' + col.rowIndex + '" data-dt-column="' + col.columnIndex + '">' +
                                    '<td><strong>' + col.title + ':</strong></td> ' +
                                    '<td>' + col.data + '</td>' +
                                    '</tr>' :
                                    '';
                            }).join('');

                            return data ? $('<table/>').append(data) : false;
                        }
                    }
                },
                pageLength: window.innerWidth <= 768 ? 10 : 25,
                lengthMenu: window.innerWidth <= 768 ?
                    [[5, 10, 25], [5, 10, 25]] :
                    [[10, 25, 50, 100], [10, 25, 50, 100]],
                language: {
                    search: window.innerWidth <= 768 ? "Search:" : "Search:",
                    lengthMenu: window.innerWidth <= 768 ? "Show _MENU_" : "Show _MENU_ entries",
                    info: window.innerWidth <= 768 ? "_START_-_END_ of _TOTAL_" : "Showing _START_ to _END_ of _TOTAL_ entries",
                    infoEmpty: "No entries",
                    infoFiltered: window.innerWidth <= 768 ? "(filtered)" : "(filtered from _MAX_ total entries)",
                    paginate: {
                        first: window.innerWidth <= 768 ? "«" : "First",
                        last: window.innerWidth <= 768 ? "»" : "Last",
                        next: window.innerWidth <= 768 ? "›" : "Next",
                        previous: window.innerWidth <= 768 ? "‹" : "Previous"
                    }
                }
            });

            // Initialize or reinitialize DataTables
            $('.dataTable').each(function () {
                if ($.fn.DataTable.isDataTable(this)) {
                    const table = $(this).DataTable();

                    // Update responsive settings
                    if (window.innerWidth <= 768) {
                        $(this).addClass('table-mobile-card');

                        // Adjust page length for mobile
                        table.page.len(10).draw();
                    } else {
                        $(this).removeClass('table-mobile-card');
                    }

                    // Recalculate column widths
                    table.columns.adjust().responsive.recalc();
                } else {
                    // Initialize new DataTable with responsive settings
                    if (window.innerWidth <= 768) {
                        $(this).addClass('table-mobile-card');
                    }
                }
            });

            // Add responsive class to DataTables wrapper
            $('.dataTables_wrapper').each(function () {
                if (!$(this).hasClass('dt-responsive')) {
                    $(this).addClass('dt-responsive');
                }
            });
        }
    }

    // ============================================
    // 9. ORIENTATION CHANGE HANDLER
    // ============================================
    function handleOrientationChange() {
        window.addEventListener('orientationchange', function () {
            // Recalculate viewport height
            setViewportHeight();

            // Reinitialize responsive tables
            setTimeout(function () {
                initResponsiveTables();
                initResponsiveDataTables();
            }, 300);
        });
    }

    // ============================================
    // 10. RESIZE HANDLER (Debounced)
    // ============================================
    function debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }

    const handleResize = debounce(function () {
        setViewportHeight();
        initResponsiveTables();
        initResponsiveDataTables();

        // Close mobile menu if window is resized to desktop
        if (window.innerWidth > 991) {
            const sidebar = document.querySelector('.sidebar');
            const overlay = document.querySelector('.sidebar-overlay');
            const toggleBtn = document.querySelector('.mobile-menu-toggle');

            if (sidebar) sidebar.classList.remove('active');
            if (overlay) overlay.classList.remove('active');
            if (toggleBtn) {
                const icon = toggleBtn.querySelector('i');
                if (icon) icon.className = 'fas fa-bars';
            }
        }
    }, 250);

    window.addEventListener('resize', handleResize);

    // ============================================
    // 11. PREVENT HORIZONTAL SCROLL
    // ============================================
    function preventHorizontalScroll() {
        // Check for elements causing horizontal scroll
        const body = document.body;
        const html = document.documentElement;

        const checkOverflow = () => {
            const hasHorizontalScrollbar = body.scrollWidth > window.innerWidth;
            if (hasHorizontalScrollbar) {
                console.warn('Horizontal scroll detected. Check for elements wider than viewport.');
            }
        };

        // Check on load and resize
        checkOverflow();
        window.addEventListener('resize', debounce(checkOverflow, 500));
    }

    // ============================================
    // 12. LOADING ANIMATION
    // ============================================
    function initLoadingAnimation() {
        // Add fade-in class to main content
        const mainContent = document.querySelector('.page-inner, .container, .main-panel');
        if (mainContent) {
            mainContent.classList.add('fade-in');
        }
    }

    // ============================================
    // 13. INITIALIZE ALL FUNCTIONS
    // ============================================
    function init() {
        // Wait for DOM to be ready
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', function () {
                initializeResponsiveFeatures();
            });
        } else {
            initializeResponsiveFeatures();
        }
    }

    function initializeResponsiveFeatures() {
        console.log('Initializing responsive features...');

        setViewportHeight();
        initMobileMenu();
        initResponsiveTables();
        initTouchEnhancements();
        initResponsiveForms();
        initScrollToTop();
        initResponsiveNavigation();
        initResponsiveDataTables();
        handleOrientationChange();
        preventHorizontalScroll();
        initLoadingAnimation();

        console.log('Responsive features initialized successfully!');
    }

    // Start initialization
    init();

    // ============================================
    // 14. EXPOSE PUBLIC API
    // ============================================
    window.ResponsiveHelper = {
        reinitTables: initResponsiveTables,
        reinitDataTables: initResponsiveDataTables,
        setViewportHeight: setViewportHeight,
        closeMobileMenu: function () {
            const sidebar = document.querySelector('.sidebar');
            const overlay = document.querySelector('.sidebar-overlay');
            const toggleBtn = document.querySelector('.mobile-menu-toggle');

            if (sidebar) sidebar.classList.remove('active');
            if (overlay) overlay.classList.remove('active');
            if (toggleBtn) {
                const icon = toggleBtn.querySelector('i');
                if (icon) icon.className = 'fas fa-bars';
            }
        }
    };

})();
