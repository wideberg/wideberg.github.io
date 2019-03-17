---
layout: post
title:  "Safe switching on Enums with the Visitor Pattern"
date:   2019-03-16
categories:
tags:
published: false
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
                return "never tried it actually";
            case JAVASCRIPT:
                return "whenever I prefer to get errors at runtime instead of compile time...";
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

The problems with both scenarios is that the conditional logic gets spread out across the code base. That might not be a huge problem in all cases but imagine having 100 occurrances around the code base. Then suddenly, a new Vehice type is added and the code needs to be updated on 100 different places. If you forget one, there will be no compile-time error and so you will not fail fast. Instead there will  but you will get an error at runtime 

In this case it is obvious that a better solution 

The code has at least one big design problem; 

The code has a few design problems