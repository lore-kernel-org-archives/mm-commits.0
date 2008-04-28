From: akpm@linux-foundation.org
Subject: - ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch removed from -mm tree
Date: Mon, 28 Apr 2008 00:03:41 -0700
Message-ID: <200804280703.m3S73foc013154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765057AbYD1HDu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 03:03:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo
has been removed from the -mm tree.  Its filename was
     ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch

This patch was dropped because it was folded into ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/balloc.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN fs/ext3/balloc.c~ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo fs/ext3/balloc.c
--- a/fs/ext3/balloc.c~ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo
+++ a/fs/ext3/balloc.c
@@ -166,8 +166,8 @@ read_block_bitmap(struct super_block *sb
 	}
 	ext3_valid_block_bitmap(sb, desc, block_group, bh);
 	/*
-	 * file system mounted not to panic on error,
-	 * continue with corrput bitmap
+	 * file system mounted not to panic on error, continue with corrupt
+	 * bitmap
 	 */
 	return bh;
 }
@@ -1643,9 +1643,8 @@ allocated:
 			    "blocks from "E3FSBLK", length %lu",
 			     ret_block, num);
 		/*
-		 * claim_block marked the blocks we allocated
-		 * as in use. So we may want to selectively
-		 * mark some of the blocks as free
+		 * claim_block() marked the blocks we allocated as in use. So we
+		 * may want to selectively mark some of the blocks as free.
 		 */
 		goto retry_alloc;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-x1205-new-style-conversion.patch
hotplug-memory-make-online_page-common.patch
remove-sparse-warning-for-mmzoneh.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret.patch
mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch
vmallocinfo-add-caller-information.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
smaps-account-swap-entries.patch
mm-introduce-pte_special-pte-bit.patch
hugetlb-vmstat-events-for-huge-page-allocations.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info.patch
capabilities-implement-per-process-securebits.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
arch-alpha-kernel-trapsc-use-time_-macros.patch
alpha-teach-the-compiler-that-bug-doesnt-return.patch
uart_get_baud_rate-stop-mangling-termios.patch
drivers-acpi-thermalc-fix-build-with-config_dmi=n.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch
vt-notifier-extension-for-accessibility.patch
kprobes-prevent-probing-of-preempt_schedule.patch
quota-various-style-cleanups.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount.patch
quota-convert-stub-functions-from-macros-into-inlines.patch
gpiochip_reserve.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
lxfb-add-power-management-functionality.patch
drivers-video-uvesafbc-fix-error-path-memory-leak.patch
fb-convert-proc-fb-to-seq_file-interface.patch
drivers-video-w100fbc-avoid-a-couple-of-error-path-null-derefs.patch
drivers-md-use-time_before-time_before_eq-etc.patch
pnp-use-dev_printk-for-quirk-messages.patch
ext2-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone.patch
ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone.patch
ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
fat_valid_media-remove-pointless-test.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch

