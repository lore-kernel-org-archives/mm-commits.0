From: akpm@linux-foundation.org
Subject: + reiserfs-correct-misspelled-reiserfs_proc_info-to.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:58:53 -0800
Message-ID: <200702272058.l1RKwvdu028409@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51992 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbXB0U7A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:59:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com


The patch titled
     reiserfs: correct misspelled "REISERFS_PROC_INFO" to "CONFIG_REISERFS_PROC_INFO"
has been added to the -mm tree.  Its filename is
     reiserfs-correct-misspelled-reiserfs_proc_info-to.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiserfs: correct misspelled "REISERFS_PROC_INFO" to "CONFIG_REISERFS_PROC_INFO"
From: "Robert P. J. Day" <rpjday@mindspring.com>

Correct the misspelling of the preprocessor check of a Kconfig option to refer
to CONFIG_REISERFS_PROC_INFO and not just the incorrect REISERFS_PROC_INFO.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/procfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiserfs/procfs.c~reiserfs-correct-misspelled-reiserfs_proc_info-to fs/reiserfs/procfs.c
--- a/fs/reiserfs/procfs.c~reiserfs-correct-misspelled-reiserfs_proc_info-to
+++ a/fs/reiserfs/procfs.c
@@ -20,7 +20,7 @@
 #include <linux/init.h>
 #include <linux/proc_fs.h>
 
-#if defined( REISERFS_PROC_INFO )
+#ifdef CONFIG_REISERFS_PROC_INFO
 
 /*
  * LOCKING:
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-avr32.patch
git-dvb.patch
kbuild-add-the-code-maturity-levels-deprecated-and-obsolete.patch
git-mips.patch
mips-remove-unreferenced-_ioc_slmask-macro-in-ioctlh.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
