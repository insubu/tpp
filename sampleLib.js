<script src="https://cdn.jsdelivr.net/npm/lodash@4.17.21/lodash.min.js"></script>
<script>
  // _.chunk: Split array into chunks
  console.log(_.chunk(['a', 'b', 'c', 'd'], 2)); 
  // → [['a', 'b'], ['c', 'd']]

  // _.uniq: Remove duplicates
  console.log(_.uniq([2, 1, 2])); 
  // → [2, 1]

  // _.debounce: Limit how often a function runs
  const log = _.debounce(() => console.log('Triggered!'), 1000);
  window.addEventListener('resize', log);

  // _.cloneDeep: Deep copy of nested objects
  const obj = { a: 1, b: { c: 2 } };
  const copy = _.cloneDeep(obj);
  console.log(copy);

  // _.orderBy: Sort by multiple fields
  const users = [
    { name: 'Alice', age: 30 },
    { name: 'Bob', age: 25 },
    { name: 'Alice', age: 22 }
  ];
  console.log(_.orderBy(users, ['name', 'age'], ['asc', 'desc']));
</script>


// 当前时间
const now = dayjs();

// 格式化
console.log(now.format('YYYY-MM-DD')); // 2025-06-29

// 加减时间
console.log(now.add(7, 'day').format());     // 加7天
console.log(now.subtract(1, 'month').format()); // 减1个月

// 比较
const deadline = dayjs('2025-07-01');
console.log(now.isBefore(deadline)); // true or false

// 差值
console.log(deadline.diff(now, 'day')); // 相差几天

// 自定义日期
const birthday = dayjs('1990-01-01');
console.log(birthday.format('YYYY年M月D日')); // 1990年1月1日

<script src="https://cdn.jsdelivr.net/npm/dayjs@1/dayjs.min.js"></script>
<script>
  console.log(dayjs().format('YYYY-MM-DD HH:mm:ss'));
</script>

<script src="https://cdn.jsdelivr.net/npm/dayjs@1/plugin/isSameOrBefore.js"></script>
<script>
  dayjs.extend(dayjs_plugin_isSameOrBefore);
  console.log(dayjs('2025-06-29').isSameOrBefore('2025-07-01')); // true
</script>
