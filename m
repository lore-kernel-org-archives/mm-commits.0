From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix.patch
 removed from -mm tree
Date: Wed, 06 Sep 2017 16:09:48 -0700
Message-ID: <59b0803c.7TCgUl2PHH/a2qSl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47684 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752351AbdIFXJt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:09:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mhocko@suse.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix
has been removed from the -mm tree.  Its filename was
     mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix.patch

This patch was dropped because it was folded into mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently.patch

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix

This needs an incremental one liner...

Link: http://lkml.kernel.org/r/20170726164319.GC29716@redhat.com
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/mmap.c~mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix mm/mmap.c
--- a/mm/mmap.c~mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix
+++ a/mm/mmap.c
@@ -44,6 +44,7 @@
 #include <linux/userfaultfd_k.h>
 #include <linux/moduleparam.h>
 #include <linux/pkeys.h>
+#include <linux/oom.h>
 
 #include <linux/uaccess.h>
 #include <asm/cacheflush.h>
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist.patch
userfaultfd-selftest-explicit-failure-if-the-sigbus-test-failed.patch
userfaultfd-call-userfaultfd_unmap_prep-only-if-__split_vma-succeeds.patch
userfaultfd-provide-pid-in-userfault-msg-add-feat-union.patch
mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently.patch
mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix-3.patch

