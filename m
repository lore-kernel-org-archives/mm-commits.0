From: akpm@linux-foundation.org
Subject: - mm-page_allocc-lower-printk-severity.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:49:46 -0700
Message-ID: <200707162049.l6GKnkDZ001190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56284 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756754AbXGPVSt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:18:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: da-x@monatomic.org, mm-commits@vger.kernel.org


The patch titled
     mm/page_alloc.c: lower printk severity
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-lower-printk-severity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm/page_alloc.c: lower printk severity
From: Dan Aloni <da-x@monatomic.org>

Signed-off-by: Dan Aloni <da-x@monatomic.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_allocc-lower-printk-severity mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-lower-printk-severity
+++ a/mm/page_alloc.c
@@ -3605,7 +3605,7 @@ void *__init alloc_large_system_hash(con
 	if (!table)
 		panic("Failed to allocate %s hash table\n", tablename);
 
-	printk("%s hash table entries: %d (order: %d, %lu bytes)\n",
+	printk(KERN_INFO "%s hash table entries: %d (order: %d, %lu bytes)\n",
 	       tablename,
 	       (1U << log2qty),
 	       ilog2(size) - PAGE_SHIFT,
_

Patches currently in -mm which might be from da-x@monatomic.org are

origin.patch
drivers-acpi-pci_linkc-lower-printk-severity.patch
arch-x86_64-kernel-processc-lower-printk-severity.patch
arch-x86_64-kernel-aperturec-lower-printk-severity.patch
arch-x86_64-kernel-e820c-lower-printk-severity.patch
