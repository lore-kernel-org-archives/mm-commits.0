From: akpm@linux-foundation.org
Subject: + add-missing-parenthesis-in-cfe_writeblk-macro.patch added to -mm tree
Date: Fri, 12 Oct 2007 00:17:28 -0700
Message-ID: <200710120717.l9C7HSnl005178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53901 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755659AbXJLHRs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Oct 2007 03:17:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, ralf@linux-mips.org


The patch titled
     add missing parenthesis in cfe_writeblk() macro
has been added to the -mm tree.  Its filename is
     add-missing-parenthesis-in-cfe_writeblk-macro.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add missing parenthesis in cfe_writeblk() macro
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Add missing parenthesis in cfe_writeblk() macro.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/fw/cfe/cfe_api.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-mips/fw/cfe/cfe_api.h~add-missing-parenthesis-in-cfe_writeblk-macro include/asm-mips/fw/cfe/cfe_api.h
--- a/include/asm-mips/fw/cfe/cfe_api.h~add-missing-parenthesis-in-cfe_writeblk-macro
+++ a/include/asm-mips/fw/cfe/cfe_api.h
@@ -154,7 +154,7 @@ int64_t cfe_getticks(void);
 #define cfe_readblk(a, b, c, d)		__cfe_readblk(a, b, c, d)
 #define cfe_setenv(a, b)		__cfe_setenv(a, b)
 #define cfe_write(a, b, c)		__cfe_write(a, b, c)
-#define cfe_writeblk(a, b, c, d		__cfe_writeblk(a, b, c, d)
+#define cfe_writeblk(a, b, c, d)	__cfe_writeblk(a, b, c, d)
 #endif				/* CFE_API_IMPL_NAMESPACE */
 
 int cfe_close(int handle);
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

git-alsa.patch
git-arm.patch
git-cifs.patch
git-powerpc.patch
git-dvb.patch
git-hid.patch
git-mmc.patch
git-mtd.patch
git-net.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
git-scsi-misc.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix.patch
drivers-video-pmag-ba-fbc-improve-diagnostics.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
kernel-forkc-remove-unneeded-variable-initialization-in-copy_process.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
add-missing-parenthesis-in-cfe_writeblk-macro.patch
