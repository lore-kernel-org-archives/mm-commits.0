From: akpm@linux-foundation.org
Subject: + drivers-staging-gma500-psb_intel_displayc-fix-bad-udelay.patch added to -mm tree
Date: Mon, 25 Jul 2011 15:17:20 -0700
Message-ID: <201107252255.p6PMtWHS001890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014Ab1GYW4E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 18:56:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com


The patch titled
     drivers/staging/gma500/psb_intel_display.c: fix bad udelay()
has been added to the -mm tree.  Its filename is
     drivers-staging-gma500-psb_intel_displayc-fix-bad-udelay.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/staging/gma500/psb_intel_display.c: fix bad udelay()
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "__bad_udelay" [drivers/staging/gma500/psb_gfx.ko] undefined!

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/gma500/psb_intel_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/gma500/psb_intel_display.c~drivers-staging-gma500-psb_intel_displayc-fix-bad-udelay drivers/staging/gma500/psb_intel_display.c
--- a/drivers/staging/gma500/psb_intel_display.c~drivers-staging-gma500-psb_intel_displayc-fix-bad-udelay
+++ a/drivers/staging/gma500/psb_intel_display.c
@@ -331,7 +331,7 @@ static bool psb_intel_find_best_PLL(stru
 void psb_intel_wait_for_vblank(struct drm_device *dev)
 {
 	/* Wait for 20ms, i.e. one cycle at 50hz. */
-	udelay(20000);
+	mdelay(20);
 }
 
 int psb_intel_pipe_set_base(struct drm_crtc *crtc,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hugetlb-add-phys-addr-to-struct-huge_bootmem_page-fix.patch
mm-make-some-struct-pages-const-fix.patch
mm-use-const-struct-page-for-r-o-page-flag-accessor-methods-checkpatch-fixes.patch
xtensa-prevent-arbitrary-read-in-ptrace-fix.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
mm-memoryc-remove-zap_block_size.patch
mm-memblockc-avoid-abuse-of-red_inactive.patch
mm-preallocate-page-before-lock_page-at-filemap-cow.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-checkpatch-fixes.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix.patch
drivers-misc-add-support-the-fsa9480-usb-switch-fix.patch
lib-make-_tolower-public-checkpatch-fixes.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-skip-calibration-delay-if-previously-done-4.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
drivers-connector-cn_procc-remove-unused-local.patch
drivers-staging-gma500-psb_intel_displayc-fix-bad-udelay.patch

