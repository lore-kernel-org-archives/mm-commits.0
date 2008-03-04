From: akpm@linux-foundation.org
Subject: - documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix.patch removed from -mm tree
Date: Tue, 04 Mar 2008 14:25:25 -0800
Message-ID: <200803042225.m24MPQFJ032289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759018AbYCDWZm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 17:25:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, npiggin@suse.de, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix
has been removed from the -mm tree.  Its filename was
     documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Nick Piggin <npiggin@suse.de>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/memory-barriers.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/atomic_ops.txt~documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix Documentation/atomic_ops.txt
diff -puN Documentation/memory-barriers.txt~documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix Documentation/memory-barriers.txt
--- a/Documentation/memory-barriers.txt~documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix
+++ a/Documentation/memory-barriers.txt
@@ -1493,7 +1493,7 @@ explicit lock operations, described late
 	atomic_dec_and_test();
 	atomic_sub_and_test();
 	atomic_add_negative();
-	atomic_add_unless();	/* when succeeds (returns 1) */
+	atomic_add_unless();	/* when it succeeds (returns 1) */
 	test_and_set_bit();
 	test_and_clear_bit();
 	test_and_change_bit();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
zlc_setup-handle-jiffies-wraparound.patch
documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix.patch
tridentfb-resource-management-fixes-in-probe-function.patch
add-noinline_for_stack.patch
ndelay-switch-to-c-function-to-avoid-64-bit-division.patch
sm501-add-support-for-the-sm502-programmable-pll.patch
markers-dont-risk-null-deref-in-marker.patch
iommu-parisc-pass-struct-device-to-iommu_alloc_range.patch
iommu-parisc-make-the-iommus-respect-the-segment-boundary-limits.patch

