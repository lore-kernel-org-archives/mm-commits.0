From: akpm@linux-foundation.org
Subject: +
 powerpc-merge-fix-for-watchdog_enable_hardlockup_detector-api-change.patch
 added to -mm tree
Date: Mon, 13 Apr 2015 13:14:12 -0700
Message-ID: <552c2394.R2iKVxuRCwXCu4I9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbbDMUON (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Apr 2015 16:14:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: merge fix for watchdog_enable_hardlockup_detector API change
has been added to the -mm tree.  Its filename is
     powerpc-merge-fix-for-watchdog_enable_hardlockup_detector-api-change.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-merge-fix-for-watchdog_enable_hardlockup_detector-api-change.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-merge-fix-for-watchdog_enable_hardlockup_detector-api-change.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: powerpc: merge fix for watchdog_enable_hardlockup_detector API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/setup_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/setup_64.c~powerpc-merge-fix-for-watchdog_enable_hardlockup_detector-api-change arch/powerpc/kernel/setup_64.c
--- a/arch/powerpc/kernel/setup_64.c~powerpc-merge-fix-for-watchdog_enable_hardlockup_detector-api-change
+++ a/arch/powerpc/kernel/setup_64.c
@@ -793,7 +793,7 @@ u64 hw_nmi_get_sample_period(int watchdo
  */
 static int __init disable_hardlockup_detector(void)
 {
-	watchdog_enable_hardlockup_detector(false);
+	hardlockup_detector_disable();
 
 	return 0;
 }
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-cma-release-trigger-fixpatch.patch
lib-add-huge-i-o-map-capability-interfaces-fix.patch
mm-change-ioremap-to-set-up-huge-i-o-mappings-fix.patch
zsmalloc-support-compaction-fix.patch
zsmalloc-remove-extra-cond_resched-in-__zs_compact.patch
fs-fat-remove-unnecessary-includes-fix-2.patch
mm-rcu-protected-get_mm_exe_file-fix.patch
linux-next.patch
powerpc-merge-fix-for-watchdog_enable_hardlockup_detector-api-change.patch
kernel-forkc-export-kernel_thread-to-modules.patch

