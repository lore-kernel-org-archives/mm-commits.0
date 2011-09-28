From: akpm@linux-foundation.org
Subject: + llist-make-all-llist-functions-inline-fix.patch added to -mm tree
Date: Wed, 28 Sep 2011 15:07:47 -0700
Message-ID: <201109282207.p8SM7ltp001158@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:18818 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab1I1WIP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2011 18:08:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, ying.huang@intel.com


The patch titled
     Subject: llist: using in_nmi requires including hardirq.h
has been added to the -mm tree.  Its filename is
     llist-make-all-llist-functions-inline-fix.patch

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
Subject: llist: using in_nmi requires including hardirq.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/llist.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/llist.h~llist-make-all-llist-functions-inline-fix include/linux/llist.h
--- a/include/linux/llist.h~llist-make-all-llist-functions-inline-fix
+++ a/include/linux/llist.h
@@ -56,6 +56,8 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/hardirq.h>
+
 #include <asm/system.h>
 #include <asm/processor.h>
 
_
Subject: Subject: llist: using in_nmi requires including hardirq.h

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
linux-next.patch
consolidate-config_debug_strict_user_copy_checks.patch
treewide-use-__printf-not-__attribute__formatprintf-fix.patch
llist-make-all-llist-functions-inline-fix.patch
init-add-root=partuuid=uuid-partnroff=%d-support-fix.patch

