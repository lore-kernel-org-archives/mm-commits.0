From: akpm@linux-foundation.org
Subject: [folded-merged]
 x86-optimize-resource-lookups-for-ioremap-fix.patch removed from -mm tree
Date: Mon, 13 Oct 2014 15:40:35 -0700
Message-ID: <543c54e3.TnMF/7rC0wDLiKDm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaJMWkg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 18:40:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, athorlton@sgi.com, cpw@sgi.com, dyoung@redhat.com, hpa@zytor.com, mgorman@suse.de, mingo@elte.hu, msalter@redhat.com, peterz@infradead.org, riel@redhat.com, tglx@linutronix.de, travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-optimize-resource-lookups-for-ioremap-fix
has been removed from the -mm tree.  Its filename was
     x86-optimize-resource-lookups-for-ioremap-fix.patch

This patch was dropped because it was folded into x86-optimize-resource-lookups-for-ioremap.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: x86-optimize-resource-lookups-for-ioremap-fix

fix spellos and typos in comment

Cc: Alex Thorlton <athorlton@sgi.com>
Cc: Cliff Wickman <cpw@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/resource.c~x86-optimize-resource-lookups-for-ioremap-fix kernel/resource.c
--- a/kernel/resource.c~x86-optimize-resource-lookups-for-ioremap-fix
+++ a/kernel/resource.c
@@ -496,8 +496,8 @@ EXPORT_SYMBOL_GPL(page_is_ram);
  * If found, return 1 if it is RAM, 0 if not.
  * If not found, or region is not fully contained, return -1
  *
- * Used by the ioremap functions to insure user not remapping RAM and is as
- * vast speed up over walking through the resource table page by page.
+ * Used by the ioremap functions to ensure the user is not remapping RAM and is
+ * a vast speed up over walking through the resource table page by page.
  */
 int region_is_ram(resource_size_t start, unsigned long size)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cma-fix-cma-bitmap-aligned-mask-computing.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
checkpatch-fix-spello.patch
checkpatch-warn-on-logging-functions-with-kern_level.patch
rtc-rk808-add-rtc-driver-for-rk808.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding.patch
rtc-max77686-use-ffs-to-calculate-tm_wday.patch
rtc-add-driver-for-maxim-77802-pmic-real-time-clock.patch
x86-optimize-resource-lookups-for-ioremap.patch
init-resolve-shadow-warnings-checkpatch-fixes.patch
arch-x86-kernel-cpu-commonc-fix-unused-symbol-warning.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
lib-string_helpers-introduce-string_escape_mem-fix.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix-2.patch
watchdog-control-hard-lockup-detection-default-fix.patch

