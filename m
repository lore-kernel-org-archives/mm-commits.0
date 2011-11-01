From: akpm@linux-foundation.org
Subject: [merged] tmpfs-add-tmpfs-to-the-kconfig-prompt-to-make-it-obvious.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:08:28 -0700
Message-ID: <201111012108.pA1L8S2m004904@hpaq3.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15315 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab1KAVIf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:08:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: add "tmpfs" to the Kconfig prompt to make it obvious.
has been removed from the -mm tree.  Its filename was
     tmpfs-add-tmpfs-to-the-kconfig-prompt-to-make-it-obvious.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: tmpfs: add "tmpfs" to the Kconfig prompt to make it obvious.

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

