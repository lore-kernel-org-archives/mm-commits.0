From: akpm@linux-foundation.org
Subject: +
 mm-remove-dummy-struct-bootmem_data-bootmem_data_t.patch added to -mm tree
Date: Thu, 26 Mar 2020 13:10:42 -0700
Message-ID: <20200326201042.UMKWdLTEz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726363AbgCZUKn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 26 Mar 2020 16:10:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, longman@redhat.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com


The patch titled
     Subject: mm: Remove dummy struct bootmem_data/bootmem_data_t
has been added to the -mm tree.  Its filename is
     mm-remove-dummy-struct-bootmem_data-bootmem_data_t.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-dummy-struct-bootmem_data-bootmem_data_t.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-dummy-struct-bootmem_data-bootmem_data_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm: Remove dummy struct bootmem_data/bootmem_data_t

Both bootmem_data and bootmem_data_t structures are no longer defined.
Remove the dummy forward declarations.

Link: http://lkml.kernel.org/r/20200326022617.26208-1-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/mmzone.h |    2 --
 include/linux/mmzone.h          |    1 -
 2 files changed, 3 deletions(-)

--- a/arch/alpha/include/asm/mmzone.h~mm-remove-dummy-struct-bootmem_data-bootmem_data_t
+++ a/arch/alpha/include/asm/mmzone.h
@@ -8,8 +8,6 @@
 
 #include <asm/smp.h>
 
-struct bootmem_data_t; /* stupid forward decl. */
