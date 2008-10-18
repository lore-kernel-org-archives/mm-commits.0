From: akpm@linux-foundation.org
Subject: - telephony-remove-cvs-keywords.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:18:17 -0700
Message-ID: <200810182318.m9INIHff029257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273AbYJRXSZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:18:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     telephony: remove CVS keywords
has been removed from the -mm tree.  Its filename was
     telephony-remove-cvs-keywords.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: telephony: remove CVS keywords
From: Adrian Bunk <bunk@kernel.org>

Remove CVS keywords that weren't updated for a long time from comments.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/telephony/ixj.c   |    2 --
 include/linux/telephony.h |    4 ----
 2 files changed, 6 deletions(-)

diff -puN drivers/telephony/ixj.c~telephony-remove-cvs-keywords drivers/telephony/ixj.c
--- a/drivers/telephony/ixj.c~telephony-remove-cvs-keywords
+++ a/drivers/telephony/ixj.c
@@ -42,8 +42,6 @@
  ***************************************************************************/
 
 /*
- * $Log: ixj.c,v $
- *
  * Revision 4.8  2003/07/09 19:39:00  Daniele Bellucci
  * Audit some copy_*_user and minor cleanup.
  *
diff -puN include/linux/telephony.h~telephony-remove-cvs-keywords include/linux/telephony.h
--- a/include/linux/telephony.h~telephony-remove-cvs-keywords
+++ a/include/linux/telephony.h
@@ -28,10 +28,6 @@
  * ON AN "AS IS" BASIS, AND QUICKNET TECHNOLOGIES, INC. HAS NO OBLIGATION
  * TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
  *
- * Version:       $Revision: 4.2 $
- *
- * $Id: telephony.h,v 4.2 2001/08/06 07:09:43 craigs Exp $
- *
  *****************************************************************************/
 
 #ifndef TELEPHONY_H
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

