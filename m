From: akpm@linux-foundation.org
Subject: - update-ntfs-help-text.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:04:46 -0700
Message-ID: <200807070304.m6734kfa004691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190AbYGGDEz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:04:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: i92guboj@terra.es, aia21@cantab.net, mm-commits@vger.kernel.org


The patch titled
     ntfs: update help text
has been removed from the -mm tree.  Its filename was
     update-ntfs-help-text.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntfs: update help text
From: Jess Guerrero <i92guboj@terra.es>

The url in the help text for ntfs should be updated.

Acked-by: Anton Altaparmakov <aia21@cantab.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/Kconfig~update-ntfs-help-text fs/Kconfig
--- a/fs/Kconfig~update-ntfs-help-text
+++ a/fs/Kconfig
@@ -830,7 +830,7 @@ config NTFS_FS
 	  from the project web site.
 
 	  For more information see <file:Documentation/filesystems/ntfs.txt>
-	  and <http://linux-ntfs.sourceforge.net/>.
+	  and <http://www.linux-ntfs.org/>.
 
 	  To compile this file system support as a module, choose M here: the
 	  module will be called ntfs.
_

Patches currently in -mm which might be from i92guboj@terra.es are


