From: akpm@linux-foundation.org
Subject: [folded-merged]
 powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 12 Feb 2015 14:17:29 -0800
Message-ID: <54dd2679.yFDRh8ri9Hi48tk0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60264 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbbBLWRa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 17:17:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cyrilbur@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-checkpatch-fixes.patch

This patch was dropped because it was folded into powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-checkpatch-fixes

fix >80 column mess

Cc: Cyril Bur <cyrilbur@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/time.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/powerpc/kernel/time.c~powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-checkpatch-fixes arch/powerpc/kernel/time.c
--- a/arch/powerpc/kernel/time.c~powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings-checkpatch-fixes
+++ a/arch/powerpc/kernel/time.c
@@ -632,12 +632,12 @@ unsigned long long sched_clock(void)
 unsigned long long running_clock(void)
 {
 	/*
-	 * Don't read the VTB as a host since KVM does not switch in host timebase
-	 * into the VTB when it takes a guest off the CPU, reading the VTB would
-	 * result in reading 'last switched out' guest VTB.
+	 * Don't read the VTB as a host since KVM does not switch in host
+	 * timebase into the VTB when it takes a guest off the CPU, reading the
+	 * VTB would result in reading 'last switched out' guest VTB.
 	 *
-	 * Host kernels are often compiled with CONFIG_PSERIES checked, it would be
-	 * unsafe to rely only on the #ifdef above.
+	 * Host kernels are often compiled with CONFIG_PSERIES checked, it would
+	 * be unsafe to rely only on the #ifdef above.
 	 */
 	if (firmware_has_feature(FW_FEATURE_LPAR) &&
 	    cpu_has_feature(CPU_FTR_ARCH_207S))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
zram-rework-reset-and-destroy-path.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings.patch
kernelh-remove-ancient-__function__-hack-fix.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch

