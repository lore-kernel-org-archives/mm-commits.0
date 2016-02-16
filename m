From: akpm@linux-foundation.org
Subject: [merged] mm-fix-filemapc-kernel-doc-warning.patch removed from
 -mm tree
Date: Tue, 16 Feb 2016 10:48:58 -0800
Message-ID: <56c36f1a.o6bLZ2hHUk5XcVOR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210AbcBPSs6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Feb 2016 13:48:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix filemap.c kernel doc warning
has been removed from the -mm tree.  Its filename was
     mm-fix-filemapc-kernel-doc-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm: fix filemap.c kernel doc warning

Add missing kernel-doc notation for function parameter 'gfp_mask' to
fix kernel-doc warning.

..//mm/filemap.c:1898: warning: No description found for parameter 'gfp_mask'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/filemap.c~mm-fix-filemapc-kernel-doc-warning mm/filemap.c
--- a/mm/filemap.c~mm-fix-filemapc-kernel-doc-warning
+++ a/mm/filemap.c
@@ -1890,6 +1890,7 @@ EXPORT_SYMBOL(generic_file_read_iter);
  * page_cache_read - adds requested page to the page cache if not already there
  * @file:	file to read
  * @offset:	page index
+ * @gfp_mask:	memory allocation flags
  *
  * This adds the requested page to the page cache if it isn't already there,
  * and schedules an I/O to read in its contents from disk.
_

Patches currently in -mm which might be from rdunlap@infradead.org are


