From: akpm@linux-foundation.org
Subject: [merged] maccess-update-the-top-of-file-comment.patch
 removed from -mm tree
Date: Tue, 09 Jun 2020 17:40:01 -0700
Message-ID: <20200610004001.LpW4k606G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbgFJAkC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:40:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net, hch@lst.de, hpa@zytor.com, mhiramat@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: maccess: update the top of file comment
has been removed from the -mm tree.  Its filename was
     maccess-update-the-top-of-file-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: maccess: update the top of file comment

This file now also contains several helpers for accessing user memory.

Link: http://lkml.kernel.org/r/20200521152301.2587579-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/maccess.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/maccess.c~maccess-update-the-top-of-file-comment
+++ a/mm/maccess.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Access kernel memory without faulting.
+ * Access kernel or user memory without faulting.
  */
 #include <linux/export.h>
 #include <linux/mm.h>
_

Patches currently in -mm which might be from hch@lst.de are

amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch
kernel-move-use_mm-unuse_mm-to-kthreadc.patch
kernel-move-use_mm-unuse_mm-to-kthreadc-v2.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch
kernel-set-user_ds-in-kthread_use_mm.patch
