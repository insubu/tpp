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

function findMatchingString(inputStr, { digitArray, otherArray, validArray }) {
  const trimmed = inputStr.trim();
  if (trimmed === "") return [];

  const firstChar = trimmed.charAt(0);
  const lastChar = trimmed.charAt(trimmed.length - 1);
  const inputLength = trimmed.length;

  // Determine which array to search
  let targetArray;
  if (/\d/.test(firstChar)) {
    targetArray = digitArray;
  } else if (!/[a-zA-Z]/.test(firstChar)) {
    targetArray = otherArray;
  } else {
    targetArray = validArray;
  }

  // Perform search in the chosen array
  return targetArray.filter(item =>
    item.firstChar === firstChar &&
    item.lastChar === lastChar &&
    item.stringLength === inputLength
  );
}


function diffDigitArrays(arrayA, arrayB) {
  const toKey = item => `${item.firstChar}-${item.lastChar}-${item.stringLength}`;
  const setB = new Set(arrayB.map(toKey));

  return arrayA.filter(item => !setB.has(toKey(item)));
}
