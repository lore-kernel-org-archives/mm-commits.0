From: akpm@linux-foundation.org
Subject: + arm-convert-proc-cpu-aligment-to-seq_file-fix.patch added to -mm tree
Date: Tue, 01 Dec 2009 15:16:51 -0800
Message-ID: <200912012316.nB1NGp6C005688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753016AbZLAXQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 18:16:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, rmk@arm.linux.org.uk


The patch titled
     arm-convert-proc-cpu-aligment-to-seq_file-fix
has been added to the -mm tree.  Its filename is
     arm-convert-proc-cpu-aligment-to-seq_file-fix.patch

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

linux-next.patch
thinkpad_acpi-convert-to-seq_file.patch
asus_acpi-convert-to-seq_file.patch
toshiba_acpi-convert-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file-fix.patch
iseries-convert-to-proc_fops.patch
via-pmu-convert-to-proc_fops-seq_file.patch
proc_fops-convert-av7110.patch
proc_fops-convert-cpia.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix.patch
parisc-convert-proc-pdc-lcdled-to-seq_file.patch
mpt-fusion-convert-to-seq_file.patch
alpha-convert-srm-code-to-seq_file.patch
const-constify-remaining-dev_pm_ops.patch
uml-convert-to-seq_file-proc_fops.patch
uml-irq-register-race-condition.patch
make-debug_bugverbose-default-to-y.patch
proc-rename-de_get-to-pde_get-and-inline-it.patch
clps711xfb-convert-to-proc_fops.patch
pnpbios-convert-to-seq_file.patch
const-constify-remaining-pipe_buf_operations.patch
ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs.patch
ufs-nfs-support.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
proc-remove-docbook-and-example.patch

