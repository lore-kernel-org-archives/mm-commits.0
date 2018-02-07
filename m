From: akpm@linux-foundation.org
Subject: [merged] mm-remove-duplicate-includes.patch removed from
 -mm tree
Date: Wed, 07 Feb 2018 11:59:29 -0800
Message-ID: <20180207195929.FTCF_jI5V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60346 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754531AbeBGT7a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:59:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, mm-commits@vger.kernel.org, pravin.shedge4linux@gmail.com


The patch titled
     Subject: mm/userfaultfd.c: remove duplicate include
has been removed from the -mm tree.  Its filename was
     mm-remove-duplicate-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pravin Shedge <pravin.shedge4linux@gmail.com>
Subject: mm/userfaultfd.c: remove duplicate include

These duplicate includes have been found with scripts/checkincludes.pl but
they have been removed manually to avoid removing false positives.

Link: http://lkml.kernel.org/r/1512580957-6071-1-git-send-email-pravin.shedge4linux@gmail.com
Signed-off-by: Pravin Shedge <pravin.shedge4linux@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/userfaultfd.c~mm-remove-duplicate-includes mm/userfaultfd.c
--- a/mm/userfaultfd.c~mm-remove-duplicate-includes
+++ a/mm/userfaultfd.c
@@ -16,7 +16,6 @@
 #include <linux/userfaultfd_k.h>
 #include <linux/mmu_notifier.h>
 #include <linux/hugetlb.h>
-#include <linux/pagemap.h>
 #include <linux/shmem_fs.h>
 #include <asm/tlbflush.h>
 #include "internal.h"
_

Patches currently in -mm which might be from pravin.shedge4linux@gmail.com are


