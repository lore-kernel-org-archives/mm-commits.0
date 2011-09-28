From: akpm@google.com
Subject: + dio-optimize-cache-misses-in-the-submission-path-v2-fix.patch added to -mm tree
Date: Wed, 28 Sep 2011 15:09:13 -0700
Message-ID: <201109282209.p8SM9Dsi015354@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:53676 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab1I1WJ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2011 18:09:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, ak@linux.intel.com


The patch titled
     Subject: dio: using prefetch requires including prefetch.h
has been added to the -mm tree.  Its filename is
     dio-optimize-cache-misses-in-the-submission-path-v2-fix.patch

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
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: dio: using prefetch requires including prefetch.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 fs/direct-io.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/direct-io.c~dio-optimize-cache-misses-in-the-submission-path-v2-fix fs/direct-io.c
--- a/fs/direct-io.c~dio-optimize-cache-misses-in-the-submission-path-v2-fix
+++ a/fs/direct-io.c
@@ -36,6 +36,7 @@
 #include <linux/rwsem.h>
 #include <linux/uio.h>
 #include <linux/atomic.h>
+#include <linux/prefetch.h>
 
 /*
  * How many user pages to map in one call to get_user_pages().  This determines
_
Subject: Subject: dio: using prefetch requires including prefetch.h

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
linux-next.patch
consolidate-config_debug_strict_user_copy_checks.patch
treewide-use-__printf-not-__attribute__formatprintf-fix.patch
llist-make-all-llist-functions-inline-fix.patch
init-add-root=partuuid=uuid-partnroff=%d-support-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-fix.patch

