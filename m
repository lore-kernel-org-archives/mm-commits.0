From: akpm@linux-foundation.org
Subject: - include-linux-mounth-remove-cvs-keyword.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:11:08 -0700
Message-ID: <200810182311.m9INB8or027679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167AbYJRXLR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:11:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     include/linux/mount.h: remove CVS keyword
has been removed from the -mm tree.  Its filename was
     include-linux-mounth-remove-cvs-keyword.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/mount.h: remove CVS keyword
From: Adrian Bunk <bunk@kernel.org>

Remove a CVS keyword that wasn't updated for a long time from a comment.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mount.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/mount.h~include-linux-mounth-remove-cvs-keyword include/linux/mount.h
--- a/include/linux/mount.h~include-linux-mounth-remove-cvs-keyword
+++ a/include/linux/mount.h
@@ -5,8 +5,6 @@
  *
  * Author:  Marco van Wieringen <mvw@planets.elm.net>
  *
- * Version: $Id: mount.h,v 2.0 1996/11/17 16:48:14 mvw Exp mvw $
- *
  */
 #ifndef _LINUX_MOUNT_H
 #define _LINUX_MOUNT_H
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

