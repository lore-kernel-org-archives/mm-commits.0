From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-ieee1394-entry.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:39:54 -0700
Message-ID: <201103232043.p2NKhUf2028876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756124Ab1CWUzM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, stefanr@s5r6.in-berlin.de, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: remove IEEE1394 entry
has been removed from the -mm tree.  Its filename was
     maintainers-remove-ieee1394-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: remove IEEE1394 entry
From: Joe Perches <joe@perches.com>

commit 66fa12c571d ("ieee1394: remove the old IEEE 1394 driver stack")

removed the code, remove the MAINTAINERS entry.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-ieee1394-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-ieee1394-entry
+++ a/MAINTAINERS
@@ -3175,15 +3175,6 @@ L:	linux-pm@lists.linux-foundation.org
 S:	Supported
 F:	drivers/idle/i7300_idle.c
 
-IEEE 1394 SUBSYSTEM
-M:	Stefan Richter <stefanr@s5r6.in-berlin.de>
-L:	linux1394-devel@lists.sourceforge.net
-W:	http://ieee1394.wiki.kernel.org/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
-S:	Obsolete
-F:	Documentation/debugging-via-ohci1394.txt
-F:	drivers/ieee1394/
