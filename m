From: akpm@linux-foundation.org
Subject: [folded] tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch removed from -mm tree
Date: Wed, 03 Aug 2011 16:16:51 -0700
Message-ID: <201108032316.p73NGpN7021816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755760Ab1HCXQ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2011 19:16:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, hughd@google.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3
has been removed from the -mm tree.  Its filename was
     tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch

This patch was dropped because it was folded into tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Expand the fs/Kconfig "help" info to clarify why you might need to select
the TMPFS_POSIX_ACL config variable.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/Kconfig~tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3 fs/Kconfig
--- a/fs/Kconfig~tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3
+++ a/fs/Kconfig
@@ -132,11 +132,12 @@ config TMPFS_POSIX_ACL
 	  and this option selects support for ACLs specifically for tmpfs
 	  filesystems.
 
-	  If you've selected TMPFS, you almost certainly want this option
-	  as well since a number of user space features (e.g., ALSA sound)
-	  require POSIX ACL support under /dev to work properly.  In other
-	  words, if you're not sure and you have no *compelling* reason to
-	  deselect this feature, say Y.
+	  If you've selected TMPFS, it's possible that you'll also need
+	  this option as there are a number of Linux distros that require
+	  POSIX ACL support under /dev for certain features to work properly.
+	  For example, some distros need this feature for ALSA-related /dev
+	  files for sound to work properly.  In short, if you're not sure,
+	  say Y.
 
 	  To learn more about Access Control Lists, visit the POSIX ACLs for
 	  Linux website <http://acl.bestbits.at/>.
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch

