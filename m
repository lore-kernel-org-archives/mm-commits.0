From: akpm@linux-foundation.org
Subject: - reiserfs-correct-misspelled-reiserfs_proc_info-to.patch removed from -mm tree
Date: Tue, 08 May 2007 19:45:16 -0700
Message-ID: <200705090245.l492jGkA008721@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967812AbXEICpU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:45:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: correct misspelled "REISERFS_PROC_INFO" to "CONFIG_REISERFS_PROC_INFO"
has been removed from the -mm tree.  Its filename was
     reiserfs-correct-misspelled-reiserfs_proc_info-to.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
arm-remove-useless-config-option-generic_bust_spinlock.patch
git-avr32.patch
git-dvb.patch
git-ieee1394.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
