From: akpm@linux-foundation.org
Subject: [folded-merged]
 userfaultfd-rename-uffd_apibits-into-features-fixup.patch removed from -mm
 tree
Date: Fri, 04 Sep 2015 15:28:36 -0700
Message-ID: <55ea1b14.LLsE2oZwGK6+jLQy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760159AbbIDW2h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:28:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, dave.hansen@intel.com, dgilbert@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, luto@amacapital.net, mgorman@suse.de, pbonzini@redhat.com, peter.huangpeng@huawei.com, pfeiner@google.com, riel@redhat.com, sanidhya.gatech@gmail.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: rename uffd_api.bits into .features fixup
has been removed from the -mm tree.  Its filename was
     userfaultfd-rename-uffd_apibits-into-features-fixup.patch

This patch was dropped because it was folded into userfaultfd-rename-uffd_apibits-into-features.patch

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: rename uffd_api.bits into .features fixup

Update comment.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: zhang.zhanghailiang@huawei.com
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/userfaultfd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/uapi/linux/userfaultfd.h~userfaultfd-rename-uffd_apibits-into-features-fixup include/uapi/linux/userfaultfd.h
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-rename-uffd_apibits-into-features-fixup
+++ a/include/uapi/linux/userfaultfd.h
@@ -12,7 +12,7 @@
 #include <linux/types.h>
 
 #define UFFD_API ((__u64)0xAA)
-/* FIXME: add "|UFFD_BIT_WP" to UFFD_API_BITS after implementing it */
+/* FIXME: add "|UFFD_FEATURE_WP" to UFFD_API_FEATURES after implementing it */
 #define UFFD_API_FEATURES (UFFD_FEATURE_WRITE_BIT)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
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
userfaultfd-rename-uffd_apibits-into-features.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix.patch
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

