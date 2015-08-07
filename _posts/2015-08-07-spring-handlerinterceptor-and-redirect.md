---
title: Spring HandlerInterceptor Redirect
subtitle: handling redirects in an interceptor
layout: post
date: 2015-08-07
category: [development]
description: adding an interceptor can interrupt redirecting attributes
---
I've created a form of a servlet filter using spring's HandlerInterceptor overriding the postHandle method.

The problem started to show up when I wanted to flash message to a redirect back as the localization filter is picky about the Request URI.  (redirects are important)

What I was finding was that the interceptor was being called twice when a "redirect:" string was returned.  This was odd because you would think it would just skip to the next request.

Salvation came when doing a search on the subject and I found [this link](http://forum.spring.io/forum/spring-projects/web/76515-handlerinterceptor-and-redirect-problem).

If you don't skip the entire process when it's a redirect (the if statement) then the flash attributes will disappear because it will be considered rendered.

<pre>
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        if(modelAndView != null && !modelAndView.getViewName().startsWith("redirect:")) {
            String userTimeZoneId = SecurityUtils.getUserTimeZoneId();
            modelAndView.getModel().put(MODEL_ATTR_NAME_TIME_ZONE_ID, userTimeZoneId != null ? userTimeZoneId : defaultTimeZoneId);
        }
    }
</pre>

I'm waiting for when there is a RedirectAttributes parameter in Interceptors to make this more intuitive.
