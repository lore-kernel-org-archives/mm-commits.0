From: akpm@linux-foundation.org
Subject: - mm-utilc-must-include-linux-schedh.patch removed from -mm tree
Date: Mon, 28 Jul 2008 14:10:56 -0700
Message-ID: <200807282110.m6SLAuIG027612@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760994AbYG1VLe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 17:11:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm/util.c must #include <linux/sched.h>
has been removed from the -mm tree.  Its filename was
     mm-utilc-must-include-linux-schedh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/util.c must #include <linux/sched.h>
From: Adrian Bunk <bunk@kernel.org>

/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/util.c: In function 'arch_pick_mmap_layout':
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/util.c:144: error: dereferencing pointer to incomplete type
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/util.c:145: error: 'arch_get_unmapped_area' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/util.c:145: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/util.c:145: error: for each function it appears in.)
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/util.c:146: error: 'arch_unmap_area' undeclared (first use in this function)

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/util.c~mm-utilc-must-include-linux-schedh mm/util.c
--- a/mm/util.c~mm-utilc-must-include-linux-schedh
+++ a/mm/util.c
@@ -3,6 +3,7 @@
 #include <linux/string.h>
 #include <linux/module.h>
 #include <linux/err.h>
+#include <linux/sched.h>
 #include <asm/uaccess.h>
 
 /**
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
exec-include-pagemaph-again-to-fix-build.patch
mm-hugetlbc-must-include-asm-ioh.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
reiser4.patch

