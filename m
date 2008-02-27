From: akpm@linux-foundation.org
Subject: - update-tulip-maintainers.patch removed from -mm tree
Date: Wed, 27 Feb 2008 14:16:47 -0800
Message-ID: <200802272216.m1RMGlr5000747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754415AbYB0WT5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 17:19:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: grundler@parisc-linux.org, kyle@mcmartin.ca, mm-commits@vger.kernel.org


The patch titled
     update TULIP MAINTAINERS
has been removed from the -mm tree.  Its filename was
     update-tulip-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-net.patch
parisc-new-termios-definitions.patch
de2104x-remove-bug_on-when-changing-media-type.patch
