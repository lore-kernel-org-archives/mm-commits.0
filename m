From: akpm@linux-foundation.org
Subject: + fix-a-trivial-typo-in-scripts-checkstackpl.patch added to -mm tree
Date: Thu, 23 Aug 2007 15:45:19 -0700
Message-ID: <200708232245.l7NMjJ0D030921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46547 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757665AbXHWWp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 18:45:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joern@logfs.org, andre@finow14.de


The patch titled
     fix a trivial typo in scripts/checkstack.pl
has been added to the -mm tree.  Its filename is
     fix-a-trivial-typo-in-scripts-checkstackpl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix a trivial typo in scripts/checkstack.pl
From: Joern Engel <joern@logfs.org>

Trivial change in a comment.

Signed-off-by: Joern Engel <joern@logfs.org>
Signed-off-by: Andre Haupt <andre@finow14.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkstack.pl |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkstack.pl~fix-a-trivial-typo-in-scripts-checkstackpl scripts/checkstack.pl
--- a/scripts/checkstack.pl~fix-a-trivial-typo-in-scripts-checkstackpl
+++ a/scripts/checkstack.pl
@@ -14,7 +14,7 @@
 #	M68k port by Geert Uytterhoeven and Andreas Schwab
 #
 #	Usage:
-#	objdump -d vmlinux | stackcheck.pl [arch]
+#	objdump -d vmlinux | scripts/checkstack.pl [arch]
 #
 #	TODO :	Port to all architectures (one regex per arch)
 
_

Patches currently in -mm which might be from joern@logfs.org are

faster-ext2_clear_inode.patch
fix-a-trivial-typo-in-scripts-checkstackpl.patch
revert-faster-ext2_clear_inode.patch
