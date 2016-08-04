From: akpm@linux-foundation.org
Subject: [patch 2/7] mm/memblock: fix a typo in a comment
Date: Thu, 04 Aug 2016 15:31:46 -0700
Message-ID: <57a3c252.HsKrusgAclSWL7J5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759224AbcHDWbr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Aug 2016 18:31:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kuleshovmail@gmail.com

From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/memblock: fix a typo in a comment

s/accomodate/accommodate

Link: http://lkml.kernel.org/r/20160804121824.18100-1-kuleshovmail@gmail.com
Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memblock.c~mm-memblock-fix-a-typo-in-a-comment mm/memblock.c
--- a/mm/memblock.c~mm-memblock-fix-a-typo-in-a-comment
+++ a/mm/memblock.c
@@ -482,7 +482,7 @@ static void __init_memblock memblock_mer
  * @flags:	flags of the new region
  *
  * Insert new memblock region [@base,@base+@size) into @type at @idx.
- * @type must already have extra room to accomodate the new region.
+ * @type must already have extra room to accommodate the new region.
  */
 static void __init_memblock memblock_insert_region(struct memblock_type *type,
 						   int idx, phys_addr_t base,
@@ -544,7 +544,7 @@ repeat:
 	/*
 	 * The following is executed twice.  Once with %false @insert and
 	 * then with %true.  The first counts the number of regions needed
-	 * to accomodate the new area.  The second actually inserts them.
+	 * to accommodate the new area.  The second actually inserts them.
 	 */
 	base = obase;
 	nr_new = 0;
_
