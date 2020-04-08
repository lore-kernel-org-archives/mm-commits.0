From: akpm@linux-foundation.org
Subject: [merged]
 mm-remove-dummy-struct-bootmem_data-bootmem_data_t.patch removed from -mm
 tree
Date: Tue, 07 Apr 2020 19:00:07 -0700
Message-ID: <20200408020007.NY2Aed0jG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgDHCAJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:00:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, longman@redhat.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com


The patch titled
     Subject: mm: remove dummy struct bootmem_data/bootmem_data_t
has been removed from the -mm tree.  Its filename was
     mm-remove-dummy-struct-bootmem_data-bootmem_data_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm: remove dummy struct bootmem_data/bootmem_data_t

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
