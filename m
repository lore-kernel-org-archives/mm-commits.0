From: akpm@linux-foundation.org
Subject: + update-ntfs-help-text.patch added to -mm tree
Date: Mon, 30 Jun 2008 22:33:47 -0700
Message-ID: <200807010533.m615XlUW010897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287AbYGAFdz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 01:33:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: i92guboj@terra.es, aia21@cantab.net


The patch titled
     update ntfs help text
has been added to the -mm tree.  Its filename is
     update-ntfs-help-text.patch

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
Subject: update ntfs help text
From: Jess Guerrero <i92guboj@terra.es>

The url in the help text for ntfs should be updated.

Cc: Anton Altaparmakov <aia21@cantab.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/Kconfig~update-ntfs-help-text fs/Kconfig
--- a/fs/Kconfig~update-ntfs-help-text
+++ a/fs/Kconfig
@@ -838,7 +838,7 @@ config NTFS_FS
 	  from the project web site.
 
 	  For more information see <file:Documentation/filesystems/ntfs.txt>
-	  and <http://linux-ntfs.sourceforge.net/>.
+	  and <http://www.linux-ntfs.org/doku.php>.
 
 	  To compile this file system support as a module, choose M here: the
 	  module will be called ntfs.
_

Patches currently in -mm which might be from i92guboj@terra.es are

update-ntfs-help-text.patch

