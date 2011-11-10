From: akpm@linux-foundation.org
Subject: + linkage-remove-unused-attrib_noret-macro.patch added to -mm tree
Date: Thu, 10 Nov 2011 14:38:02 -0800
Message-ID: <201111102238.pAAMc2lj032720@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:46952 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab1KJWpc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Nov 2011 17:45:32 -0500
Received: by wwe5 with SMTP id 5so7447wwe.1
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2011 14:45:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     Subject: include/linux/linkage.h: remove unused ATTRIB_NORET macro
has been added to the -mm tree.  Its filename is
     linkage-remove-unused-attrib_noret-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: include/linux/linkage.h: remove unused ATTRIB_NORET macro

The uses have been renamed so delete the unused macro.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/linkage.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/linkage.h~linkage-remove-unused-attrib_noret-macro include/linux/linkage.h
--- a/include/linux/linkage.h~linkage-remove-unused-attrib_noret-macro
+++ a/include/linux/linkage.h
@@ -88,6 +88,4 @@
 
 #endif
 
-#define ATTRIB_NORET  __attribute__((noreturn))
