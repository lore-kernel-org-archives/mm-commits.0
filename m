From: akpm@linux-foundation.org
Subject: [merged] drivers-staging-unisys-fix-build.patch removed from -mm
 tree
Date: Wed, 27 Aug 2014 12:26:18 -0700
Message-ID: <53fe30da.c9GmKV4hYTxLxa0I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:50836 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935181AbaH0T0U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Aug 2014 15:26:20 -0400
Received: by mail-vc0-f201.google.com with SMTP id le20so14420vcb.4
        for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2014 12:26:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benjamin.romer@unisys.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/staging/unisys: fix build
has been removed from the -mm tree.  Its filename was
     drivers-staging-unisys-fix-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/staging/unisys: fix build

drivers/staging/unisys/visorchipset/file.c:31: error: redefinition of typedef 'GUEST_PHYSICAL_ADDRESS'
drivers/staging/unisys/common-spar/include/channels/controlvmchannel.h:23: note: previous declaration of 'GUEST_PHYSICAL_ADDRESS' was here

Cc: Benjamin Romer <benjamin.romer@unisys.com>
Cc: Greg KH <greg@kroah.com>
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
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
zram-zram-memory-size-limitation-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
acct-eliminate-compile-warning-fix.patch
checkpatch-fix-spello.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
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

