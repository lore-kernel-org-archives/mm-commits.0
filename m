From: akpm@linux-foundation.org
Subject: + mm-kmemleakc-use-%u-to-print-checksum.patch added to -mm tree
Date: Fri, 02 May 2014 15:49:13 -0700
Message-ID: <536420e9.C7qrf1dHGUitc/Vs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaEBWtO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2014 18:49:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, catalin.marinas@arm.com, majianpeng@gmail.com

Subject: + mm-kmemleakc-use-%u-to-print-checksum.patch added to -mm tree
To: majianpeng@gmail.com,catalin.marinas@arm.com
From: akpm@linux-foundation.org
Date: Fri, 02 May 2014 15:49:13 -0700


The patch titled
     Subject: mm/kmemleak.c: use %u to print ->checksum
has been added to the -mm tree.  Its filename is
     mm-kmemleakc-use-%u-to-print-checksum.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleakc-use-%u-to-print-checksum.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleakc-use-%u-to-print-checksum.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-kmemleakc-use-%u-to-print-checksum.patch

