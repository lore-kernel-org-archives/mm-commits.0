From: akpm@linux-foundation.org
Subject: [obsolete]
 mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix.patch removed from -mm tree
Date: Wed, 16 Jul 2014 14:49:13 -0700
Message-ID: <53c6f359.zDpCdSr2zut+d23B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:39138 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbaGPVtO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jul 2014 17:49:14 -0400
Received: by mail-vc0-f201.google.com with SMTP id hu12so222600vcb.0
        for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2014 14:49:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ddstreet@ieee.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix
has been removed from the -mm tree.  Its filename was
     mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix

fix typo in comment

Cc: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zpool.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/zpool.h~mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix include/linux/zpool.h
--- a/include/linux/zpool.h~mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix
+++ a/include/linux/zpool.h
@@ -118,7 +118,7 @@ int zpool_shrink(struct zpool *pool, uns
  * @mm	How the memory should be mapped
  *
  * This maps a previously allocated handle into memory.  The @mm
- * param indicates to the implemenation how the memory will be
+ * param indicates to the implementation how the memory will be
  * used, i.e. read-only, write-only, read-write.  If the
  * implementation does not support it, the memory will be treated
  * as read-write.
@@ -141,7 +141,7 @@ void *zpool_map_handle(struct zpool *poo
  * @handle	The handle to unmap
  *
  * This unmaps a previously mapped handle.  Any locks or other
- * actions that the implemenation took in zpool_map_handle()
+ * actions that the implementation took in zpool_map_handle()
  * will be undone here.  The memory area returned from
  * zpool_map_handle() should no longer be used after this.
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
revert-fs-seq_file-fallback-to-vmalloc-allocation.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kbuild-explain-stack-protector-strong-config-logic.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-vmscan-clean-up-struct-scan_control-checkpatch-fixes.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
fs-isofs-logging-clean-up-fix.patch
proc-remove-proc_tty_ldisc-variable-fix.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

