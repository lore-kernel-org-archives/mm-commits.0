From: akpm@linux-foundation.org
Subject: + ncpfs-remove-dead-url-from-documentation.patch added to -mm tree
Date: Wed, 02 Sep 2009 13:55:22 -0700
Message-ID: <200909022055.n82KtMeB011690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753404AbZIBU4M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Sep 2009 16:56:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bzolnier@gmail.com, joe@perches.com, vandrove@vc.cvut.cz


The patch titled
     ncpfs: remove dead URL from documentation
has been added to the -mm tree.  Its filename is
     ncpfs-remove-dead-url-from-documentation.patch

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
linux-next.patch
ide-use-printk_once.patch
maintainers-remove-dead-ncpfs-list.patch
ncpfs-remove-dead-url-from-documentation.patch
ncpfs-fix-wrong-check-in-__ncp_ioctl.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch

