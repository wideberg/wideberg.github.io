---
layout: post
title:  "Working with immutable business entities"
date:   2019-08-21
categories:
tags:
published: false
---

How can you actually work with immutable business entities? Isn't it just a lot more complicated going immutable than doing it the old way, with setters and getters?  It is usually necessary to alter state after all... right?!

This architecture (example) has proven itself very useful for me.

```java
@Immutable
interface Account {

  /* properties */
  UUID id();
  int revision();

  double balance();
  //...easily add more

  @Check
  default void ensurePositiveBalance(){
    if(balance < 0){
      throw new IllegalStateException("negative balance");
    }
  }

  /* actions */
  default Account withdraw(double amount){
    return ImmutableAccount.copyOf(this)
        .withRevision(revision()+1)
        .withBalance(balance - amount);
  }
}
```

### Immutables (java lib)

A key component in this solution is the use of [Immutables Java library][immutables]. It helps creating immutable classes from interfaces by generating a completely immutable implementation. The library takes care of all the boilerplate (equals/hashCode/toString, even a Builder), leaving room for me to focus only on modelling the entity and worrying about whether I've forgotten to update `equals()` correctly.
  
* Altering the model is as simple as just adding a method declaration to the interface and re-compiling

* Note the method annotated with `@Check`, it is executed everytime a new entity is created and makes it impossible to create an invalid instance

* The library works by generating code at compile time so there is no runtime overhead, no proxy/reflection, and also no runtime library dependency

[immutables]: https://immutables.github.io/

### UUID + revision as primary key

Using a UUID in combination with a revision number as primary identifier leads to the entity being immutable all the way down to the database. If we never modify data but only add, then data that has been written can be considered immutable, with several advantages:

* Simplified caching since there is no need for cache eviction
* Speeds up DB writes since there is less need for row locks
* Greatly simplifies repository implementations since there's not longer need for implementing the full CRUD. It's only necessary to implement CR (INSERT/SELECT)

Furthermore, with UUID it is always possible to generate a unique id directly from code. Comparing with the otherwise common solution of relying on an auto-incremented number from the database, this solution does not require a roundtrip to the DB just to get a unique id.

There are no race conditions with the risk of loosing information if the entity is modified simultaniously in different ways. (i.e. if there are two withdrawals of different amounts and the second write overwrites result of the first withdrawal).

If this happens, there will be a duplicate-key constraint violation in the database DB and one of the users will know that someone else updated the entity at the same time.

### Action methods should return a new instance

Since the class is immutable we must always return a new entity as a result of an action or update. The new instance must have it's revision incremented by 1 to distinguish it from other revisions.

The use of default methods might seem unusual but theres nothing more different than having method implementations on an abstract class.


### Summary

This design has helped me a lot to focus on the actual business logic instead of technical boilerplate. Hope this gives some inspiration!
