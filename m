From: akpm@linux-foundation.org
Subject: - mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 14 Nov 2007 16:44:40 -0800
Message-ID: <200711150044.lAF0iexl002034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34623 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755640AbXKOApX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Nov 2007 19:45:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, 12o3l@tiscali.nl, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips-undo-locking-on-error-path-returns-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch

This patch was dropped because it was folded into mips-undo-locking-on-error-path-returns.patch

------------------------------------------------------
Subject: mips-undo-locking-on-error-path-returns-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: use tabs not spaces
#40: FILE: arch/mips/vr41xx/common/icu.c:596:
+                spin_unlock_irq(&desc->lock);$

total: 1 errors, 0 warnings, 21 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Roel Kluin <12o3l@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/vr41xx/common/icu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mips/vr41xx/common/icu.c~mips-undo-locking-on-error-path-returns-checkpatch-fixes arch/mips/vr41xx/common/icu.c
--- a/arch/mips/vr41xx/common/icu.c~mips-undo-locking-on-error-path-returns-checkpatch-fixes
+++ a/arch/mips/vr41xx/common/icu.c
@@ -593,7 +593,7 @@ static inline int set_sysint2_assign(uns
 		intassign3 |= (uint16_t)assign << 12;
 		break;
 	default:
-                spin_unlock_irq(&desc->lock);
+		spin_unlock_irq(&desc->lock);
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
uml-update-address-space-affected-by-pud_clear.patch
proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks.patch
acpi-make-acpi_procfs-default-to-y.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch
revert-task-control-groups-example-cpu-accounting-subsystem.patch
mips-undo-locking-on-error-path-returns.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes.patch
file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes.patch
x86-disable-preemption-in-delay_tsc.patch
aic94xx_sds-rename-flash_size.patch
mips-pcspkr-build-fix.patch
