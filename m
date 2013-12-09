From: akpm@linux-foundation.org
Subject: [withdrawn]
 kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch removed
 from -mm tree
Date: Mon, 09 Dec 2013 13:52:48 -0800
Message-ID: <52a63bb0.HtS6UKMTg8RLaRLc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761803Ab3LIVwu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Dec 2013 16:52:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, felipe.contreras@gmail.com, akpm@linux-foundation.org

Subject: [withdrawn] kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,felipe.contreras@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Dec 2013 13:52:48 -0800


The patch titled
     Subject: kernel-paramsc-improve-standard-definitions-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-paramsc-improve-standard-definitions-checkpatch-fixes

WARNING: please, no space before tabs
#25: FILE: kernel/params.c:230:
+#define STANDARD_PARAM_DEF(name, type, format, strtolfn)      ^I^I\$

total: 0 errors, 1 warnings, 39 lines checked

./patches/kernel-paramsc-improve-standard-definitions.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Felipe Contreras <felipe.contreras@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/params.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/params.c~kernel-paramsc-improve-standard-definitions-checkpatch-fixes kernel/params.c
--- a/kernel/params.c~kernel-paramsc-improve-standard-definitions-checkpatch-fixes
+++ a/kernel/params.c
@@ -227,7 +227,7 @@ int parse_args(const char *doing,
 }
 
 /* Lazy bastard, eh? */
-#define STANDARD_PARAM_DEF(name, type, format, strtolfn)      		\
+#define STANDARD_PARAM_DEF(name, type, format, strtolfn)		\
 	int param_set_##name(const char *val, const struct kernel_param *kp) \
 	{								\
 		return strtolfn(val, 0, (type *)kp->arg);		\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case-fix.patch
dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch
mm-add-overcommit_kbytes-sysctl-variable-fix.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions-checkpatch-fixes.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

