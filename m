From: akpm@linux-foundation.org
Subject: [patch 086/114] mm/userfaultfd.c: remove duplicate include
Date: Tue, 06 Feb 2018 15:41:03 -0800
Message-ID: <20180206234103.iJslkJ-I2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55690 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932106AbeBFXlE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:41:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@kernel.org, mm-commits@vger.kernel.org, pravin.shedge4linux@gmail.com, torvalds@linux-foundation.org

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
