From: akpm@linux-foundation.org
Subject: - cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 14 Nov 2007 16:51:04 -0800
Message-ID: <200711150051.lAF0p4fR002230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36085 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754838AbXKOAvK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Nov 2007 19:51:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes.patch

This patch was dropped because it was folded into cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two.patch

------------------------------------------------------
Subject: cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: braces {} are not necessary for single statement blocks
#97: FILE: arch/cris/arch-v32/drivers/axisflashmap.c:197:
+	if (!mtd_cs) {
+		mtd_cs = do_map_probe("jedec_probe", map_cs);
 	}

total: 0 errors, 1 warnings, 70 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v32/drivers/axisflashmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/cris/arch-v32/drivers/axisflashmap.c~cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes arch/cris/arch-v32/drivers/axisflashmap.c
--- a/arch/cris/arch-v32/drivers/axisflashmap.c~cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes
+++ a/arch/cris/arch-v32/drivers/axisflashmap.c
@@ -194,9 +194,8 @@ static struct mtd_info *probe_cs(struct 
 		mtd_cs = do_map_probe("cfi_probe", map_cs);
 #endif
 #ifdef CONFIG_MTD_JEDECPROBE
-	if (!mtd_cs) {
+	if (!mtd_cs)
 		mtd_cs = do_map_probe("jedec_probe", map_cs);
-	}
 #endif
 
 	return mtd_cs;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
uml-update-address-space-affected-by-pud_clear.patch
proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks.patch
acpi-make-acpi_procfs-default-to-y.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch
revert-task-control-groups-example-cpu-accounting-subsystem.patch
mips-undo-locking-on-error-path-returns.patch
pidns-place-under-config_experimental.patch
fix-64kb-blocksize-in-ext3-directories.patch
file-capabilities-allow-sigcont-within-session-v2.patch
x86-disable-preemption-in-delay_tsc.patch
aic94xx_sds-rename-flash_size.patch
mips-pcspkr-build-fix.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes.patch
