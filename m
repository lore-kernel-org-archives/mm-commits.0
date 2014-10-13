From: akpm@linux-foundation.org
Subject: [folded-merged]
 watchdog-control-hard-lockup-detection-default-fix.patch removed from -mm
 tree
Date: Mon, 13 Oct 2014 15:43:39 -0700
Message-ID: <543c559b.HsezVpImdRxab9Y7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbaJMWnk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 18:43:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, drjones@redhat.com, dzickus@redhat.com, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog-control-hard-lockup-detection-default-fix
has been removed from the -mm tree.  Its filename was
     watchdog-control-hard-lockup-detection-default-fix.patch

This patch was dropped because it was folded into watchdog-control-hard-lockup-detection-default.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: watchdog-control-hard-lockup-detection-default-fix

fix build

In file included from arch/x86/mm/init_64.c:33:
include/linux/nmi.h: In function 'watchdog_enable_hardlockup_detector':
include/linux/nmi.h:27: error: parameter name omitted

Cc: Andrew Jones <drjones@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/nmi.h~watchdog-control-hard-lockup-detection-default-fix include/linux/nmi.h
--- a/include/linux/nmi.h~watchdog-control-hard-lockup-detection-default-fix
+++ a/include/linux/nmi.h
@@ -24,7 +24,7 @@ static inline void touch_nmi_watchdog(vo
 {
 	touch_softlockup_watchdog();
 }
-static inline void watchdog_enable_hardlockup_detector(bool)
+static inline void watchdog_enable_hardlockup_detector(bool val)
 {
 }
 static inline bool watchdog_hardlockup_detector_is_enabled(void)
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
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable.patch
lib-string_helpers-introduce-string_escape_mem.patch
lib-vsprintf-add-%pe-format-specifier.patch
wireless-hostap-proc-print-properly-escaped-ssid.patch
watchdog-control-hard-lockup-detection-default.patch

