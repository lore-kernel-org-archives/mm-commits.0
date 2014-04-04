From: akpm@linux-foundation.org
Subject: [merged] mm-mmapc-mark-function-as-static.patch removed from -mm
 tree
Date: Fri, 04 Apr 2014 12:31:42 -0700
Message-ID: <533f089e.RfXUSZ2+ZxqHF3kJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43056 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbaDDTbn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:31:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, riel@redhat.com, josh@joshtriplett.org, rashika.kheria@gmail.com

Subject: [merged] mm-mmapc-mark-function-as-static.patch removed from -mm tree
To: rashika.kheria@gmail.com,josh@joshtriplett.org,riel@redhat.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:31:42 -0700


The patch titled
     Subject: mm/mmap.c: mark function as static
has been removed from the -mm tree.  Its filename was
     mm-mmapc-mark-function-as-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: mm/mmap.c: mark function as static

Mark function as static in mmap.c because they are not used outside this
file.

This eliminates the following warning in mm/mmap.c:
mm/mmap.c:407:6: warning: no previous prototype for `validate_mm' [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-mmapc-mark-function-as-static mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-mark-function-as-static
+++ a/mm/mmap.c
@@ -405,7 +405,7 @@ static void validate_mm_rb(struct rb_roo
 	}
 }
 
-void validate_mm(struct mm_struct *mm)
+static void validate_mm(struct mm_struct *mm)
 {
 	int bug = 0;
 	int i = 0;
_

Patches currently in -mm which might be from rashika.kheria@gmail.com are

origin.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
linux-next.patch

