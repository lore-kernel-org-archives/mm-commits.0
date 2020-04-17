From: akpm@linux-foundation.org
Subject: [alternative-merged]
 kernel-better-document-the-use_mm-unuse_mm-api-contract-fix.patch removed
 from -mm tree
Date: Fri, 17 Apr 2020 16:03:35 -0700
Message-ID: <20200417230335.jGWDjorcs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbgDQXDh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Apr 2020 19:03:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, asml.silence@gmail.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-better-document-the-use_mm-unuse_mm-api-contract-fix
has been removed from the -mm tree.  Its filename was
     kernel-better-document-the-use_mm-unuse_mm-api-contract-fix.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-better-document-the-use_mm-unuse_mm-api-contract-fix

fix kerneldoc, per Pavel

Cc: Christoph Hellwig <hch@lst.de>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kthread.c~kernel-better-document-the-use_mm-unuse_mm-api-contract-fix
+++ a/kernel/kthread.c
@@ -1239,7 +1239,7 @@ void kthread_use_mm(struct mm_struct *mm
 EXPORT_SYMBOL_GPL(kthread_use_mm);
 
 /**
- * kthread_use_mm - reverse the effect of kthread_use_mm()
+ * kthread_unuse_mm - reverse the effect of kthread_use_mm()
  * @mm: address space to operate on
  */
 void kthread_unuse_mm(struct mm_struct *mm)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-an-entry-for-kfifo-fix.patch
maintainers-add-an-entry-for-kfifo-fix-fix.patch
mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
linux-next-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
