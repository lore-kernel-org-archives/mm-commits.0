From: akpm@linux-foundation.org
Subject: [folded-merged]
 init-resolve-shadow-warnings-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 13 Oct 2014 15:40:57 -0700
Message-ID: <543c54f9.7vRMhNDkgyPNqKGa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaJMWk6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 18:40:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jeffrey.t.kirsher@intel.com, mark.d.rustad@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: init-resolve-shadow-warnings-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     init-resolve-shadow-warnings-checkpatch-fixes.patch

This patch was dropped because it was folded into init-resolve-shadow-warnings.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: init-resolve-shadow-warnings-checkpatch-fixes

ERROR: space required before the open parenthesis '('
#71: FILE: init/initramfs.c:295:
+	while(byte_count && *victim == '\0')

total: 1 errors, 0 warnings, 103 lines checked

./patches/init-resolve-shadow-warnings.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/initramfs.c~init-resolve-shadow-warnings-checkpatch-fixes init/initramfs.c
--- a/init/initramfs.c~init-resolve-shadow-warnings-checkpatch-fixes
+++ a/init/initramfs.c
@@ -292,7 +292,7 @@ static int __init do_skip(void)
 
 static int __init do_reset(void)
 {
-	while(byte_count && *victim == '\0')
+	while (byte_count && *victim == '\0')
 		eat(1);
 	if (byte_count && (this_header & 3))
 		error("broken padding");
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
init-resolve-shadow-warnings.patch
arch-x86-kernel-cpu-commonc-fix-unused-symbol-warning.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
lib-string_helpers-introduce-string_escape_mem-fix.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix-2.patch
watchdog-control-hard-lockup-detection-default-fix.patch

