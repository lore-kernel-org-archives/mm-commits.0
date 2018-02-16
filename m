From: akpm@linux-foundation.org
Subject: +
 mm-dont-defer-struct-page-initialization-for-xen-pv-guests-fix.patch added
 to -mm tree
Date: Fri, 16 Feb 2018 12:44:20 -0800
Message-ID: <5a8742a4.6kPScM/TSPaGS7V9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49918 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751091AbeBPUoV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 15:44:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jgross@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-dont-defer-struct-page-initialization-for-xen-pv-guests-fix
has been added to the -mm tree.  Its filename is
     mm-dont-defer-struct-page-initialization-for-xen-pv-guests-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dont-defer-struct-page-initialization-for-xen-pv-guests-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-defer-struct-page-initialization-for-xen-pv-guests-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-dont-defer-struct-page-initialization-for-xen-pv-guests-fix

explicitly include xen.h

Cc: Juergen Gross <jgross@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/page_alloc.c~mm-dont-defer-struct-page-initialization-for-xen-pv-guests-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-dont-defer-struct-page-initialization-for-xen-pv-guests-fix
+++ a/mm/page_alloc.c
@@ -46,6 +46,7 @@
 #include <linux/stop_machine.h>
 #include <linux/sort.h>
 #include <linux/pfn.h>
+#include <xen/xen.h>
 #include <linux/backing-dev.h>
 #include <linux/fault-inject.h>
 #include <linux/page-isolation.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
include-linux-sched-mmh-re-inline-mmdrop.patch
mm-zpool-zpool_evictable-fix-mismatch-in-parameter-name-and-kernel-doc-fix.patch
vmalloc-fix-__gfp_highmem-usage-for-vmalloc_32-on-32b-systems-checkpatch-fixes.patch
mm-dont-defer-struct-page-initialization-for-xen-pv-guests-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

