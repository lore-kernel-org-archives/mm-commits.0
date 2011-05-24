From: akpm@linux-foundation.org
Subject: + um-include-linux-prefetchh.patch added to -mm tree
Date: Tue, 24 May 2011 12:34:57 -0700
Message-ID: <201105241934.p4OJYvq2010626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756154Ab1EXTfF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 15:35:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at


The patch titled
     um: include linux/prefetch.h
has been added to the -mm tree.  Its filename is
     um-include-linux-prefetchh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: include linux/prefetch.h
From: Richard Weinberger <richard@nod.at>

Fix build failures on UML.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/processor-generic.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/um/include/asm/processor-generic.h~um-include-linux-prefetchh arch/um/include/asm/processor-generic.h
--- a/arch/um/include/asm/processor-generic.h~um-include-linux-prefetchh
+++ a/arch/um/include/asm/processor-generic.h
@@ -14,6 +14,8 @@ struct task_struct;
 #include "registers.h"
 #include "sysdep/archsetjmp.h"
 
+#include <linux/prefetch.h>
+
 struct mm_struct;
 
 struct thread_struct {
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch
mm-mmu_gather-rework.patch
powerpc-mmu_gather-rework.patch
sparc-mmu_gather-rework.patch
s390-mmu_gather-rework.patch
arm-mmu_gather-rework.patch
sh-mmu_gather-rework.patch
ia64-mmu_gather-rework.patch
um-mmu_gather-rework.patch
mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage.patch
mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code.patch
mm-extended-batches-for-generic-mmu_gather.patch
lockdep-mutex-provide-mutex_lock_nest_lock.patch
mm-remove-i_mmap_lock-lockbreak.patch
mm-convert-i_mmap_lock-to-a-mutex.patch
mm-revert-page_lock_anon_vma-lock-annotation.patch
mm-improve-page_lock_anon_vma-comment.patch
mm-use-refcounts-for-page_lock_anon_vma.patch
mm-convert-anon_vma-lock-to-a-mutex.patch
mm-optimize-page_lock_anon_vma-fast-path.patch
um-os_dump_core-cleanup.patch
um-fix-uml_lib_path.patch
um-remove-sighup-handler.patch
um-add-earlyprintk-support.patch
um-add-ucast-ethernet-transport.patch
um-print-info-about-fatal-segfaults.patch
um-include-linux-prefetchh.patch
um-fix-crash-while-os_dump_core.patch
remove-unused-proc_change_penalty-constant.patch
lib-consolidate-debug_stack_usage-option.patch

