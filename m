From: akpm@linux-foundation.org
Subject: [folded] arm-convert-proc-cpu-aligment-to-seq_file-fix.patch removed from -mm tree
Date: Mon, 21 Dec 2009 15:55:32 -0800
Message-ID: <200912212355.nBLNtWvm003600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbZLUXzo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 18:55:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arm-convert-proc-cpu-aligment-to-seq_file-fix
has been removed from the -mm tree.  Its filename was
     arm-convert-proc-cpu-aligment-to-seq_file-fix.patch

This patch was dropped because it was folded into arm-convert-proc-cpu-aligment-to-seq_file.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm-convert-proc-cpu-aligment-to-seq_file-fix
From: Alexey Dobriyan <adobriyan@gmail.com>

Fix compilation on some arm defconfigs due to THIS_MODULE by removing
line.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/alignment.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/arm/mm/alignment.c~arm-convert-proc-cpu-aligment-to-seq_file-fix arch/arm/mm/alignment.c
--- a/arch/arm/mm/alignment.c~arm-convert-proc-cpu-aligment-to-seq_file-fix
+++ a/arch/arm/mm/alignment.c
@@ -128,7 +128,6 @@ static ssize_t alignment_proc_write(stru
 }
 
 static const struct file_operations alignment_proc_fops = {
-	.owner		= THIS_MODULE,
 	.open		= alignment_proc_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
asus_acpi-convert-to-seq_file.patch
toshiba_acpi-convert-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file-fix.patch
iseries-convert-to-proc_fops.patch
proc_fops-convert-av7110.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
mpt-fusion-convert-to-seq_file.patch
uml-irq-register-race-condition.patch

