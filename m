From: akpm@linux-foundation.org
Subject: + fix-lguest-documentation.patch added to -mm tree
Date: Tue, 11 Dec 2007 17:18:40 -0800
Message-ID: <200712120118.lBC1IeZq018583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51684 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752895AbXLLBSu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 20:18:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sheela.sequeira@gmail.com, jmorris@namei.org, rusty@rustcorp.com.au


The patch titled
     Fix lguest documentation
has been added to the -mm tree.  Its filename is
     fix-lguest-documentation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix lguest documentation
From: Sheela <sheela.sequeira@gmail.com>

Share net is not supported, Rusty is an "idiot" .

Signed-off-by: Sheela Sequeira <sheela.sequeira@gmail.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/lguest/lguest.txt |    4 ----
 1 file changed, 4 deletions(-)

diff -puN Documentation/lguest/lguest.txt~fix-lguest-documentation Documentation/lguest/lguest.txt
--- a/Documentation/lguest/lguest.txt~fix-lguest-documentation
+++ a/Documentation/lguest/lguest.txt
@@ -109,10 +109,6 @@ Running Lguest:
   See http://linux-net.osdl.org/index.php/Bridge for general information
   on how to get bridging working.
 
-- You can also create an inter-guest network using
-  "--sharenet=<filename>": any two guests using the same file are on
-  the same network.  This file is created if it does not exist.
-
 There is a helpful mailing list at http://ozlabs.org/mailman/listinfo/lguest
 
 Good luck!
_

Patches currently in -mm which might be from sheela.sequeira@gmail.com are

fix-lguest-documentation.patch
