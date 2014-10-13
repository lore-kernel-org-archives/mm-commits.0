From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-cma-fix-cma-bitmap-aligned-mask-computing-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 13 Oct 2014 15:36:01 -0700
Message-ID: <543c53d1./gXcYczi0R3FoS2l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34645 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaJMWgD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 18:36:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com, mina86@mina86.com, weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-fix-cma-bitmap-aligned-mask-computing-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-cma-fix-cma-bitmap-aligned-mask-computing-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-cma-fix-cma-bitmap-aligned-mask-computing.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-cma-fix-cma-bitmap-aligned-mask-computing-checkpatch-fixes

WARNING: else is not generally useful after a break or return
#36: FILE: mm/cma.c:63:
+		return 0;
+	else

total: 0 errors, 1 warnings, 11 lines checked

./patches/mm-cma-fix-cma-bitmap-aligned-mask-computing.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Weijie Yang <weijie.yang@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/cma.c~mm-cma-fix-cma-bitmap-aligned-mask-computing-checkpatch-fixes mm/cma.c
--- a/mm/cma.c~mm-cma-fix-cma-bitmap-aligned-mask-computing-checkpatch-fixes
+++ a/mm/cma.c
@@ -60,8 +60,7 @@ static unsigned long cma_bitmap_aligned_
 {
 	if (align_order <= cma->order_per_bit)
 		return 0;
-	else
-		return (1UL << (align_order - cma->order_per_bit)) - 1;
+	return (1UL << (align_order - cma->order_per_bit)) - 1;
 }
 
 static unsigned long cma_bitmap_maxno(struct cma *cma)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cma-fix-cma-bitmap-aligned-mask-computing.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
checkpatch-fix-spello.patch
checkpatch-warn-on-logging-functions-with-kern_level.patch
rtc-rk808-add-rtc-driver-for-rk808-fix.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-checkpatch-fixes.patch
rtc-max77686-use-ffs-to-calculate-tm_wday-fix.patch
rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10-fix.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
init-resolve-shadow-warnings-checkpatch-fixes.patch
arch-x86-kernel-cpu-commonc-fix-unused-symbol-warning.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
lib-string_helpers-introduce-string_escape_mem-fix.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix-2.patch
watchdog-control-hard-lockup-detection-default-fix.patch

