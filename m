From: akpm@linux-foundation.org
Subject: + linkage-remove-unused-noret_and-macro.patch added to -mm tree
Date: Thu, 10 Nov 2011 14:37:42 -0800
Message-ID: <201111102237.pAAMbggH018002@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:63869 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab1KJWpg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Nov 2011 17:45:36 -0500
Received: by faas12 with SMTP id s12so82558faa.1
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2011 14:45:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     Subject: include/linux/linkage.h: remove unused NORET_AND macro
has been added to the -mm tree.  Its filename is
     linkage-remove-unused-noret_and-macro.patch

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
Subject: include/linux/linkage.h: remove unused NORET_AND macro

The only use in kernel.h is gone so remove the macro.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/linkage.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/linkage.h~linkage-remove-unused-noret_and-macro include/linux/linkage.h
--- a/include/linux/linkage.h~linkage-remove-unused-noret_and-macro
+++ a/include/linux/linkage.h
@@ -90,6 +90,5 @@
 
 #define NORET_TYPE    /**/
 #define ATTRIB_NORET  __attribute__((noreturn))
-#define NORET_AND     noreturn,
 
 #endif
_
Subject: Subject: include/linux/linkage.h: remove unused NORET_AND macro

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-staging-cx25821-add-l-linux-media.patch
kernelh-neaten-panic-prototype.patch
linkage-remove-unused-noret_and-macro.patch
treewide-remove-useless-noret_type-macro-and-uses.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
linkage-remove-unused-attrib_noret-macro.patch
checkpatch-update-signature-might-be-better-as-warning.patch

