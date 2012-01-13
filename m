From: akpm@linux-foundation.org
Subject: [folded] treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 12 Jan 2012 16:44:37 -0800
Message-ID: <20120113004439.0AB625C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:39918 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673Ab2AMAol (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2012 19:44:41 -0500
Received: by wibhq12 with SMTP id hq12so86751wib.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2012 16:44:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch

This patch was dropped because it was folded into treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>

WARNING: please, no spaces at the start of a line
#57: FILE: arch/m68k/amiga/config.c:515:
+    __noreturn;$

total: 0 errors, 1 warnings, 106 lines checked

./patches/treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/amiga/config.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/m68k/amiga/config.c~treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes arch/m68k/amiga/config.c
--- a/arch/m68k/amiga/config.c~treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes
+++ a/arch/m68k/amiga/config.c
@@ -511,8 +511,7 @@ static unsigned long amiga_gettimeoffset
 	return ticks + offset;
 }
 
-static void amiga_reset(void)
-    __noreturn;
+static void amiga_reset(void)  __noreturn;
 
 static void amiga_reset(void)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
drivers-video-nvidia-nvidiac-fix-warning.patch
pipe-fail-cleanly-when-root-tries-f_setpipe_sz-with-big-size.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2-fix.patch
memcg-simplify-lru-handling-by-new-rule-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix-3.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
kexec-remove-kmsg_dump_kexec.patch
panic-dont-print-redundant-backtraces-on-oops-fix.patch
drivers-parport-parport_pcc-fix-warnings.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch

