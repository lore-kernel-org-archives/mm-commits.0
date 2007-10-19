From: akpm@linux-foundation.org
Subject: - fix-a-trivial-typo-in-scripts-checkstackpl.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:49:21 -0700
Message-ID: <200710192249.l9JMnLNQ023958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55115 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757856AbXJSWuG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 18:50:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joern@logfs.org, andre@finow14.de, mm-commits@vger.kernel.org


The patch titled
     fix a trivial typo in scripts/checkstack.pl
has been removed from the -mm tree.  Its filename was
     fix-a-trivial-typo-in-scripts-checkstackpl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix a trivial typo in scripts/checkstack.pl
From: Joern Engel <joern@logfs.org>

Trivial change in a comment.

Signed-off-by: Joern Engel <joern@logfs.org>
Signed-off-by: Andre Haupt <andre@finow14.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkstack.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkstack.pl~fix-a-trivial-typo-in-scripts-checkstackpl scripts/checkstack.pl
--- a/scripts/checkstack.pl~fix-a-trivial-typo-in-scripts-checkstackpl
+++ a/scripts/checkstack.pl
@@ -15,7 +15,7 @@
 #	AVR32 port by Haavard Skinnemoen <hskinnemoen@atmel.com>
 #
 #	Usage:
-#	objdump -d vmlinux | stackcheck.pl [arch]
+#	objdump -d vmlinux | scripts/checkstack.pl [arch]
 #
 #	TODO :	Port to all architectures (one regex per arch)
 
_

Patches currently in -mm which might be from joern@logfs.org are

origin.patch
