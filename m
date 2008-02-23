From: akpm@linux-foundation.org
Subject: + update-tulip-maintainers.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:30:16 -0800
Message-ID: <200802230731.m1N7V5rU017984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752122AbYBWHyB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: grundler@parisc-linux.org, kyle@mcmartin.ca


The patch titled
     update TULIP MAINTAINERS
has been added to the -mm tree.  Its filename is
     update-tulip-maintainers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: update TULIP MAINTAINERS
From: Grant Grundler <grundler@parisc-linux.org>

Kyle and I are co-maintaining tulip driver.  Normally kyle will review my
patchs and submit them.  I'll deal with bugzilla.kernel.org bugs and try to
resolve those bugs.

Signed-off-by: Grant Grundler <grundler@parisc-linux.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN MAINTAINERS~update-tulip-maintainers MAINTAINERS
--- a/MAINTAINERS~update-tulip-maintainers
+++ a/MAINTAINERS
@@ -3894,10 +3894,13 @@ M:	trivial@kernel.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
-TULIP NETWORK DRIVER
-L:	tulip-users@lists.sourceforge.net
-W:	http://sourceforge.net/projects/tulip/
-S:	Orphan
+TULIP NETWORK DRIVERS
+P:	Grant Grundler
+M:	grundler@parisc-linux.org
+P:	Kyle McMartin
+M:	kyle@parisc-linux.org
+L:	netdev@vger.kernel.org
+S:	Maintained
 
 TUN/TAP driver
 P:	Maxim Krasnyansky
_

Patches currently in -mm which might be from grundler@parisc-linux.org are

fix-uli526x-partially-recognizing-interface.patch
update-tulip-maintainers.patch
parisc-new-termios-definitions.patch
