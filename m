From: akpm@linux-foundation.org
Subject: [folded] drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch-fix.patch removed from -mm tree
Date: Thu, 26 May 2011 16:16:04 -0700
Message-ID: <201105262316.p4QNG4qf026311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754820Ab1EZXQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 May 2011 19:16:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alessandro.zummo@towertech.it, vzapolskiy@gmail.com, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch-fix
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch-fix.patch

This patch was dropped because it was folded into drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch-fix
From: Andrew Morton <akpm@linux-foundation.org>

maintain the code comments

Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: Vladimir Zapolskiy <vzapolskiy@gmail.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rtc.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/rtc.h~drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch-fix include/linux/rtc.h
--- a/include/linux/rtc.h~drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch-fix
+++ a/include/linux/rtc.h
@@ -92,10 +92,10 @@ struct rtc_pll_info {
 #define RTC_PLL_SET	_IOW('p', 0x12, struct rtc_pll_info)  /* Set PLL correction */
 
 /* interrupt flags */
-#define RTC_IRQF 0x80 /* any of the following is active */
-#define RTC_PF 0x40
-#define RTC_AF 0x20
-#define RTC_UF 0x10
+#define RTC_IRQF 0x80	/* Any of the following is active */
+#define RTC_PF 0x40	/* Periodic interrupt */
+#define RTC_AF 0x20	/* Alarm interrupt */
+#define RTC_UF 0x10	/* Update interrupt for 1Hz RTC */
 
 #ifdef __KERNEL__
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-video-mb862xx-mb862xxfbdrvc-needs-uaccessh.patch
drivers-bcma-host_pcic-needs-slabh.patch
include-linux-hugetlbh-needs-mm_typesh.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region.patch
drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch.patch
ufs-truncated-values-handling-64-bit-metadata-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
documentation-configfs-examples-crash-fix-checkpatch-fixes.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
add-the-pagefault-count-into-memcg-stats.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch
w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix.patch

