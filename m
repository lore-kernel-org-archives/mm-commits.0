From: akpm@linux-foundation.org
Subject: [folded-merged]
 mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch removed from -mm
 tree
Date: Mon, 08 Jun 2020 20:18:35 -0700
Message-ID: <20200609031835.yT_t2SnrH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgFIDSi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 23:18:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.m.jordan@oracle.com, dbueso@suse.de, hughd@google.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, ldufour@linux.ibm.com, Liam.Howlett@oracle.com, mm-commits@vger.kernel.org, peterz@infradead.org, rientjes@google.com, vbabka@suse.cz, walken@google.com, willy@infradead.org, yinghan@google.com


The patch titled
     Subject: mmap-locking-api-convert-mmap_sem-comments-fix-fix
has been removed from the -mm tree.  Its filename was
     mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch

This patch was dropped because it was folded into mmap-locking-api-convert-mmap_sem-comments.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmap-locking-api-convert-mmap_sem-comments-fix-fix

s/lockaphore/lock/, per Vlastimil

Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mmap-locking-api-convert-mmap_sem-comments-fix-fix
+++ a/mm/mempolicy.c
@@ -224,7 +224,7 @@ static int mpol_new_bind(struct mempolic
  * handle an empty nodemask with MPOL_PREFERRED here.
  *
  * Must be called holding task's alloc_lock to protect task's mems_allowed
- * and mempolicy.  May also be called holding the mmap_lockaphore for write.
+ * and mempolicy.  May also be called holding the mmap_lock for write.
  */
 static int mpol_set_nodemask(struct mempolicy *pol,
 		     const nodemask_t *nodes, struct nodemask_scratch *nsc)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mmap-locking-api-convert-mmap_sem-comments.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch
maccess-unify-the-probe-kernel-arch-hooks-fix.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
lib-test-get_count_order-long-in-test_bitopsc-fix.patch
lib-test-get_count_order-long-in-test_bitopsc-fix-fix.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-git-rejects.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
