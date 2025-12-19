<%@ Page Title="" Language="C#" MasterPageFile="~/doctor.Master" AutoEventWireup="true" CodeBehind="lap_processed.aspx.cs" Inherits="juba_hospital.lap_processed" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header d-flex flex-wrap align-items-center justify-content-between">
                <div>
                    <h4 class="card-title mb-1">Processed Lab Results</h4>
                    <p class="text-muted mb-0">Review, edit, and print previously recorded lab tests.</p>
                </div>
                <div class="d-flex gap-2 align-items-center mt-3 mt-md-0 w-100 w-md-auto">
                    <input type="text" id="labSearch" class="form-control" placeholder="Search by patient or phone" />
                    <button type="button" class="btn btn-outline-secondary" onclick="loadProcessedLabs()">
                        <i class="fas fa-sync-alt"></i> Refresh
                    </button>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="labProcessedTable" class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>Patient</th>
                                <th>Phone</th>
                                <th>Doctor</th>
                                <th>Registered</th>
                                <th>Status</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div id="labEmptyState" class="text-center py-4 text-muted d-none">
                    <i class="fas fa-vials fa-2x mb-2"></i>
                    <p class="mb-0">No processed lab results were found.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="assets/js/plugin/datatables/datatables.min.js"></script>
<script src="Scripts/jquery-3.4.1.min.js"></script>
<script>
    let labTable;

    document.addEventListener('DOMContentLoaded', function () {
        labTable = $('#labProcessedTable').DataTable({
            paging: true,
            searching: false,
            info: false,
            ordering: false,
            language: {
                emptyTable: "Loading processed lab results..."
            }
        });

        loadProcessedLabs();

        $('#labSearch').on('keyup', function () {
            const value = $(this).val().toLowerCase();
            $('#labProcessedTable tbody tr').filter(function () {
                $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
            });
        });
    });

    function loadProcessedLabs() {
        labTable.clear().draw();
        $('#labEmptyState').addClass('d-none');

        $.ajax({
            url: 'lap_processed.aspx/lapprocessed',
            data: "{'search':''}",
            dataType: "json",
            type: 'POST',
            contentType: "application/json",
            success: function (response) {
                if (!response.d || !response.d.length) {
                    $('#labEmptyState').removeClass('d-none');
                    labTable.draw();
                    return;
                }

                response.d.forEach(function (item) {
                    const statusBadge = `<span class="badge bg-success">${item.status || 'lap-processed'}</span>`;
                    const actions = `
                        <div class="d-flex justify-content-end gap-2">
                            <button type="button" class="btn btn-sm btn-primary" onclick="openLabEditor('${item.prescid}')">
                                <i class="fas fa-edit"></i> Edit
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="openLabPrint('${item.prescid}')">
                                <i class="fas fa-print"></i> Print
                            </button>
                        </div>`;

                    labTable.row.add([
                        `<div>${item.full_name}</div><small class="text-muted">ID: ${item.patientid}</small>`,
                        item.phone,
                        item.doctortitle || '—',
                        item.date_registered,
                        statusBadge,
                        actions
                    ]);
                });

                labTable.draw(false);
            },
            error: function (response) {
                Swal.fire('Error', response.responseText || 'Unable to load processed labs.', 'error');
            }
        });
    }

    function openLabEditor(prescid) {
        if (!prescid) {
            Swal.fire('Info', 'Missing patient data.', 'info');
            return;
        }
        sessionStorage.setItem('labEditPrescid', prescid);
        window.location.href = 'test_details.aspx?mode=edit&prescid=' + encodeURIComponent(prescid);
    }

    function openLabPrint(prescid) {
        if (!prescid) {
            Swal.fire('Info', 'Missing patient data.', 'info');
            return;
        }
        window.open('lab_result_print.aspx?prescid=' + encodeURIComponent(prescid), '_blank');
    }
</script>
</asp:Content>

