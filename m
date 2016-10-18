From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-use-kern_cont-where-appropriate-checkpatch-fixes.patch added
 to -mm tree
Date: Tue, 18 Oct 2016 12:59:39 -0700
Message-ID: <58067f2b.CUV636+T1KcvVEY2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55722 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756486AbcJRT7k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2016 15:59:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-use-kern_cont-where-appropriate-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-page_alloc-use-kern_cont-where-appropriate-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-use-kern_cont-where-appropriate-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-use-kern_cont-where-appropriate-checkpatch-fixes.patch

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
Subject: mm-page_alloc-use-kern_cont-where-appropriate-checkpatch-fixes

WARNING: Prefer [subsystem eg: netdev]_cont([subsystem]dev, ... then dev_cont(dev, ... then pr_cont(...  to printk(KERN_CONT ...
#27: FILE: mm/page_alloc.c:4227:
+	printk(KERN_CONT "(%s) ", tmp);

WARNING: Prefer [subsystem eg: netdev]_cont([subsystem]dev, ... then dev_cont(dev, ... then pr_cont(...  to printk(KERN_CONT ...
#36: FILE: mm/page_alloc.c:4338:
+		printk(KERN_CONT

ERROR: code indent should use tabs where possible
#37: FILE: mm/page_alloc.c:4339:
+^I^I        "%s"$

WARNING: Prefer [subsystem eg: netdev]_cont([subsystem]dev, ... then dev_cont(dev, ... then pr_cont(...  to printk(KERN_CONT ...
#47: FILE: mm/page_alloc.c:4386:
+			printk(KERN_CONT " %ld", zone->lowmem_reserve[i]);

WARNING: Prefer [subsystem eg: netdev]_cont([subsystem]dev, ... then dev_cont(dev, ... then pr_cont(...  to printk(KERN_CONT ...
#48: FILE: mm/page_alloc.c:4387:
+		printk(KERN_CONT "\n");

WARNING: Prefer [subsystem eg: netdev]_cont([subsystem]dev, ... then dev_cont(dev, ... then pr_cont(...  to printk(KERN_CONT ...
#57: FILE: mm/page_alloc.c:4398:
+		printk(KERN_CONT "%s: ", zone->name);

WARNING: Prefer [subsystem eg: netdev]_cont([subsystem]dev, ... then dev_cont(dev, ... then pr_cont(...  to printk(KERN_CONT ...
#66: FILE: mm/page_alloc.c:4416:
+			printk(KERN_CONT "%lu*%lukB ",

WARNING: Prefer [subsystem eg: netdev]_cont([subsystem]dev, ... then dev_cont(dev, ... then pr_cont(...  to printk(KERN_CONT ...
#72: FILE: mm/page_alloc.c:4421:
+		printk(KERN_CONT "= %lukB\n", K(total));

total: 1 errors, 7 warnings, 49 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/mm-page_alloc-use-kern_cont-where-appropriate.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-use-kern_cont-where-appropriate-checkpatch-fixes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-use-kern_cont-where-appropriate-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -4336,7 +4336,7 @@ void show_free_areas(unsigned int filter
 
 		show_node(zone);
 		printk(KERN_CONT
-		        "%s"
+			"%s"
 			" free:%lukB"
 			" min:%lukB"
 			" low:%lukB"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-page_alloc-use-kern_cont-where-appropriate-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

