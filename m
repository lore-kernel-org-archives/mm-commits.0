From: akpm@linux-foundation.org
Subject: [merged] documentation-ignore-byproducts-from-latex.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:33:55 -0700
Message-ID: <200904061933.n36JXtph011328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757022AbZDFTgN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:36:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: henrik@austad.us, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     documentation: ignore byproducts from latex
has been removed from the -mm tree.  Its filename was
     documentation-ignore-byproducts-from-latex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: documentation: ignore byproducts from latex
From: Henrik Austad <henrik@austad.us>

When using 'make pdfdocs', auto-generated files should be ignored

Signed-off-by: Henrik Austad <henrik@austad.us>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/.gitignore |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN Documentation/DocBook/.gitignore~documentation-ignore-byproducts-from-latex Documentation/DocBook/.gitignore
--- a/Documentation/DocBook/.gitignore~documentation-ignore-byproducts-from-latex
+++ a/Documentation/DocBook/.gitignore
@@ -4,3 +4,7 @@
 *.html
 *.9.gz
 *.9
+*.aux
+*.dvi
+*.log
+*.out
_

Patches currently in -mm which might be from henrik@austad.us are

origin.patch

