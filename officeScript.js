  // Helper to get ISO week number
  function getWeekNumber(date: Date): number {
    const temp = new Date(date.getTime());
    temp.setHours(0, 0, 0, 0);
    temp.setDate(temp.getDate() + 3 - ((temp.getDay() + 6) % 7));
    const week1 = new Date(temp.getFullYear(), 0, 4);
    return 1 + Math.round(((temp.getTime() - week1.getTime()) / 86400000 - 3 + ((week1.getDay() + 6) % 7)) / 7);
  }

  const sameWeek =
    date1.getFullYear() === date2.getFullYear() &&
    getWeekNumber(date1) === getWeekNumber(date2);

function main(workbook: ExcelScript.Workbook) {
  const sheet = workbook.getActiveWorksheet();

  // Define two separate ranges
  const range1 = sheet.getRange("B2:C3");
  const range2 = sheet.getRange("E5:F6");

  // Get the bounding rectangle that includes both
  const unionRange = range1.getBoundingRect(range2);

  // Get row and column counts
  const rowCount = unionRange.getRowCount();
  const colCount = unionRange.getColumnCount();

  // Iterate through each cell
  for (let row = 0; row < rowCount; row++) {
    for (let col = 0; col < colCount; col++) {
      const cell = unionRange.getCell(row, col);
      const value = cell.getValue();
      console.log(`Cell ${cell.getAddress()} = ${value}`);
    }
  }
}
