From: akpm@linux-foundation.org
Subject: - slb-drop-kmem-cache-argument-from-constructor-ubifs.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:59:46 -0700
Message-ID: <200807252359.m6PNxkbv006276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538AbYGZAAm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 20:00:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Artem.Bityutskiy@nokia.com, adobriyan@gmail.com, cl@linux-foundation.org, kniht@linux.vnet.ibm.com, mpm@selenic.com, nickpiggin@yahoo.com.au, penberg@cs.hel


The patch titled
     slb-drop-kmem-cache-argument-from-constructor-ubifs
has been removed from the -mm tree.  Its filename was
     slb-drop-kmem-cache-argument-from-constructor-ubifs.patch

This patch was dropped because it was folded into slb-drop-kmem-cache-argument-from-constructor.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slb-drop-kmem-cache-argument-from-constructor-ubifs
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Jon Tollefson <kniht@linux.vnet.ibm.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ubifs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ubifs/super.c~slb-drop-kmem-cache-argument-from-constructor-ubifs fs/ubifs/super.c
--- a/fs/ubifs/super.c~slb-drop-kmem-cache-argument-from-constructor-ubifs
+++ a/fs/ubifs/super.c
@@ -1843,7 +1843,7 @@ static struct file_system_type ubifs_fs_
 /*
  * Inode slab cache constructor.
  */
-static void inode_slab_ctor(struct kmem_cache *cachep, void *obj)
+static void inode_slab_ctor(void *obj)
 {
 	struct ubifs_inode *ui = obj;
 	inode_init_once(&ui->vfs_inode);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
uninline-arch_pick_mmap_layout.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary.patch
tpm-increase-size-of-internal-tpm-response-buffers.patch
memstick-allow-set_param-method-to-return-an-error-code.patch
memstick-use-fully-asynchronous-request-processing.patch
full-conversion-to-early_initcall-interface-remove-old-interface.patch
mm-introduce-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast.patch
mm-speculative-page-references.patch
slb-drop-kmem-cache-argument-from-constructor.patch
slb-drop-kmem-cache-argument-from-constructor-ubifs.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

