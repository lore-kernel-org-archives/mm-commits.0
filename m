From: akpm@linux-foundation.org
Subject: + h8300-fix-typo-in-header-guard.patch added to -mm tree
Date: Wed, 28 May 2008 17:30:38 -0700
Message-ID: <200805290030.m4T0Ucch008069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479AbYE2Aa7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 20:30:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vegard.nossum@gmail.com, ysato@users.sourceforge.jp


The patch titled
     h8300: fix typo in header guard
has been added to the -mm tree.  Its filename is
     h8300-fix-typo-in-header-guard.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: h8300: fix typo in header guard
From: Vegard Nossum <vegard.nossum@gmail.com>

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-h8300/cacheflush.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-h8300/cacheflush.h~h8300-fix-typo-in-header-guard include/asm-h8300/cacheflush.h
--- a/include/asm-h8300/cacheflush.h~h8300-fix-typo-in-header-guard
+++ a/include/asm-h8300/cacheflush.h
@@ -3,7 +3,7 @@
  */
 
 #ifndef _ASM_H8300_CACHEFLUSH_H
-#define _AMS_H8300_CACHEFLUSH_H
+#define _ASM_H8300_CACHEFLUSH_H
 
 /*
  * Cache handling functions
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

mn10300-fix-typo-in-header-guard.patch
h8300-fix-typo-in-header-guard.patch
v850-fix-typo-in-header-guard.patch
kallsyms-fix-potential-overflow-in-binary-search.patch

