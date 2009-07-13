From: akpm@linux-foundation.org
Subject: + maintainers-update-jfs-entry.patch added to -mm tree
Date: Mon, 13 Jul 2009 14:04:51 -0700
Message-ID: <200907132104.n6DL4ptk003461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756931AbZGMVFW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jul 2009 17:05:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaggy@linux.vnet.ibm.com


The patch titled
     MAINTAINERS: update JFS entry
has been added to the -mm tree.  Its filename is
     maintainers-update-jfs-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

maintainers-update-jfs-entry.patch

