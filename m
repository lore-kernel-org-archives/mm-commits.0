From: akpm@linux-foundation.org
Subject: + drivers-staging-unisys-fix-build.patch added to -mm tree
Date: Mon, 25 Aug 2014 16:12:47 -0700
Message-ID: <53fbc2ef.5r5Mz/ZNBtlaGfpc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:56669 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbaHYXMs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Aug 2014 19:12:48 -0400
Received: by mail-ie0-f202.google.com with SMTP id rl12so1527832iec.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Aug 2014 16:12:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/staging/unisys: fix build
has been added to the -mm tree.  Its filename is
     drivers-staging-unisys-fix-build.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-staging-unisys-fix-build.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-staging-unisys-fix-build.patch

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
Subject: drivers/staging/unisys: fix build



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/unisys/visorchipset/file.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/staging/unisys/visorchipset/file.c~drivers-staging-unisys-fix-build drivers/staging/unisys/visorchipset/file.c
--- a/drivers/staging/unisys/visorchipset/file.c~drivers-staging-unisys-fix-build
+++ a/drivers/staging/unisys/visorchipset/file.c
@@ -28,8 +28,6 @@
 
 #define CURRENT_FILE_PC VISOR_CHIPSET_PC_file_c
 
-typedef u64 GUEST_PHYSICAL_ADDRESS;
-
 static struct cdev Cdev;
 static VISORCHANNEL **PControlVm_channel;
 static dev_t MajorDev = -1; /**< indicates major num for device */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
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
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
checkpatch-fix-spello.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
drivers-staging-unisys-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
watchdog-control-hard-lockup-detection-default-fix.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

