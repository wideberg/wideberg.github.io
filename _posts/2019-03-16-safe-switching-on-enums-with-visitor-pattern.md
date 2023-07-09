---
layout: post
title:  "Safe switching on Enums with the Visitor Pattern"
date:   2019-03-16
categories:
tags:
published: true
---

A common pattern in many code bases is the use of switch-statements for enums.

```java
enum Language {
    CPLUSPLUS,
    RUST,
    JAVASCRIPT,
}

String getOpinion(Language language){
  switch(language){
    case CPLUSPLUS:
      return "oh, it's like Java but harder";
    case RUST:
      return "difficult to compile, but when it does, it runs without crashing";
    case JAVASCRIPT:
      return "whenever I prefer to get my errors at runtime instead of compile time...";
    default:
      throw new RuntimeException();
  }
}
```

In a language with polymorphism this is not a good way of handling conditionals. It is essentially the same as if-else-switching on class type to decide on what to do:

```java
String start(Vehicle v){
  if(v instanceof Car){
    return "start engine";
  } else if(v instanteof Bicycle){
    return "start pedaling";
  } else if(v instanceof SailBoat){
    return "set sail";
  }
}
```

The problems with both scenarios is that the conditional logic gets spread out across the code base. In some cases, that might not be a problem, but imagine having 100 occurrances around the code base. Then suddenly, a new enum type is added and the code needs to be updated in 100 different places. If you forget one, there will not be any compile-time errors. Instead, you'll get a runtime error when you least expect it. Most likely in production.

Enter the [Visitor Pattern][visitor-pattern]:

```java
enum Language {
  CPLUSPLUS(Visitor::cplusplus),
  RUST(Visitor::rust),
  JAVASCRIPT(Visitor::javascript)
  ;

  private final Function<Visitor<?>, ? > acceptMethod;

  Language(Function<Visitor<?>, ?> acceptMethod){
      this.acceptMethod = acceptMethod;
  }

  interface Visitor<T> {
      T cplusplus();
      T rust();
      T javascript();
  }

  <T> T accept(Visitor<T> visitor) {
      return (T)this.acceptMethod.apply(visitor);
  }
}
```

and this is how to use it

```java
String getOpition2(Language language){
  return language.accept(new Language.Visitor<String>() {
    @Override
    public String cplusplus() {
        return "oh, it's like Java but harder";
    }

    @Override
    public String rust() {
      return "difficult to compile, but when it does, it runs without crashing";
    }

    @Override
    public String javascript() {
        return "whenever I prefer to get my errors at runtime instead of compile time...";
    }
  });
}

```

This is slighly more verbose but with the huge advantage that you have yourself a fail-fast solution that will give a compile error every time you forget to implement a case.

[visitor-pattern]: https://en.wikipedia.org/wiki/Visitor_pattern#Java_example]
