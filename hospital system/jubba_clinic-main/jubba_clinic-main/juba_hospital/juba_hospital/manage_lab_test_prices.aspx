<%@ Page Title="Manage Lab Test Prices" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="manage_lab_test_prices.aspx.cs" Inherits="juba_hospital.manage_lab_test_prices" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .price-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        .category-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
            cursor: pointer;
        }
        .test-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px;
            border-bottom: 1px solid #eee;
            transition: background 0.3s;
        }
        .test-row:hover {
            background: #f8f9fa;
        }
        .test-name {
            font-weight: 500;
            color: #333;
            flex: 1;
        }
        .test-display-name {
            color: #666;
            font-size: 0.9em;
            margin-left: 10px;
        }
        .price-input {
            width: 100px;
            padding: 6px 10px;
            border: 2px solid #ddd;
            border-radius: 4px;
            text-align: right;
            font-weight: 600;
            margin: 0 10px;
        }
        .price-input:focus {
            border-color: #667eea;
            outline: none;
        }
        .btn-save {
            background: #28a745;
            color: white;
            border: none;
            padding: 6px 15px;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-save:hover {
            background: #218838;
        }
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .stat-item {
            display: inline-block;
            margin-right: 30px;
        }
        .stat-value {
            font-size: 2em;
            font-weight: bold;
        }
        .stat-label {
            font-size: 0.9em;
            opacity: 0.9;
        }
        .search-box {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 1em;
        }
        .category-content {
            display: none;
            padding: 10px;
        }
        .category-content.active {
            display: block;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid" style="padding: 20px;">
        <div class="row">
            <div class="col-md-12">
                <h2 style="margin-bottom: 20px;">
                    <i class="fa fa-money"></i> Manage Lab Test Prices
                </h2>

                <!-- Statistics Card -->
                <div class="stats-card">
                    <div class="stat-item">
                        <div class="stat-label">Total Tests</div>
                        <div class="stat-value" id="totalTests">0</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-label">Active Tests</div>
                        <div class="stat-value" id="activeTests">0</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-label">Categories</div>
                        <div class="stat-value" id="totalCategories">0</div>
                    </div>
                </div>

                <!-- Search Box -->
                <input type="text" id="searchBox" class="search-box" placeholder="🔍 Search tests by name..." onkeyup="filterTests()" />

                <!-- Test Categories Container -->
                <div id="testCategoriesContainer">
                    <!-- Will be populated by JavaScript -->
                </div>

            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
    <script>
        // jQuery is now loaded, use it directly
        $(document).ready(function () {
            loadTestPrices();
        });

        function loadTestPrices() {
            $.ajax({
                type: "POST",
                url: "manage_lab_test_prices.aspx/GetTestPrices",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    displayTestPrices(response.d);
                },
                error: function (error) {
                    Swal.fire('Error', 'Failed to load test prices', 'error');
                }
            });
        }

        function displayTestPrices(tests) {
            // Group tests by category
            let categories = {};
            tests.forEach(test => {
                let category = test.test_category || 'Other';
                if (!categories[category]) {
                    categories[category] = [];
                }
                categories[category].push(test);
            });

            // Update statistics
            $('#totalTests').text(tests.length);
            $('#activeTests').text(tests.filter(t => t.is_active).length);
            $('#totalCategories').text(Object.keys(categories).length);

            // Build HTML
            let html = '';
            for (let category in categories) {
                html += buildCategorySection(category, categories[category]);
            }

            $('#testCategoriesContainer').html(html);
        }

        function buildCategorySection(category, tests) {
            let categoryId = category.replace(/[^a-zA-Z0-9]/g, '');
            let html = `
                <div class="price-card">
                    <div class="category-header" onclick="toggleCategory('${categoryId}')">
                        <h4 style="margin: 0;">
                            <i class="fa fa-folder-open"></i> ${category} 
                            <span style="float: right;">(${tests.length} tests)</span>
                        </h4>
                    </div>
                    <div id="${categoryId}" class="category-content active">
            `;

            tests.forEach(test => {
                html += `
                    <div class="test-row" data-test-name="${test.test_name.toLowerCase()}">
                        <div style="flex: 1;">
                            <span class="test-name">${test.test_name}</span>
                            <span class="test-display-name">${test.test_display_name}</span>
                        </div>
                        <div>
                            <span style="color: #666; margin-right: 10px;">$</span>
                            <input type="number" 
                                   class="price-input" 
                                   value="${test.test_price}" 
                                   step="0.01"
                                   min="0"
                                   id="price_${test.test_price_id}"
                                   onchange="markAsChanged(${test.test_price_id})" />
                            <button class="btn-save" id="btn_${test.test_price_id}" 
                                    onclick="updatePrice(${test.test_price_id}, '${test.test_name}')" 
                                    style="display:none;">
                                <i class="fa fa-save"></i> Save
                            </button>
                        </div>
                    </div>
                `;
            });

            html += `
                    </div>
                </div>
            `;

            return html;
        }

        function toggleCategory(categoryId) {
            $('#' + categoryId).toggleClass('active');
        }

        function markAsChanged(testId) {
            $('#btn_' + testId).show();
        }

        function updatePrice(testPriceId, testName) {
            let newPrice = parseFloat($('#price_' + testPriceId).val());
            
            if (isNaN(newPrice) || newPrice < 0) {
                Swal.fire('Invalid Price', 'Please enter a valid price', 'warning');
                return;
            }

            $.ajax({
                type: "POST",
                url: "manage_lab_test_prices.aspx/UpdateTestPrice",
                data: JSON.stringify({ 
                    testPriceId: testPriceId, 
                    newPrice: newPrice 
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        $('#btn_' + testPriceId).hide();
                        Swal.fire({
                            icon: 'success',
                            title: 'Updated!',
                            text: testName + ' price updated to $' + newPrice.toFixed(2),
                            timer: 2000,
                            showConfirmButton: false
                        });
                    } else {
                        Swal.fire('Error', response.d, 'error');
                    }
                },
                error: function (error) {
                    Swal.fire('Error', 'Failed to update price', 'error');
                }
            });
        }

        function filterTests() {
            let searchTerm = $('#searchBox').val().toLowerCase();
            $('.test-row').each(function () {
                let testName = $(this).data('test-name');
                if (testName.includes(searchTerm)) {
                    $(this).show();
                } else {
                    $(this).hide();
                }
            });
        }
    </script>
</asp:Content>
