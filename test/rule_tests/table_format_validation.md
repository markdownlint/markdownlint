# Table Format Validation

## Undetected tables (Kramdown Limitations)

| This empty but correctly formatted table won't be detected by Kramdown |
| ------------ |

| This empty and wrongly formatted table won't be detected at all |
| -- |

If there is a non-empty line just above the table, it won't be detected
| Heading 1 | Heading 2 | Heading 3 |
| --------- | ::::::::::| :-------- |
| Data      | Data      | Data      |

.
|my undetected table|my undetected table because of the dot above|
|----|-----::::|
|row|row|

|one column heading|
| ::----------------:: |

Funnily, above table is not picked up by Kramdown. So, its errors are not detected.

|table not detected|
```codeblock
```

## Good Tables

| A Good Table | A Good Table |
| :------------ | :------------: |
|  Col 1    | Col 2 |

| A Good Table | A Good Table |
| :---: | ------------: |
|  Col 1    | Col 2 |

| A Good Table | Col 2 |
|  :------:  | ----|
| Row 1, Col 1 | Row 1, Col 2|

| At least three dashes in second row |
| --- |
| Data |

| Heading 1 | Heading 2 | Heading 3 |
| --------- | :--------:| :-------- |
| Data      | Data      | Data      |
| Data      | Data      | Data      |
| Data      | Data      | Data      |
| Data      | Data      | Data      |
| Data      | Data      | Data      |
| Data      | Data      | Data      |
| Data      | Data      | Data      |

| Second row is correct | Col 2 |
|  :------:  | ----|
| Row 1, Col 1 | Row 1, Col 2|

| Good Table |
|------------|
|    Data    |

## Table rows start or end with space

 | Header shouldn't start with space | Column |
| --- | --- |
| Data | Row shouldn't end with space | 

| Rows shouldn't start or end with space | Column |
   | --- | --- |
   | Data | Data |

{MD055:68}
{MD055:70}
{MD055:73}{MD057:73}
{MD055:74}

## Table rows have wrong number of columns

| Table with row 1 having wrong number of columns |
|:--------:|
| Col 1 | Col 2 |

| Table row entry 2 has wrong number of columns | Header Col |
|:--------:|-----|
| Col 1 | Col 2 |
| Col 1 | Col 2| Col 3|

|table|table|
|-----|-----|
|row|row|row|row|row|

{MD056:85}
{MD056:90}
{MD056:94}

## Rows do not start or end with pipe character

Heading does not start with pipe | Column |
|-----|-----|
|Data|Data|

|Heading does not end with pipe | Column
|-----|-----|
|Data|Data|

|Second row does not have pipes at the start and the end  | Column |
-----|-----
|Data|Data|

|table2|table2|
|-----|-----|
|row|row

|table2|table2|
|-----|-----|
row|row|

|table2|table2|
|-----|-----|
row|row

{MD055:102}
{MD055:106}
{MD055:111}{MD057:111}
{MD055:116}
{MD055:120}
{MD055:124}

## Second row has less than three dashes in some column

| Second row columns must have at least three dashes | Header Col | Header Col|
| ------ | -- | ------ |
| Col 1 | Col 2 | Col 3 |

| Second row columns must have at least three dashes | Header Col | Header Col|
| ------ | :--: | ------ |
| Col 1 | Col 2 | Col 3 |

| Second row columns must have at least three dashes | Header Col | Header Col|
| ------ | | ------ |
| Col 1 | Col 2 | Col 3 |

{MD057:136}
{MD057:140}
{MD057:144}

## Second row has wrong use of colons

| Heading 1 | Heading 2 | Heading 3 |
| --------- | :::::---:::::| :-------- |
| Data      | Data      | Data      |

| Second row column two has wrong format | Header Col | Header Col|
| ------ | ----:: | ------ |
| Col 1 | Col 2 | Col 3 |

{MD057:154}
{MD057:158}

## Second row has invalid characters

|   tab    |    tab    |
| ---aa--- | ----bb----|
| row 1 | row 1 |

{MD057:167}

## Second row has space inbetween dashes and/or colons

| Second row column one has wrong format | Header Col | Header Col|
| -- - - -- | :----: | ------ |
| Col 1 | Col 2 | Col 3 |

| Second row column one has wrong format | Header Col | Header Col|
| ------ | : ---- : | ------ |
| Col 1 | Col 2 | Col 3 |

{MD057:175}
{MD057:179}

## Edge Cases

Interestingly, the following empty table is picked up by Kramdown,
and the next line is reported by the script because it does not
conform to the rules of the second row

||

Another wrong table, but it's get detected by Kramdown. This time,
both this line and the next line is reported.

|

This weird line is also a table detected by Kramdown |

|||||

{MD057:192}
{MD055:196}
{MD057:197}
{MD055:198}
{MD057:199}
{MD057:201}

## Table with only heading

|one column heading, second row does not exist|

|two column heading|the next line is reported|

{MD057:212}
{MD057:214}

## Not a table

    | Not a table because 4 spaces start a code block |
| ---- |
| Data |

```Ruby
  | Not a table becase it's a code block| Column |
  | ---- | --- |
  | | | | | | |
```

## Table inside heading

### |This is not a table|

## No second row exists because it's a code block

|table|
    |--------|
|this line is in code block|another column won't be a problem|

|table|
```|------|```
|this line isn't in code block, but it's not detected as table as well|col|
|----|not detected|
|data|not detected|

{MD057:237}
{MD057:241}
