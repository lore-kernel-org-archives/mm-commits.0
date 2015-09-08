From: akpm@linux-foundation.org
Subject: [folded-merged] memtest-cleanup-log-messages-fix.patch removed
 from -mm tree
Date: Tue, 08 Sep 2015 14:37:31 -0700
Message-ID: <55ef551b.METhHgOVOwGDiUs/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52597 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbbIHVhd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 17:37:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir.murzin@arm.com, leon@leon.nu, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memtest-cleanup-log-messages-fix
has been removed from the -mm tree.  Its filename was
     memtest-cleanup-log-messages-fix.patch

This patch was dropped because it was folded into memtest-cleanup-log-messages.patch

------------------------------------------------------
From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: memtest-cleanup-log-messages-fix

Cc: Leon Romanovsky <leon@leon.nu>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memtest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memtest.c~memtest-cleanup-log-messages-fix mm/memtest.c
--- a/mm/memtest.c~memtest-cleanup-log-messages-fix
+++ a/mm/memtest.c
@@ -31,7 +31,7 @@ static u64 patterns[] __initdata = {
 
 static void __init reserve_bad_mem(u64 pattern, phys_addr_t start_bad, phys_addr_t end_bad)
 {
-	pr_info("%016llx bad mem addr %pa - %pa reserved\n",
+	pr_info("  %016llx bad mem addr %pa - %pa reserved\n",
 		cpu_to_be64(pattern), &start_bad, &end_bad);
 	memblock_reserve(start_bad, end_bad - start_bad);
 }
_

Patches currently in -mm which might be from vladimir.murzin@arm.com are

memtest-use-kstrtouint-instead-of-simple_strtoul.patch
memtest-cleanup-log-messages.patch
memtest-remove-unused-header-files.patch

