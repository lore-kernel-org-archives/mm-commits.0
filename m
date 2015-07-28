From: akpm@linux-foundation.org
Subject: + mm-srcu-ify-shrinkers-fix.patch added to -mm tree
Date: Tue, 28 Jul 2015 15:47:12 -0700
Message-ID: <55b80670.rrjPDDoW0qXQOVwv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbbG1WrO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jul 2015 18:47:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-srcu-ify-shrinkers-fix
has been added to the -mm tree.  Its filename is
     mm-srcu-ify-shrinkers-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-srcu-ify-shrinkers-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-srcu-ify-shrinkers-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm-srcu-ify-shrinkers-fix

temp

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/Kconfig~mm-srcu-ify-shrinkers-fix arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~mm-srcu-ify-shrinkers-fix
+++ a/arch/powerpc/Kconfig
@@ -124,6 +124,7 @@ config PPC
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_SHOW_LEVEL
 	select IRQ_FORCED_THREADING
+	select SRCU
 	select HAVE_RCU_TABLE_FREE if SMP
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_BPF_JIT
_

Patches currently in -mm which might be from dave@stgolabs.net are

ipc-use-private-shmem-or-hugetlbfs-inodes-for-shm-segments.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add.patch
mm-hugetlb-add-region_del-to-delete-a-specific-range-of-entries.patch
mm-hugetlb-expose-hugetlb-fault-mutex-for-use-by-fallocate.patch
hugetlbfs-hugetlb_vmtruncate_list-needs-to-take-a-range-to-delete.patch
hugetlbfs-truncate_hugepages-takes-a-range-of-pages.patch
mm-hugetlb-vma_has_reserves-needs-to-handle-fallocate-hole-punch.patch
mm-hugetlb-alloc_huge_page-handle-areas-hole-punched-by-fallocate.patch
hugetlbfs-new-huge_add_to_page_cache-helper-routine.patch
hugetlbfs-add-hugetlbfs_fallocate.patch
mm-madvise-allow-remove-operation-for-hugetlbfs.patch
mm-srcu-ify-shrinkers.patch
mm-srcu-ify-shrinkers-fix.patch
ipc-convert-invalid-scenarios-to-use-warn_on.patch
linux-next.patch

