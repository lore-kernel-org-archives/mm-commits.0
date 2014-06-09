From: akpm@linux-foundation.org
Subject: [merged] mm-kmemleakc-use-%u-to-print-checksum.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:40:26 -0700
Message-ID: <53960daa.qeT+Etz+12mHhtaU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54349 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaFITk0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:40:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, catalin.marinas@arm.com, majianpeng@gmail.com

Subject: [merged] mm-kmemleakc-use-%u-to-print-checksum.patch removed from -mm tree
To: majianpeng@gmail.com,catalin.marinas@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:40:26 -0700


The patch titled
     Subject: mm/kmemleak.c: use %u to print ->checksum
has been removed from the -mm tree.  Its filename was
     mm-kmemleakc-use-%u-to-print-checksum.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jianpeng Ma <majianpeng@gmail.com>
Subject: mm/kmemleak.c: use %u to print ->checksum

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/kmemleak.c~mm-kmemleakc-use-%u-to-print-checksum mm/kmemleak.c
--- a/mm/kmemleak.c~mm-kmemleakc-use-%u-to-print-checksum
+++ a/mm/kmemleak.c
@@ -387,7 +387,7 @@ static void dump_object_info(struct kmem
 	pr_notice("  min_count = %d\n", object->min_count);
 	pr_notice("  count = %d\n", object->count);
 	pr_notice("  flags = 0x%lx\n", object->flags);
-	pr_notice("  checksum = %d\n", object->checksum);
+	pr_notice("  checksum = %u\n", object->checksum);
 	pr_notice("  backtrace:\n");
 	print_stack_trace(&trace, 4);
 }
_

Patches currently in -mm which might be from majianpeng@gmail.com are

origin.patch

