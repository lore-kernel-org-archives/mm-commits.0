From: akpm@linux-foundation.org
Subject: + mm-memblock-small-function-definition-fixes.patch added to -mm tree
Date: Fri, 26 Aug 2011 16:21:24 -0700
Message-ID: <201108262321.p7QNLO9Y018508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936Ab1HZXV2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 19:21:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jhbird.choi@samsung.com


The patch titled
     mm/memblock.c: small function definition fixes
has been added to the -mm tree.  Its filename is
     mm-memblock-small-function-definition-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/memblock.c: small function definition fixes
From: Jonghwan Choi <jhbird.choi@samsung.com>

warning: function 'memblock_memory_can_coalesce'
with external linkage has definition.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memblock.c~mm-memblock-small-function-definition-fixes mm/memblock.c
--- a/mm/memblock.c~mm-memblock-small-function-definition-fixes
+++ a/mm/memblock.c
@@ -267,7 +267,7 @@ static int __init_memblock memblock_doub
 	return 0;
 }
 
-extern int __init_memblock __weak memblock_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
+int __init_memblock __weak memblock_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
 					  phys_addr_t addr2, phys_addr_t size2)
 {
 	return 1;
_

Patches currently in -mm which might be from jhbird.choi@samsung.com are

linux-next.patch
mm-memblock-small-function-definition-fixes.patch

