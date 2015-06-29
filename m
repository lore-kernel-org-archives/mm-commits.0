From: akpm@linux-foundation.org
Subject: [merged] maintainers-davidlohr-has-moved.patch removed from -mm
 tree
Date: Mon, 29 Jun 2015 13:47:51 -0700
Message-ID: <5591aef7.mshagzDrUkFTFk+l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbbF2Urw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:47:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bp@alien8.de, dave@stgolabs.net, rob@landley.net, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: Davidlohr has moved
has been removed from the -mm tree.  Its filename was
     maintainers-davidlohr-has-moved.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: MAINTAINERS: Davidlohr has moved

Reported-by: Rob Landley <rob@landley.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-davidlohr-has-moved MAINTAINERS
--- a/MAINTAINERS~maintainers-davidlohr-has-moved
+++ a/MAINTAINERS
@@ -4537,7 +4537,7 @@ S:	Maintained
 F:	drivers/media/usb/gspca/
 
 GUID PARTITION TABLE (GPT)
-M:	Davidlohr Bueso <davidlohr@hp.com>
+M:	Davidlohr Bueso <dave@stgolabs.net>
 L:	linux-efi@vger.kernel.org
 S:	Maintained
 F:	block/partitions/efi.*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3-fix.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
fs-userfaultfdc-work-around-i386-build-error.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
ipcshm-move-bug_on-check-into-shm_lock-fix.patch
scsi-resolve-sg-buffer-const-ness-issue-fix.patch
linux-next.patch
drivers-block-nvme-corec-fix-build-with-gcc-444.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

