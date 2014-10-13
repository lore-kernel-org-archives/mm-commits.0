From: akpm@linux-foundation.org
Subject: [folded-merged] lib-vsprintf-add-%pe-format-specifier-fix.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 15:42:15 -0700
Message-ID: <543c5547.MB8ukESRBx5TF2TI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34706 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaJMWmP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 18:42:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-vsprintf-add-%pe-format-specifier-fix
has been removed from the -mm tree.  Its filename was
     lib-vsprintf-add-%pe-format-specifier-fix.patch

This patch was dropped because it was folded into lib-vsprintf-add-%pe-format-specifier.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-vsprintf-add-%pe-format-specifier-fix

tidy up comment layout, per Joe

Cc: "John W . Linville" <linville@tuxdriver.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintf-add-%pe-format-specifier-fix lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintf-add-%pe-format-specifier-fix
+++ a/lib/vsprintf.c
@@ -1111,12 +1111,11 @@ char *escaped_string(char *buf, char *en
 	int len;
 
 	if (spec.field_width == 0)
-		/* nothing to print */
-		return buf;
+		return buf;				/* nothing to print */
 
 	if (ZERO_OR_NULL_PTR(addr))
-		/* NULL pointer */
-		return string(buf, end, NULL, spec);
+		return string(buf, end, NULL, spec);	/* NULL pointer */
+
 
 	do {
 		switch (fmt[count++]) {
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
wireless-hostap-proc-print-properly-escaped-ssid-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix-2.patch
watchdog-control-hard-lockup-detection-default-fix.patch

