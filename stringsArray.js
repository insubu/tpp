function insertSorted(arr, item, key) {
  let i = 0;
  while (i < arr.length && arr[i][key] < item[key]) i++;
  arr.splice(i, 0, item); // Insert at the right spot
}

function classifyStrings(arr) {
  const digitArray = [];
  const otherArray = [];
  const validArray = [];

  arr.forEach((str, index) => {
    const trimmed = str.trim();
    if (trimmed === "") return;

    const firstChar = trimmed.charAt(0);
    const lastChar = trimmed.charAt(trimmed.length - 1);
    const info = {
      firstChar,
      lastChar,
      stringLength: trimmed.length,
      indexInOriginArray: index,
      fullString: trimmed // used for sorting
    };

    if (/\d/.test(firstChar)) {
      insertSorted(digitArray, info, 'fullString');
    } else if (!/[a-zA-Z]/.test(firstChar)) {
      insertSorted(otherArray, info, 'fullString');
    } else {
      insertSorted(validArray, info, 'fullString');
    }
  });

  return { digitArray, otherArray, validArray };
}

// Example
const input = [" 123abc", "!hello", " World ", "9Lives", " ", "#start", "foo"];
const result = classifyStrings(input);
console.log(result);
