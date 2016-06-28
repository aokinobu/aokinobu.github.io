---
title: spring boot secured page testing
subtitle: spring
layout: post
date: 2016-06-28
category: 
  - spring
description: Spring secured page web testing properly with csrf
published: true
---
This was a bit of a puzzle, I decided to clean up the test cases run for [the glycan repository](https://glytoucan.org) (spring cleaning?).  Only to find that I had taken shortcuts when originally creating them by turning off all security settings.  After reverting the settings, the controller test cases would break with security faults (redirection to login, csrf parameters).

After spending some time researching (googling) the issue, I found myself looking at [Spring source code](https://github.com/spring-projects/spring-security/blob/master/test/src/test/java/org/springframework/security/test/web/servlet/request/SecurityMockMvcRequestPostProcessorsCsrfTests.java) which was like reaching daybreak.

In particular, the application of spring security into the context before each test case:
```
	@Before
public void setup() {
  // @formatter:off
  this.mockMvc = MockMvcBuilders
    .webAppContextSetup(this.wac)
    .apply(springSecurity())
    .build();
  // @formatter:on
}
```

and this little cute static method that throws in your CSRF parameters properly:

```
		this.mockMvc.perform(post("/").with(csrf()))
```

I needed one more step, however, which is adding a user into the request, so I found another cute static method:

```
    post("/").with(csrf()).with(user("test")).
```

This created a dummy user to pass authentication, and also the proper csrf parameters!  Just wanted to share a nice, elegant answer to complex problems.
