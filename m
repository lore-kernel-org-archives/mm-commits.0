From: akpm@linux-foundation.org
Subject: + buffer-kill-old-incorrect-comment.patch added to -mm tree
Date: Thu, 31 May 2007 16:15:28 -0700
Message-ID: <200705312315.l4VNFSXH030428@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822AbXEaXPa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2007 19:15:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, nickpiggin@yahoo.com.au


The patch titled
     buffer: kill old incorrect comment
has been added to the -mm tree.  Its filename is
     buffer-kill-old-incorrect-comment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: buffer: kill old incorrect comment
From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    5 -----
 1 files changed, 5 deletions(-)

diff -puN fs/buffer.c~buffer-kill-old-incorrect-comment fs/buffer.c
--- a/fs/buffer.c~buffer-kill-old-incorrect-comment
+++ a/fs/buffer.c
@@ -1048,11 +1048,6 @@ failed:
 /*
  * Create buffers for the specified block device block's page.  If
  * that page was dirty, the buffers are set dirty also.
- *
- * Except that's a bug.  Attaching dirty buffers to a dirty
- * blockdev's page can result in filesystem corruption, because
- * some of those buffers may be aliases of filesystem data.
- * grow_dev_page() will go BUG() if this happens.
  */
 static int
 grow_buffers(struct block_device *bdev, sector_t block, int size)
_

Patches currently in -mm which might be from ebiederm@xmission.com are

dvb_en_50221-convert-to-kthread-api.patch
fix-i-oat-for-kexec.patch
pci-disable-msi-by-default-on-systems-with-serverworks-ht1000-chips.patch
fix-x86_64-mm-xen-core-xen-implementation.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3-fix.patch
msi-fix-the-ordering-of-msix-irqs.patch
msi-mask-the-msix-vector-before-we-unmap-it.patch
aacraid-fix-shutdown-handler-to-also-disable-interrupts.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
preserve-the-dirty-bit-in-init_page_buffers.patch
rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty.patch
rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty-fix.patch
rd-simplify-by-using-the-same-helper-functions-in-libfs.patch
rd-remove-ramdisk_set_page_dirty.patch
rd-remove-ramdisk_set_page_dirty-fix.patch
buffer-kill-old-incorrect-comment.patch
containersv10-basic-container-framework.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface.patch
containersv10-add-procfs-interface-fix.patch
containersv10-make-cpusets-a-client-of-containers.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch
