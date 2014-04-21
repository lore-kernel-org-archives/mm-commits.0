From: akpm@linux-foundation.org
Subject: [merged] mm-fix-new-kernel-doc-warning-in-filemapc.patch removed
 from -mm tree
Date: Mon, 21 Apr 2014 11:11:13 -0700
Message-ID: <53555f41.YFy+BcD9WuR5LaM1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35685 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbaDUSLN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 14:11:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org

Subject: [merged] mm-fix-new-kernel-doc-warning-in-filemapc.patch removed from -mm tree
To: rdunlap@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 11:11:13 -0700


The patch titled
     Subject: mm: fix new kernel-doc warning in filemap.c
has been removed from the -mm tree.  Its filename was
     mm-fix-new-kernel-doc-warning-in-filemapc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm: fix new kernel-doc warning in filemap.c

Fix new kernel-doc warning in mm/filemap.c:

Warning(mm/filemap.c:2600): Excess function parameter 'ppos' description in '__generic_file_aio_write'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/filemap.c~mm-fix-new-kernel-doc-warning-in-filemapc mm/filemap.c
--- a/mm/filemap.c~mm-fix-new-kernel-doc-warning-in-filemapc
+++ a/mm/filemap.c
@@ -2581,7 +2581,6 @@ EXPORT_SYMBOL(generic_perform_write);
  * @iocb:	IO state structure (file, offset, etc.)
  * @iov:	vector with data to write
  * @nr_segs:	number of segments in the vector
- * @ppos:	position where to write
  *
  * This function does all the work needed for actually writing data to a
  * file. It does all basic checks, removes SUID from the file, updates
_

Patches currently in -mm which might be from rdunlap@infradead.org are

documentation-submittingpatches-describe-the-fixes-tag.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

