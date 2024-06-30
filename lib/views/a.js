document.addEventListener('DOMContentLoaded', function () {
    const container = document.getElementById('container');
    const addRowButton = document.getElementById('add-row-button');
    const submitButton = document.getElementById('submit-button');
    const totalGradesElement = document.getElementById('total-grades');
    let rowCount = 0; // Initial row count (excluding headers)

    function createRow() {
        if (rowCount >= 10) {
            alert('You cannot add more than 10 rows.');
            return;
        }

        const newRow = document.createElement('div');
        newRow.className = 'row';
        newRow.innerHTML = `
			<div class="col-3"><input type="text" name="points" placeholder="Enter points" class="form-control"></div>
			<div class="col-1">
						<select name="yesNo" class="form-control">
					<option value="Yes">Yes</option>
					<option value="No">No</option>
				</select>
			</div>
					<div class="col-2"><input type="number" class="form-control" min="1" max="10" value="0" name="grading" placeholder="1-10" class="grading-input"></div>
					<div class="col-5"><input type="text" class="form-control" name="qaFeedback" placeholder="Enter QA Feedback"></div>
					<div class="col-1"><button class="remove-row-button btn btn-danger form-control">-</button></div>
		`;

        container.appendChild(newRow);
        rowCount++;

        newRow.querySelector('.remove-row-button').addEventListener('click', function () {
            newRow.remove();
            rowCount--;
            calculateTotalGrades();
        });

        newRow.querySelector('.grading-input').addEventListener('input', function () {
            calculateTotalGrades();
        });
    }

    function calculateTotalGrades() {
        let totalGrades = 0;
        const gradeInputs = container.querySelectorAll('.grading-input');

        gradeInputs.forEach(input => {
            const grade = parseInt(input.value) || 0;
            totalGrades += grade;
        });

        totalGradesElement.textContent = totalGrades;
    }

    addRowButton.addEventListener('click', createRow);

    // Create an initial row on page load
    createRow();

    submitButton.addEventListener('click', function () {
        const form = document.getElementById('qaForm');
        const rows = container.querySelectorAll('.row');
        const formData = {
            callEvaluationDate: form.querySelector('input[name="callEvaluationDate"]').value,
            QaAssignIdFk: form.querySelector('input[name="QaAssignIdFk"]').value,
            callDate: form.querySelector('input[name="callDate"]').value,
            updationDate: form.querySelector('input[name="updationDate"]').value,
            inOutbound: form.querySelector('select[name="inOutbound"]').value,
            rows: []
        };

        rows.forEach(row => {
            const rowData = {
                points: row.querySelector('input[name="points"]').value,
                yesNo: row.querySelector('select[name="yesNo"]').value,
                grading: row.querySelector('input[name="grading"]').value,
                qaFeedback: row.querySelector('input[name="qaFeedback"]').value
            };
            formData.rows.push(rowData);
        });

        // Make AJAX POST request
        fetch('/QA/addRemarks', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(formData)
        })
            .then(response => response.json())
            .then(data => {
                // Handle response from the server
                console.log(data);
            })
            .catch(error => {
                console.error('Error:', error);
            });

        $('#userDropdown').change(function () {
            var userId = $(this).val();
            $.ajax({
                url: '/QA/DetailCust',
            type: 'GET',
                data: { id: userId },
                success: function (data) {
                    console.log(data);
                    $('#customerName').text(data.CustIdFkNavigation.UserName);
                    $('#qaId').text(data.QaIdFkNavigation.UserId);
                },
                error: function () {
                    console.error('Error occurred while fetching user details.');
                }
            });
        });
    });
});