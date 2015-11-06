From: akpm@linux-foundation.org
Subject: [folded-merged]
 doc-slub-document-slabinfo-gnuplotsh-script-fix.patch removed from -mm tree
Date: Thu, 05 Nov 2015 18:22:02 -0800
Message-ID: <563c0eca.1WROAZpWI0uAEhyL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031154AbbKFCWD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 21:22:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky.work@gmail.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: doc-slub-document-slabinfo-gnuplotsh-script-fix
has been removed from the -mm tree.  Its filename was
     doc-slub-document-slabinfo-gnuplotsh-script-fix.patch

This patch was dropped because it was folded into doc-slub-document-slabinfo-gnuplotsh-script.patch

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

doc-slub-document-slabinfo-gnuplotsh-script.patch

