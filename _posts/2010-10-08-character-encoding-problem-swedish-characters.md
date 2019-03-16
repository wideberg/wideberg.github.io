---
layout: post
title:  "Character encoding problem for åäö"
date:   2010-10-08 01:36
categories:
tags: swedish-characters
---
*Moved this here from an eariler blog post*

Mixing up the character encodings can give hard to solve results.

- åäö encoded in ISO-8859-1 interpretated as UTF-8 = `��`
- åäö encoded in UTF-8 interpretated as ISO-8859-1 = `Ã¥Ã¤Ã¶`


The output is produced with the following code:

```java
import java.io.UnsupportedEncodingException;
public class Tester {
 public static void main(String[] argv) throws UnsupportedEncodingException{
  final String ISO = "ISO-8859-1";
  final String UTF = "UTF-8";
  
  String s = new String("åäö");


  byte[] bytes_iso = s.getBytes(ISO);
  byte[] bytes_utf = s.getBytes(UTF);


  System.out.println(s + " encoded in " + ISO + " interpretated as " + UTF + " = " + new String(bytes_iso, UTF));
  System.out.println(s + " encoded in " + UTF + " interpretated as " + ISO + " = " + new String(bytes_utf, ISO));
 }
}
```
