From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 092/166] mm: remove dummy struct
 bootmem_data/bootmem_data_t
Date: Mon, 06 Apr 2020 20:08:52 -0700
Message-ID: <20200407030852.KHI7DY_U7%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbgDGDIx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:08:53 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, linux-mm@kvack.org, longman@redhat.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com, torvalds@linux-foundation.org

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
