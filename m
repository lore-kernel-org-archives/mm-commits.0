From: akpm@linux-foundation.org
Subject: - asm-h8300-mdh-remove-cvs-keyword.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:10:44 -0700
Message-ID: <200810182310.m9INAiTK027598@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122AbYJRXLA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:11:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     asm-h8300/md.h: remove CVS keyword
has been removed from the -mm tree.  Its filename was
     asm-h8300-mdh-remove-cvs-keyword.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm-h8300/md.h: remove CVS keyword
From: Adrian Bunk <bunk@kernel.org>

Remove a CVS keyword that wasn't updated for a long time from a comment.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/include/asm/md.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/h8300/include/asm/md.h~asm-h8300-mdh-remove-cvs-keyword arch/h8300/include/asm/md.h
--- a/arch/h8300/include/asm/md.h~asm-h8300-mdh-remove-cvs-keyword
+++ a/arch/h8300/include/asm/md.h
@@ -1,4 +1,4 @@
-/* $Id: md.h,v 1.1 2002/11/19 02:09:26 gerg Exp $
+/*
  * md.h: High speed xor_block operation for RAID4/5 
  *
  */
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

