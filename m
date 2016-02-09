From: akpm@linux-foundation.org
Subject: + mm-fix-filemapc-kernel-doc-warning.patch added to -mm tree
Date: Mon, 08 Feb 2016 16:22:50 -0800
Message-ID: <56b9315a.cZdprckibHSinRlQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53095 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933392AbcBIAWw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 19:22:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     From: Randy Dunlap <rdunlap@infradead.org>
has been added to the -mm tree.  Its filename is
     mm-fix-filemapc-kernel-doc-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-filemapc-kernel-doc-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-filemapc-kernel-doc-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>

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

mm-fix-filemapc-kernel-doc-warning.patch

