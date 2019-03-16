---
layout: post
title:  "There's no need to write getters and setters"
date:   2019-03-16
categories:
tags: swedish-characters
published: false
---
I don’t write getters and setters, there simpily is no need for creating them.

It has been discussed before with good arguments, however, I can make a few more, apart from the fact that they cut holes in the architecture, break encapsulation and leads to business logic residing outside the class to which it really belongs.

* First of all, if you are making immutable objects, (and you should), then there is obviously no need at all for any set-methods.

* Second, if you are in a functional paradigm, (and I usually am), then every method will by design return something and not have any side-effects, so it becomes redundant to prefix methods with “get”. It pollutes the code like smurf-notation. `Account.balance()` will obviously **_get_** the balance so there’s no need to name the method `getBalance()`.

One can argue that balance() is in fact a getter method and that might be true, however, we got rid of the "smurf notation", plus additional work can be done in that method apart from only returning a stored value:

#### Member fields stored as null internally can be converted to Optional.
```java
@Nullable private final String myValue;
Optional<String> myValue() {
  return Optional.ofNullable(myValue)
}
```

#### Defensive copying (in the case of internal members that are mutable)
```java
private final Date birthDate;
Date birthDate(){
  return new Date(birthDate);
}
```

#### The returned value might be calculated from other internal values

```java
class Account {
  private final double balance;
  private final double interest;
  double revenue(){
    return balance * interest;
  }
}
```