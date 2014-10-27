From: akpm@linux-foundation.org
Subject: + mm-cma-make-kmemleak-ignore-cma-regions-fix-fix-fix.patch added to -mm tree
Date: Mon, 27 Oct 2014 13:05:41 -0700
Message-ID: <544ea595.PeYsRf7cm7tgUvA/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39015 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbaJ0UFk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Oct 2014 16:05:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma: include linux/io.h for phys_to_virt()
has been added to the -mm tree.  Its filename is
     mm-cma-make-kmemleak-ignore-cma-regions-fix-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-make-kmemleak-ignore-cma-regions-fix-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-make-kmemleak-ignore-cma-regions-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm/cma: include linux/io.h for phys_to_virt()

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thierry Reding <treding@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/cma.c~mm-cma-make-kmemleak-ignore-cma-regions-fix-fix-fix mm/cma.c
--- a/mm/cma.c~mm-cma-make-kmemleak-ignore-cma-regions-fix-fix-fix
+++ a/mm/cma.c
@@ -33,6 +33,7 @@
 #include <linux/log2.h>
 #include <linux/cma.h>
 #include <linux/highmem.h>
+#include <linux/io.h>
 
 struct cma {
 	unsigned long	base_pfn;
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

drivers-of-add-return-value-to-of_reserved_mem_device_init.patch
mm-cma-make-kmemleak-ignore-cma-regions-fix-fix-fix.patch
mm-memcontrol-lockless-page-counters-fix-2.patch
gcov-enable-gcov_profile_all-from-arch-kconfigs.patch
kernel-forkc-export-kernel_thread-to-modules.patch

