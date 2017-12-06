From: akpm@linux-foundation.org
Subject: + mm-remove-duplicate-includes.patch added to -mm tree
Date: Wed, 06 Dec 2017 15:31:07 -0800
Message-ID: <5a287dbb.A6PndYgqvyx/t+4e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36724 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751990AbdLFXbI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2017 18:31:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pravin.shedge4linux@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/userfaultfd.c: remove duplicate include
has been added to the -mm tree.  Its filename is
     mm-remove-duplicate-includes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-duplicate-includes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-duplicate-includes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-remove-duplicate-includes.patch

