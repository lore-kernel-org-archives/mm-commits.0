From: akpm@linux-foundation.org
Subject: - pm-rework-struct-platform_suspend_ops-fixup-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 18 Oct 2007 01:27:37 -0700
Message-ID: <200710180827.l9I8RbMM002086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33663 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756487AbXJRI2w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 04:28:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, domen.puncer@telargo.com, jfannin@gmail.com, lenb@kernel.org, paulus@samba.org, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     pm-rework-struct-platform_suspend_ops-fixup-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     pm-rework-struct-platform_suspend_ops-fixup-checkpatch-fixes.patch

This patch was dropped because it was folded into pm-rework-struct-platform_suspend_ops.patch

------------------------------------------------------
Subject: pm-rework-struct-platform_suspend_ops-fixup-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: braces {} are not necessary for single statement blocks
#85: FILE: arch/powerpc/platforms/52xx/lite5200_pm.c:207:
+	if (lite5200_pm_target_state == PM_SUSPEND_STANDBY) {
+		mpc52xx_pm_finish();
 	}

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Cc: Domen Puncer <domen.puncer@telargo.com>
Cc: Joseph Fannin <jfannin@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/52xx/lite5200_pm.c |    3 +--
 asm-powerpc/mpc52xx.h                     |    0 
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/powerpc/platforms/52xx/lite5200_pm.c~pm-rework-struct-platform_suspend_ops-fixup-checkpatch-fixes arch/powerpc/platforms/52xx/lite5200_pm.c
--- a/arch/powerpc/platforms/52xx/lite5200_pm.c~pm-rework-struct-platform_suspend_ops-fixup-checkpatch-fixes
+++ a/arch/powerpc/platforms/52xx/lite5200_pm.c
@@ -204,9 +204,8 @@ static int lite5200_pm_enter(suspend_sta
 static void lite5200_pm_finish(void)
 {
 	/* deep sleep? let mpc52xx code handle that */
-	if (lite5200_pm_target_state == PM_SUSPEND_STANDBY) {
+	if (lite5200_pm_target_state == PM_SUSPEND_STANDBY)
 		mpc52xx_pm_finish();
-	}
 }
 
 static struct platform_suspend_ops lite5200_pm_ops = {
diff -puN arch/powerpc/platforms/52xx/mpc52xx_pm.c~pm-rework-struct-platform_suspend_ops-fixup-checkpatch-fixes arch/powerpc/platforms/52xx/mpc52xx_pm.c
diff -puN include/asm-powerpc/mpc52xx.h~pm-rework-struct-platform_suspend_ops-fixup-checkpatch-fixes include/asm-powerpc/mpc52xx.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
pm-rework-struct-platform_suspend_ops.patch
pm-rework-struct-platform_suspend_ops-fixup-checkpatch-fixes.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
stop-using-dma_xxbit_mask.patch
stop-using-dma_xxbit_mask-fix.patch
powerpc-lock-bitops-fix.patch
fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
i-oat-tighten-descriptor-setup-performance-fix.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix-fix.patch
