From: akpm@linux-foundation.org
Subject: [merged] ncpfs-remove-dead-url-from-documentation.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:57:27 -0700
Message-ID: <200909231957.n8NJvRYY006965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753759AbZIWT6G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:58:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bzolnier@gmail.com, joe@perches.com, vandrove@vc.cvut.cz, mm-commits@vger.kernel.org


The patch titled
     ncpfs: remove dead URL from documentation
has been removed from the -mm tree.  Its filename was
     ncpfs-remove-dead-url-from-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ncpfs: remove dead URL from documentation
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Noticed-by: Joe Perches <joe@perches.com>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/ncpfs.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/filesystems/ncpfs.txt~ncpfs-remove-dead-url-from-documentation Documentation/filesystems/ncpfs.txt
--- a/Documentation/filesystems/ncpfs.txt~ncpfs-remove-dead-url-from-documentation
+++ a/Documentation/filesystems/ncpfs.txt
@@ -7,6 +7,6 @@ ftp.gwdg.de/pub/linux/misc/ncpfs, but su
 will have it as well.
 
 Related products are linware and mars_nwe, which will give Linux partial
-NetWare server functionality.  Linware's home site is
-klokan.sh.cvut.cz/pub/linux/linware; mars_nwe can be found on
-ftp.gwdg.de/pub/linux/misc/ncpfs.
+NetWare server functionality.
+
+mars_nwe can be found on ftp.gwdg.de/pub/linux/misc/ncpfs.
_

Patches currently in -mm which might be from bzolnier@gmail.com are

origin.patch
ide-use-printk_once.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch

