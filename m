From: akpm@linux-foundation.org
Subject: + mm-filemap-remove-trailing-whitespace.patch added to -mm tree
Date: Wed, 01 Oct 2014 13:28:38 -0700
Message-ID: <542c63f6.e+yli0cMvjkNWW/k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaJAU2i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 16:28:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmcquad@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap.c: remove trailing whitespace
has been added to the -mm tree.  Its filename is
     mm-filemap-remove-trailing-whitespace.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-remove-trailing-whitespace.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-remove-trailing-whitespace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul McQuade <paulmcquad@gmail.com>
Subject: mm/filemap.c: remove trailing whitespace

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/filemap.c~mm-filemap-remove-trailing-whitespace mm/filemap.c
--- a/mm/filemap.c~mm-filemap-remove-trailing-whitespace
+++ a/mm/filemap.c
@@ -1744,7 +1744,7 @@ EXPORT_SYMBOL(generic_file_read_iter);
 static int page_cache_read(struct file *file, pgoff_t offset)
 {
 	struct address_space *mapping = file->f_mapping;
-	struct page *page; 
+	struct page *page;
 	int ret;
 
 	do {
@@ -1761,7 +1761,7 @@ static int page_cache_read(struct file *
 		page_cache_release(page);
 
 	} while (ret == AOP_TRUNCATED_PAGE);
-		
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from paulmcquad@gmail.com are

mm-mremap-use-linux-headers.patch
mm-filemap-remove-trailing-whitespace.patch

