From: akpm@linux-foundation.org
Subject: [folded-merged]
 hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch removed from -mm tree
Date: Thu, 03 Apr 2014 14:13:57 -0700
Message-ID: <533dcf15.sQXsOOSEx49plcZj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbaDCVN6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:13:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sougata@tuxera.com, slava@dubeyko.com, khoroshilov@ispras.ru, hch@lst.de, akpm@linux-foundation.org

Subject: [folded-merged] hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,hch@lst.de,khoroshilov@ispras.ru,slava@dubeyko.com,sougata@tuxera.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:13:57 -0700


The patch titled
     Subject: hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix
has been removed from the -mm tree.  Its filename was
     hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch

This patch was dropped because it was folded into hfsplus-fix-concurrent-acess-of-alloc_blocks.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix

remove now-unused label `out'

Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sougata Santra <sougata@tuxera.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/extents.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/hfsplus/extents.c~hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix fs/hfsplus/extents.c
--- a/fs/hfsplus/extents.c~hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix
+++ a/fs/hfsplus/extents.c
@@ -598,7 +598,6 @@ void hfsplus_file_truncate(struct inode
 	hip->alloc_blocks = blk_cnt;
 out_unlock:
 	mutex_unlock(&hip->extents_lock);
-out:
 	hip->phys_size = inode->i_size;
 	hip->fs_blocks = (inode->i_size + sb->s_blocksize - 1) >>
 		sb->s_blocksize_bits;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fanotify-use-fanotify-event-structure-for-permission-response-processing.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch
ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-vmstat-fix-up-zone-state-accounting.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-process_vm_accessc-mark-function-as-static.patch
drop_caches-add-some-documentation-and-info-message.patch
sys_sysfs-add-config_sysfs_syscall.patch
kernel-groupsc-remove-return-value-of-set_groups.patch
xattr-guard-against-simultaneous-glibc-header-inclusion-v2.patch
lib-syscallc-unexport-task_current_syscall.patch
scripts-checkpatchpl-__gfp_nofail-isnt-going-away.patch
rtc-fixed-potential-race-condition.patch
befs-logging-clean-up.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks.patch

