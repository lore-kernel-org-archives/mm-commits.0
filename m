From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 22 Dec 2014 11:23:03 -0800
Message-ID: <54986f97.nro5O2mYeazuc1Ho%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaLVTXE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Dec 2014 14:23:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_pci_common.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN drivers/virtio/virtio_pci_common.c~linux-next-git-rejects drivers/virtio/virtio_pci_common.c
--- a/drivers/virtio/virtio_pci_common.c~linux-next-git-rejects
+++ a/drivers/virtio/virtio_pci_common.c
@@ -494,11 +494,3 @@ static struct pci_driver virtio_pci_driv
 };
 
 module_pci_driver(virtio_pci_driver);
-<<<<<<< HEAD
-
-MODULE_AUTHOR("Anthony Liguori <aliguori@us.ibm.com>");
-MODULE_DESCRIPTION("virtio-pci");
-MODULE_LICENSE("GPL");
-MODULE_VERSION("1");
-=======
->>>>>>> linux-next/akpm-base
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

