From: akpm@linux-foundation.org
Subject: [folded] lib-make-_tolower-public-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 25 Jul 2011 17:01:05 -0700
Message-ID: <201107260001.p6Q015AO006527@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752320Ab1GZABH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 20:01:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     lib-make-_tolower-public-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     lib-make-_tolower-public-checkpatch-fixes.patch

This patch was dropped because it was folded into lib-make-_tolower-public.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib-make-_tolower-public-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: please, no spaces at the start of a line
#31: FILE: include/linux/ctype.h:61:
+       return c | 0x20;$

total: 0 errors, 1 warnings, 97 lines checked

./patches/lib-make-_tolower-public.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ctype.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/ctype.h~lib-make-_tolower-public-checkpatch-fixes include/linux/ctype.h
--- a/include/linux/ctype.h~lib-make-_tolower-public-checkpatch-fixes
+++ a/include/linux/ctype.h
@@ -58,7 +58,7 @@ static inline unsigned char __toupper(un
  */
 static inline char _tolower(const char c)
 {
-       return c | 0x20;
+	return c | 0x20;
 }
 
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hugetlb-add-phys-addr-to-struct-huge_bootmem_page.patch
mm-make-some-struct-pages-const.patch
mm-use-const-struct-page-for-r-o-page-flag-accessor-methods.patch
xtensa-prevent-arbitrary-read-in-ptrace.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines.patch
pagewalk-add-locking-rule-comments.patch
mm-memoryc-remove-zap_block_size.patch
mm-memblockc-avoid-abuse-of-red_inactive.patch
mm-preallocate-page-before-lock_page-at-filemap-cow.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young.patch
drivers-misc-add-support-the-fsa9480-usb-switch.patch
lib-make-_tolower-public.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-skip-calibration-delay-if-previously-done-4.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
drivers-connector-cn_procc-remove-unused-local.patch
drivers-staging-gma500-psb_intel_displayc-fix-bad-udelay.patch

