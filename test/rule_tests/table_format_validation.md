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

{MD055:64}
{MD055:66}
{MD055:69}
{MD055:70}

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

{MD055:81}
{MD055:86}
{MD055:90}

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

{MD055:98}
{MD055:102}
{MD055:107}
{MD055:112}
{MD055:116}
{MD055:120}

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

{MD055:132}
{MD055:136}
{MD055:140}

## Second row has wrong use of colons

| Heading 1 | Heading 2 | Heading 3 |
| --------- | :::::---:::::| :-------- |
| Data      | Data      | Data      |

| Second row column two has wrong format | Header Col | Header Col|
| ------ | ----:: | ------ |
| Col 1 | Col 2 | Col 3 |

{MD055:150}
{MD055:154}

## Second row has invalid characters

|   tab    |    tab    |
| ---aa--- | ----bb----|
| row 1 | row 1 |

{MD055:163}

## Second row has space inbetween dashes and/or colons

| Second row column one has wrong format | Header Col | Header Col|
| -- - - -- | :----: | ------ |
| Col 1 | Col 2 | Col 3 |

| Second row column one has wrong format | Header Col | Header Col|
| ------ | : ---- : | ------ |
| Col 1 | Col 2 | Col 3 |

{MD055:171}
{MD055:175}

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

{MD055:188}
{MD055:192}
{MD055:193}
{MD055:194}
{MD055:195}
{MD055:197}

## Table with only heading

|one column heading, second row does not exist|

|two column heading|the next line is reported|

{MD055:208}
{MD055:210}

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
