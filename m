From: akpm@linux-foundation.org
Subject: - fix-indentation.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:51:57 -0700
Message-ID: <200804282151.m3SLpvw8017623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934684AbYD1Vw0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:52:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: caglar@pardus.org.tr, Lee.Schermerhorn@hp.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mm/page_alloc.c: fix indentation
has been removed from the -mm tree.  Its filename was
     fix-indentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1284,7 +1284,7 @@ static nodemask_t *zlc_setup(struct zone
 	if (!zlc)
 		return NULL;
 
-       if (time_after(jiffies, zlc->last_full_zap + HZ)) {
+	if (time_after(jiffies, zlc->last_full_zap + HZ)) {
 		bitmap_zero(zlc->fullzones, MAX_ZONES_PER_ZONELIST);
 		zlc->last_full_zap = jiffies;
 	}
_

Patches currently in -mm which might be from caglar@pardus.org.tr are

origin.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
fs-binfmt_aoutc-use-printk_ratelimit.patch

