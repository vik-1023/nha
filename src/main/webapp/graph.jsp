<%-- 
    Document   : graph
    Created on : 4 Mar, 2025, 9:37:31 AM
    Author     : vikram
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account-wise Traffic Charts</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        canvas {
            max-width: 300px;
            max-height: 200px;
            margin: 5px;
        }
        .chart-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
        }
    </style>
</head>
<body>
    <h2 style="text-align: center;">Account-wise Traffic Charts</h2>
    <div class="chart-container" id="accountCharts"></div>
    <h2 style="text-align: center;">Total Traffic Chart</h2>
    <canvas id="totalTrafficChart"></canvas>

    <script>
        const accounts = 10;
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        const totalSubmit = Array(12).fill(0);
        const totalDeliver = Array(12).fill(0);

        function generateRandomData() {
            return Array.from({ length: 12 }, () => Math.floor(Math.random() * 150) + 50);
        }

        for (let i = 1; i <= accounts; i++) {
            const submitData = generateRandomData();
            const deliverData = generateRandomData();
            submitData.forEach((val, index) => totalSubmit[index] += val);
            deliverData.forEach((val, index) => totalDeliver[index] += val);
            
            const chartContainer = document.createElement('canvas');
            chartContainer.id = `chart${i}`;
            chartContainer.width = 300;
            chartContainer.height = 200;
            document.getElementById('accountCharts').appendChild(chartContainer);
            
            new Chart(chartContainer.getContext('2d'), {
                type: 'line',
                data: {
                    labels: months,
                    datasets: [
                        { label: 'Submit', data: submitData, borderColor: 'blue', fill: false },
                        { label: 'Deliver', data: deliverData, borderColor: 'green', fill: false }
                    ]
                }
            });
        }

        new Chart(document.getElementById('totalTrafficChart').getContext('2d'), {
            type: 'line',
            data: {
                labels: months,
                datasets: [
                    { label: 'Total Submit', data: totalSubmit, borderColor: 'red', fill: false },
                    { label: 'Total Deliver', data: totalDeliver, borderColor: 'purple', fill: false }
                ]
            }
        });
    </script>
</body>
</html>

