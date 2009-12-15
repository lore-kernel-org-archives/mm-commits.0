From: akpm@linux-foundation.org
Subject: [merged] make-debug_bugverbose-default-to-y.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:55:57 -0800
Message-ID: <200912152155.nBFLtv36015529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933783AbZLOV4z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:56:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mingo@elte.hu, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Make DEBUG_BUGVERBOSE default to y
has been removed from the -mm tree.  Its filename was
     make-debug_bugverbose-default-to-y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Make DEBUG_BUGVERBOSE default to y
From: Alexey Dobriyan <adobriyan@gmail.com>

It's easy to lose useful DEBUG_BUGVERBOSE by switching EMBEDDED left and right.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~make-debug_bugverbose-default-to-y lib/Kconfig.debug
--- a/lib/Kconfig.debug~make-debug_bugverbose-default-to-y
+++ a/lib/Kconfig.debug
@@ -575,7 +575,7 @@ config DEBUG_BUGVERBOSE
 	depends on BUG
 	depends on ARM || AVR32 || M32R || M68K || SPARC32 || SPARC64 || \
 		   FRV || SUPERH || GENERIC_BUG || BLACKFIN || MN10300
-	default !EMBEDDED
+	default y
 	help
 	  Say Y here to make BUG() panics output the file name and line number
 	  of the BUG call as well as the EIP and oops trace.  This aids
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
asus_acpi-convert-to-seq_file.patch
toshiba_acpi-convert-to-seq_file.patch
thinkpad_acpi-convert-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file-fix.patch
iseries-convert-to-proc_fops.patch
proc_fops-convert-av7110.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
parisc-convert-proc-pdc-lcdled-to-seq_file.patch
mpt-fusion-convert-to-seq_file.patch
uml-irq-register-race-condition.patch
proc-rename-de_get-to-pde_get-and-inline-it.patch
clps711xfb-convert-to-proc_fops.patch
pnpbios-convert-to-seq_file.patch
const-constify-remaining-pipe_buf_operations.patch
ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs.patch
ufs-nfs-support.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
proc-remove-docbook-and-example.patch
seq_file-use-proc_create-in-documentation.patch

