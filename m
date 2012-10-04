From: akpm@linux-foundation.org
Subject: [folded-dropped] sections-fix-section-conflicts-in-arch-h8300-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 04 Oct 2012 16:52:51 -0700
Message-ID: <20121004235252.1F200100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:35443 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab2JDXwx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 19:52:53 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so128813ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 16:52:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: sections-fix-section-conflicts-in-arch-h8300-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-arch-h8300-checkpatch-fixes.patch

This patch was dropped because it was folded into sections-fix-section-conflicts-in-arch-h8300.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sections-fix-section-conflicts-in-arch-h8300-checkpatch-fixes

ERROR: spaces required around that '=' (ctx:VxV)
#105: FILE: arch/h8300/platform/h8s/irq.c:21:
+const int __initconst h8300_saved_vectors[]={
                                            ^

total: 1 errors, 0 warnings, 71 lines checked

./patches/sections-fix-section-conflicts-in-arch-h8300.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/platform/h8s/irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/h8300/platform/h8s/irq.c~sections-fix-section-conflicts-in-arch-h8300-checkpatch-fixes arch/h8300/platform/h8s/irq.c
--- a/arch/h8300/platform/h8s/irq.c~sections-fix-section-conflicts-in-arch-h8300-checkpatch-fixes
+++ a/arch/h8300/platform/h8s/irq.c
@@ -18,7 +18,7 @@
 #include <asm/regs267x.h>
 
 /* saved vector list */
-const int __initconst h8300_saved_vectors[]={
+const int __initconst h8300_saved_vectors[] = {
 #if defined(CONFIG_GDB_DEBUG)
 	TRACE_VEC,
 	TRAP3_VEC,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
audith-replace-defines-with-c-stubs.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-drivers-macintosh-checkpatch-fixes.patch
sectons-fix-const-sections-for-crc32-table-checkpatch-fixes.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
backlight-platform-lcd-add-support-for-device-tree-based-probe-fix.patch
idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
rapidio-run-discovery-as-an-asynchronous-process-fix.patch

