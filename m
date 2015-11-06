From: akpm@linux-foundation.org
Subject: + doc-slub-document-slabinfo-gnuplotsh-script-fix.patch added to
 -mm tree
Date: Thu, 05 Nov 2015 16:18:56 -0800
Message-ID: <563bf1f0.i6WW6puJAU3JHvxn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965779AbbKFAS4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 19:18:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky.work@gmail.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: doc-slub-document-slabinfo-gnuplotsh-script-fix
has been added to the -mm tree.  Its filename is
     doc-slub-document-slabinfo-gnuplotsh-script-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/doc-slub-document-slabinfo-gnuplotsh-script-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/doc-slub-document-slabinfo-gnuplotsh-script-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: doc-slub-document-slabinfo-gnuplotsh-script-fix

V2: Fix grammar (Christoph Lameter)

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/slub.txt |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN Documentation/vm/slub.txt~doc-slub-document-slabinfo-gnuplotsh-script-fix Documentation/vm/slub.txt
--- a/Documentation/vm/slub.txt~doc-slub-document-slabinfo-gnuplotsh-script-fix
+++ a/Documentation/vm/slub.txt
@@ -283,7 +283,7 @@ of other objects.
 Extended slabinfo mode and plotting
 -----------------------------------
 
-slabinfo tool has a special 'extended' ('-X') mode that includes:
+The slabinfo tool has a special 'extended' ('-X') mode that includes:
  - Slabcache Totals
  - Slabs sorted by size (up to -N <num> slabs, default 1)
  - Slabs sorted by loss (up to -N <num> slabs, default 1)
@@ -339,3 +339,4 @@ options to 'zoom-in'/'zoom-out':
               between 40th and 60th seconds).
 
 Christoph Lameter, May 30, 2007
+Sergey Senozhatsky, October 23, 2015
_

Patches currently in -mm which might be from sergey.senozhatsky.work@gmail.com are

doc-slub-document-slabinfo-gnuplotsh-script-fix.patch
zsmalloc-dont-test-shrinker_enabled-in-zs_shrinker_count.patch
zsmalloc-reduce-size_class-memory-usage.patch

