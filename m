From: akpm@linux-foundation.org
Subject: + fix-indentation.patch added to -mm tree
Date: Mon, 17 Mar 2008 21:23:01 -0700
Message-ID: <200803180423.m2I4N136013948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752236AbYCREXN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Mar 2008 00:23:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: caglar@pardus.org.tr, Lee.Schermerhorn@hp.com, pj@sgi.com


The patch titled
     mm/page_alloc.c: fix indentation
has been added to the -mm tree.  Its filename is
     fix-indentation.patch

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
Subject: mm/page_alloc.c: fix indentation
From: S.Caglar Onur <caglar@pardus.org.tr>

zlc_setup(): handle jiffies wraparound
(10ed273f5016c582413dfbc468dd084957d847e1) changes tab with spaces

Signed-off-by: S.Caglar Onur <caglar@pardus.org.tr>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~fix-indentation mm/page_alloc.c
--- a/mm/page_alloc.c~fix-indentation
+++ a/mm/page_alloc.c
@@ -1302,7 +1302,7 @@ static nodemask_t *zlc_setup(struct zone
 	if (!zlc)
 		return NULL;
 
-       if (time_after(jiffies, zlc->last_full_zap + HZ)) {
+	if (time_after(jiffies, zlc->last_full_zap + HZ)) {
 		bitmap_zero(zlc->fullzones, MAX_ZONES_PER_ZONELIST);
 		zlc->last_full_zap = jiffies;
 	}
_

Patches currently in -mm which might be from caglar@pardus.org.tr are

arch-alpha-kernel-trapsc-use-time_-macros.patch
arch-ia64-kernel-use-time_-macros.patch
arch-ia64-kernel-use-time_-macros-checkpatch-fixes.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
arch-parisc-kernel-unalignedc-use-time_-macros-checkpatch-fixes.patch
arch-powerpc-platforms-iseries-pcic-use-time_-macros.patch
drivers-net-arcnet-arcnetc-use-time_-macros.patch
drivers-net-arcnet-arcnetc-use-time_-macros-checkpatch-fixes.patch
drivers-net-tokenring-3c359c-use-time_-macros.patch
drivers-net-tokenring-3c359c-use-time_-macros-checkpatch-fixes.patch
drivers-net-wireless-atmelc-use-time_-macros.patch
fs-binfmt_aoutc-use-printk_ratelimit.patch
fix-indentation.patch

