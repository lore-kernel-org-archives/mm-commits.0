From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-jfs-entry.patch removed from -mm tree
Date: Tue, 14 Jul 2009 13:33:35 -0700
Message-ID: <200907142033.n6EKXZ0r013708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756511AbZGNUdk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jul 2009 16:33:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaggy@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update JFS entry
has been removed from the -mm tree.  Its filename was
     maintainers-update-jfs-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: update JFS entry
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

JFS hasn't really been supported for a while.  It's still maintained, but
saying it's supported is a stretch.  Updating my preferred email address
as well.

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-jfs-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-update-jfs-entry
+++ a/MAINTAINERS
@@ -3287,11 +3287,11 @@ F:	include/linux/ivtv*
 
 JFS FILESYSTEM
 P:	Dave Kleikamp
-M:	shaggy@austin.ibm.com
+M:	shaggy@linux.vnet.ibm.com
 L:	jfs-discussion@lists.sourceforge.net
 W:	http://jfs.sourceforge.net/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git
-S:	Supported
+S:	Maintained
 F:	Documentation/filesystems/jfs.txt
 F:	fs/jfs/
 
_

Patches currently in -mm which might be from shaggy@linux.vnet.ibm.com are


