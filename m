From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 14 Jan 2020 14:49:38 -0800
Message-ID: <20200114224938.mJBjKuoTh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728656AbgANWtj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Jan 2020 17:49:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/drivers.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/parisc/kernel/drivers.c~linux-next-git-rejects
+++ a/arch/parisc/kernel/drivers.c
@@ -889,11 +889,7 @@ static void print_parisc_device(struct p
 	static int count;
 
 	print_pa_hwpath(dev, hw_path);
-<<<<<<< HEAD
-	pr_info("%d. %s at %pap [%s] { %d, 0x%x, 0x%.3x, 0x%.5x }",
-=======
 	pr_info("%d. %s at %pa[p] [%s] { %d, 0x%x, 0x%.3x, 0x%.5x }",
->>>>>>> linux-next/akpm-base
 		++count, dev->name, &(dev->hpa.start), hw_path, dev->id.hw_type,
 		dev->id.hversion_rev, dev->id.hversion, dev->id.sversion);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-oom-avoid-printk-iteration-under-rcu-fix.patch
linux-next-rejects.patch
linux-next-fix.patch
drivers-block-null_blk_mainc-fix-layout.patch
drivers-block-null_blk_mainc-fix-uninitialized-var-warnings.patch
proc-convert-everything-to-struct-proc_ops-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch
