From: akpm@linux-foundation.org
Subject: + binfmtsh-include-listh.patch added to -mm tree
Date: Wed, 29 Oct 2008 18:37:26 -0700
Message-ID: <200810300137.m9U1bQ8c019363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751971AbYJ3Bh3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Oct 2008 21:37:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: h-shimamoto@ct.jp.nec.com


The patch titled
     binfmts.h: include list.h
has been added to the -mm tree.  Its filename is
     binfmtsh-include-listh.patch

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
Subject: binfmts.h: include list.h
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

linux_binfmt uses list_head, so list.h is needed.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/binfmts.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/binfmts.h~binfmtsh-include-listh include/linux/binfmts.h
--- a/include/linux/binfmts.h~binfmtsh-include-listh
+++ a/include/linux/binfmts.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_BINFMTS_H
 #define _LINUX_BINFMTS_H
 
+#include <linux/list.h>
 #include <linux/capability.h>
 
 struct pt_regs;
_

Patches currently in -mm which might be from h-shimamoto@ct.jp.nec.com are

binfmtsh-include-listh.patch
linux-next.patch

