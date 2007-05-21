From: akpm@linux-foundation.org
Subject: + fix-duplicated-entry-in-documentation-howto.patch added to -mm tree
Date: Sun, 20 May 2007 21:11:01 -0700
Message-ID: <200705210411.l4L4B0nd002060@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58593 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbXEUEM4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 00:12:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: junkio@cox.net, greg@kroah.com


The patch titled
     Fix duplicated entry in Documentation/HOWTO
has been added to the -mm tree.  Its filename is
     fix-duplicated-entry-in-documentation-howto.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix duplicated entry in Documentation/HOWTO
From: Junio C Hamano <junkio@cox.net>

Commit 3f271008 introduced this section to Linus tree, but a later commit
722385f7 accepted almost the identical patch via Greg's tree, both from the
same author.

This kills the duplicated one.

Signed-off-by: Junio C Hamano <junkio@cox.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/HOWTO |   20 --------------------
 1 file changed, 20 deletions(-)

diff -puN Documentation/HOWTO~fix-duplicated-entry-in-documentation-howto Documentation/HOWTO
--- a/Documentation/HOWTO~fix-duplicated-entry-in-documentation-howto
+++ a/Documentation/HOWTO
@@ -396,26 +396,6 @@ bugme-janitor mailing list (every change
 
 
 
-Managing bug reports
---------------------
-
-One of the best ways to put into practice your hacking skills is by fixing
-bugs reported by other people. Not only you will help to make the kernel
-more stable, you'll learn to fix real world problems and you will improve
-your skills, and other developers will be aware of your presence. Fixing
-bugs is one of the best ways to get merits among other developers, because
-not many people like wasting time fixing other people's bugs.
-
-To work in the already reported bug reports, go to http://bugzilla.kernel.org.
-If you want to be advised of the future bug reports, you can subscribe to the
-bugme-new mailing list (only new bug reports are mailed here) or to the
-bugme-janitor mailing list (every change in the bugzilla is mailed here)
-
-	http://lists.osdl.org/mailman/listinfo/bugme-new
-	http://lists.osdl.org/mailman/listinfo/bugme-janitors
-
-
-
 Mailing lists
 -------------
 
_

Patches currently in -mm which might be from junkio@cox.net are

fix-duplicated-entry-in-documentation-howto.patch
