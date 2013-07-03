From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-xattr-remove-useless-free-space-checking-fix.patch removed from -mm
 tree
Date: Wed, 03 Jul 2013 14:22:01 -0700
Message-ID: <51d495f9.9fxhaq8Pc3DWOYJK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933142Ab3GCVWD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 17:22:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, junxiao.bi@oracle.com, jlbec@evilplan.org, jeff.liu@oracle.com, fengguang.wu@intel.com, akpm@linux-foundation.org

Subject: [folded-merged] ocfs2-xattr-remove-useless-free-space-checking-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,fengguang.wu@intel.com,jeff.liu@oracle.com,jlbec@evilplan.org,junxiao.bi@oracle.com,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 14:22:01 -0700


The patch titled
     Subject: ocfs2-xattr-remove-useless-free-space-checking-fix
has been removed from the -mm tree.  Its filename was
     ocfs2-xattr-remove-useless-free-space-checking-fix.patch

This patch was dropped because it was folded into ocfs2-xattr-remove-useless-free-space-checking.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-xattr-remove-useless-free-space-checking-fix

remove unused local

Cc: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/ocfs2/xattr.c~ocfs2-xattr-remove-useless-free-space-checking-fix fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-xattr-remove-useless-free-space-checking-fix
+++ a/fs/ocfs2/xattr.c
@@ -2751,7 +2751,6 @@ static int ocfs2_xattr_ibody_set(struct
 {
 	int ret;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
 	struct ocfs2_xa_loc loc;
 
 	if (inode->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
ocfs2-xattr-remove-useless-free-space-checking.patch
ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group-fix.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink-fix.patch
ocfs2-adjust-switch_case-syntax-at-o2net_state_change-fix.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
mm-remove-compressed-copy-from-zram-in-memory-fix-2-fix.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-tune-vm_committed_as-percpu_counter-batching-size-fix.patch
swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix.patch
mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages-fix.patch
mm-correctly-update-zone-managed_pages-fix.patch
mm-correctly-update-zone-managed_pages-fix-fix-fix.patch
clean-up-scary-strncpydst-src-strlensrc-uses-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
rtc-add-nxp-pcf2127-support-i2c-fix.patch
ptrace-add-ability-to-get-set-signal-blocked-mask-fix.patch
dev-oldmem-remove-the-interface-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
tools-testing-selftests-dont-assume-the-x-bit-is-set-on-scripts.patch

