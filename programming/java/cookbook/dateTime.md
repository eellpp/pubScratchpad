

Java8 introduced new java.time package that has three classes
1) LocalDate : A LocalDate instance holds a date without a time zone, in ISO-86011 calendar system. LocalDate has the default format ‘YYYY-MM-DD’ as in ‘2016-12-12’.
2) LocalTime : A LocalTime holds time in the ISO-8601 calendar system, without any date or time zone information associated with it. The format is typically – ‘HH:mm:ss’ as in ‘12:10:35’. LocalTime can be upto nanosecond precision(after the last second) with the format ‘HH:mm:ss.nnnnnnnnn’ as in ‘12:10:35.123456789’.
3) LocalDateTime : Represents a Date and Time without a time zone in the ISO-8601 format. Its typical format is ‘YYYY-MM-DDTHH:mm:ss’. (Notice the ‘T’ separating days from hours) as in ‘2016-12-12T12:10:35’. LocalDateTime can also have a nanosecond-of-the-second component like in LocalTime.

Java7 had java.util.Date

```java
LocalDate localDate = LocalDate.now();
LocalDate localDate = LocalDate.of(2016,12,01);
LocalDate todayPlus10Days=LocalDate.now().plusDays(10);

LocalTime nowMinus20Minutes=LocalTime.now().minusMinutes(20);
LocalDateTime nowPlus2Years =LocalDateTime.now().plusYears(2);

LocalDate dayOfMonth20=LocalDate.now().withDayOfMonth(20);
LocalTime minute0=LocalTime.now().withMinute(0);
LocalDateTime month10 =LocalDateTime.now().withMonth(10);

int dayOfMonth=LocalDate.now().getDayOfMonth();
```

Timestamp

```java
Instant instant = Instant.now();
long timeStampSeconds = instant.getEpochSecond();
```

#### Conversion to TimeZone with java8

```java
// the input string is in Australia Time Zone
String input = "2015-01-05 17:00";
ZoneId zone = ZoneId.of("Australia/Sydney");

DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm").withZone(zone);
ZonedDateTime utc = ZonedDateTime.parse(input, fmt).withZoneSameInstant(UTC);
// UTC time will be 6 AM
```


```java
ZoneId australia = ZoneId.of("Australia/Sydney");
String str = "2015-01-05 17:00";
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
LocalDateTime localtDateAndTime = LocalDateTime.parse(str, formatter);
ZonedDateTime dateAndTimeInSydney = ZonedDateTime.of(localtDateAndTime, australia );

System.out.println("Current date and time in a particular timezone : " + dateAndTimeInSydney);

ZonedDateTime utcDate = dateAndTimeInSydney.withZoneSameInstant(ZoneOffset.UTC);

System.out.println("Current date and time in UTC : " + utcDate);
```

