From: akpm@linux-foundation.org
Subject: [folded-merged]
 userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix.patch removed from -mm tree
Date: Fri, 04 Sep 2015 15:28:51 -0700
Message-ID: <55ea1b23.XGIuhImm502+wIk7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760159AbbIDW2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:28:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: documentation update
has been removed from the -mm tree.  Its filename was
     userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix.patch

This patch was dropped because it was folded into userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: documentation update

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/userfaultfd.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN Documentation/vm/userfaultfd.txt~userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix Documentation/vm/userfaultfd.txt
--- a/Documentation/vm/userfaultfd.txt~userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix
+++ a/Documentation/vm/userfaultfd.txt
@@ -47,10 +47,10 @@ When first opened the userfaultfd must b
 UFFDIO_API ioctl specifying a uffdio_api.api value set to UFFD_API (or
 a later API version) which will specify the read/POLLIN protocol
 userland intends to speak on the UFFD and the uffdio_api.features
-userland needs to be enabled. The UFFDIO_API ioctl if successful
-(i.e. if the requested uffdio_api.api is spoken also by the running
-kernel and the requested features are going to be enabled) will return
-into uffdio_api.features and uffdio_api.ioctls two 64bit bitmasks of
+userland requires. The UFFDIO_API ioctl if successful (i.e. if the
+requested uffdio_api.api is spoken also by the running kernel and the
+requested features are going to be enabled) will return into
+uffdio_api.features and uffdio_api.ioctls two 64bit bitmasks of
 respectively all the available features of the read(2) protocol and
 the generic ioctl available.
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-uapi.patch
userfaultfd-linux-userfaultfd_kh.patch
userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch
userfaultfd-add-vm_uffd_missing-and-vm_uffd_wp.patch
userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch
userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch
userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-wake-pending-userfaults.patch
userfaultfd-optimize-read-and-poll-to-be-o1.patch
userfaultfd-optimize-read-and-poll-to-be-o1-fix.patch
userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch
userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
userfaultfd-buildsystem-activation.patch
userfaultfd-activate-syscall.patch
userfaultfd-uffdio_copyuffdio_zeropage-uapi.patch
userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
userfaultfd-require-uffdio_api-before-other-ioctls.patch
userfaultfd-allow-signals-to-interrupt-a-userfault.patch
userfaultfd-propagate-the-full-address-in-thp-faults.patch
userfaultfd-avoid-missing-wakeups-during-refile-in-userfaultfd_read.patch
userfaultfd-selftest.patch

