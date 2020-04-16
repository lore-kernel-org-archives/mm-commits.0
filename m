From: akpm@linux-foundation.org
Subject: +
 kernel-better-document-the-use_mm-unuse_mm-api-contract-fix.patch added to
 -mm tree
Date: Wed, 15 Apr 2020 17:52:12 -0700
Message-ID: <20200416005212.kjZuq-p7G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405166AbgDPAwN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Apr 2020 20:52:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, asml.silence@gmail.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-better-document-the-use_mm-unuse_mm-api-contract-fix
has been added to the -mm tree.  Its filename is
     kernel-better-document-the-use_mm-unuse_mm-api-contract-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-better-document-the-use_mm-unuse_mm-api-contract-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-better-document-the-use_mm-unuse_mm-api-contract-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-fix.patch
linux-next-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
