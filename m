From: akpm@linux-foundation.org
Subject: + lib-vsprintf-add-%pe-format-specifier-fix.patch added to -mm
 tree
Date: Thu, 28 Aug 2014 14:09:10 -0700
Message-ID: <53ff9a76.OXlZRdxvWJDSNCk0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:52136 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbaH2NaM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Aug 2014 09:30:12 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so1371561pab.2
        for <mm-commits@vger.kernel.org>; Fri, 29 Aug 2014 06:30:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-vsprintf-add-%pe-format-specifier-fix
has been added to the -mm tree.  Its filename is
     lib-vsprintf-add-%pe-format-specifier-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintf-add-%pe-format-specifier-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintf-add-%pe-format-specifier-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-vsprintf-add-%pe-format-specifier-fix

tidy up comment layout, per Joe

Cc: "John W . Linville" <linville@tuxdriver.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintf-add-%pe-format-specifier-fix lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintf-add-%pe-format-specifier-fix
+++ a/lib/vsprintf.c
@@ -1111,12 +1111,11 @@ char *escaped_string(char *buf, char *en
 	int len;
 
 	if (spec.field_width == 0)
-		/* nothing to print */
-		return buf;
+		return buf;				/* nothing to print */
 
 	if (ZERO_OR_NULL_PTR(addr))
-		/* NULL pointer */
-		return string(buf, end, NULL, spec);
+		return string(buf, end, NULL, spec);	/* NULL pointer */
+
 
 	do {
 		switch (fmt[count++]) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range-fix.patch
mm-slab_commonc-suppress-warning.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch
mm-balloon_compaction-general-cleanup-checkpatch-fixes.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
zram-zram-memory-size-limitation-fix.patch
zram-zram-memory-size-limitation-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
acct-eliminate-compile-warning-fix.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
checkpatch-fix-spello.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
watchdog-control-hard-lockup-detection-default-fix.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

