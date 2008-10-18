From: akpm@linux-foundation.org
Subject: - reiserfs-procfsc-remove-cvs-keywords.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:18:41 -0700
Message-ID: <200810182318.m9INIf0k029320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773AbYJRXSv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:18:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     reiserfs/procfs.c: remove CVS keywords
has been removed from the -mm tree.  Its filename was
     reiserfs-procfsc-remove-cvs-keywords.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs/procfs.c: remove CVS keywords
From: Adrian Bunk <bunk@kernel.org>

Remove CVS keywords that weren't updated for a long time from comments.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/procfs.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/reiserfs/procfs.c~reiserfs-procfsc-remove-cvs-keywords fs/reiserfs/procfs.c
--- a/fs/reiserfs/procfs.c~reiserfs-procfsc-remove-cvs-keywords
+++ a/fs/reiserfs/procfs.c
@@ -8,8 +8,6 @@
 
 /* proc info support a la one created by Sizif@Botik.RU for PGC */
 
-/* $Id: procfs.c,v 1.1.8.2 2001/07/15 17:08:42 god Exp $ */
-
 #include <linux/module.h>
 #include <linux/time.h>
 #include <linux/seq_file.h>
@@ -621,7 +619,6 @@ int reiserfs_global_version_in_proc(char
 #endif
 
 /*
- * $Log: procfs.c,v $
  * Revision 1.1.8.2  2001/07/15 17:08:42  god
  *  . use get_super() in procfs.c
  *  . remove remove_save_link() from reiserfs_do_truncate()
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
make-probe_serial_gsc-static.patch
make-ptrace_untrace-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
acpi-use-bcd2bin-bin2bcd.patch
alpha-use-bcd2bin-bin2bcd.patch
cris-use-bcd2bin-bin2bcd.patch
drivers-rtc-use-bcd2bin-bin2bcd.patch
rtc-use-bcd2bin-bin2bcd.patch
mips-use-bcd2bin-bin2bcd.patch
mn10300-use-bcd2bin-bin2bcd.patch
i2c-use-bcd2bin-bin2bcd.patch
drivers-scsi-sr_vendorc-use-bcd2bin.patch
remove-the-obsolete-bcdbin-binbcd-macros.patch
include-linux-bcdh-remove-comments.patch

