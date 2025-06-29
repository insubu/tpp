<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Dual File Reader</title>
</head>
<body>
  <h2>Select Two Text Files</h2>

  <input type="file" id="file1"><br><br>
  <input type="file" id="file2"><br><br>
  <button onclick="readFiles()">Read & Split</button>

  <pre id="output"></pre>

  <script>
    function readFiles() {
      const fileInput1 = document.getElementById('file1').files[0];
      const fileInput2 = document.getElementById('file2').files[0];

      const output = document.getElementById('output');
      output.textContent = '';

      const readFile = file =>
        new Promise((resolve, reject) => {
          if (!file) return resolve([]);
          const reader = new FileReader();
          reader.onload = e => resolve(e.target.result.split(/\r?\n/));
          reader.onerror = reject;
          reader.readAsText(file);
        });

      Promise.all([readFile(fileInput1), readFile(fileInput2)])
        .then(([array1, array2]) => {
          output.textContent =
            `File 1:\n${JSON.stringify(array1, null, 2)}\n\nFile 2:\n${JSON.stringify(array2, null, 2)}`;
        })
        .catch(err => {
          output.textContent = 'Error reading files: ' + err;
        });
    }
  </script>
</body>
</html>
