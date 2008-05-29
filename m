From: akpm@linux-foundation.org
Subject: + parisc-fix-incomplete-header-guard.patch added to -mm tree
Date: Thu, 29 May 2008 00:32:48 -0700
Message-ID: <200805290732.m4T7Wmd6022644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751609AbYE2HdY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 May 2008 03:33:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vegard.nossum@gmail.com, kyle@mcmartin.ca, matthew@wil.cx


The patch titled
     parisc: fix incomplete header guard
has been added to the -mm tree.  Its filename is
     parisc-fix-incomplete-header-guard.patch

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
Subject: parisc: fix incomplete header guard
From: Vegard Nossum <vegard.nossum@gmail.com>

Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-parisc/psw.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-parisc/psw.h~parisc-fix-incomplete-header-guard include/asm-parisc/psw.h
--- a/include/asm-parisc/psw.h~parisc-fix-incomplete-header-guard
+++ a/include/asm-parisc/psw.h
@@ -1,5 +1,5 @@
 #ifndef _PARISC_PSW_H
