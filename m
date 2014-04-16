From: akpm@linux-foundation.org
Subject: + mm-fix-new-kernel-doc-warning-in-filemapc.patch added to -mm
 tree
Date: Wed, 16 Apr 2014 12:31:51 -0700
Message-ID: <534edaa7.KJVQQa/n4j6zee7x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbaDPTbw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 15:31:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org

Subject: + mm-fix-new-kernel-doc-warning-in-filemapc.patch added to -mm tree
To: rdunlap@infradead.org
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 12:31:51 -0700


The patch titled
     Subject: mm: fix new kernel-doc warning in filemap.c
has been added to the -mm tree.  Its filename is
     mm-fix-new-kernel-doc-warning-in-filemapc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-new-kernel-doc-warning-in-filemapc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-new-kernel-doc-warning-in-filemapc.patch

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

mm-fix-new-kernel-doc-warning-in-filemapc.patch
documentation-submittingpatches-describe-the-fixes-tag.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

