From: akpm@linux-foundation.org
Subject: + tmpfs-add-tmpfs-to-the-kconfig-prompt-to-make-it-obvious.patch added to -mm tree
Date: Tue, 16 Aug 2011 09:41:05 -0700
Message-ID: <201108161638.p7GGcCmU003003@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752361Ab1HPQir (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 12:38:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, hughd@google.com


The patch titled
     tmpfs: add "tmpfs" to the Kconfig prompt to make it obvious.
has been added to the -mm tree.  Its filename is
     tmpfs-add-tmpfs-to-the-kconfig-prompt-to-make-it-obvious.patch

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
Subject: tmpfs: add "tmpfs" to the Kconfig prompt to make it obvious.
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Add the leading word "tmpfs" to the Kconfig string to make it blindingly
obvious that this selection refers to tmpfs.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/Kconfig~tmpfs-add-tmpfs-to-the-kconfig-prompt-to-make-it-obvious fs/Kconfig
--- a/fs/Kconfig~tmpfs-add-tmpfs-to-the-kconfig-prompt-to-make-it-obvious
+++ a/fs/Kconfig
@@ -109,7 +109,7 @@ source "fs/proc/Kconfig"
 source "fs/sysfs/Kconfig"
 
 config TMPFS
-	bool "Virtual memory file system support (former shm fs)"
+	bool "Tmpfs virtual memory file system support (former shm fs)"
 	depends on SHMEM
 	help
 	  Tmpfs is a file system which keeps all files in virtual memory.
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-add-tmpfs-to-the-kconfig-prompt-to-make-it-obvious.patch

