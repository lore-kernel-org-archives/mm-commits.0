From: akpm@linux-foundation.org
Subject: + cris-build-fixes-add-baud-rate-defines.patch added to -mm tree
Date: Tue, 30 Oct 2007 15:09:47 -0700
Message-ID: <200710302209.l9UM9lff030345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58192 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752776AbXJ3WJv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 18:09:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     cris build fixes: add baud rate defines
has been added to the -mm tree.  Its filename is
     cris-build-fixes-add-baud-rate-defines.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cris build fixes: add baud rate defines
From: Jesper Nilsson <jesper.nilsson@axis.com>

Add missing defines for (unsupported) baud rates.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-cris/termbits.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN include/asm-cris/termbits.h~cris-build-fixes-add-baud-rate-defines include/asm-cris/termbits.h
--- a/include/asm-cris/termbits.h~cris-build-fixes-add-baud-rate-defines
+++ a/include/asm-cris/termbits.h
@@ -171,6 +171,19 @@ struct ktermios {
 #define  B115200 0010002
 #define  B230400 0010003
 #define  B460800 0010004
+
+/* Unsupported rates, but needed to avoid compile error. */
+#define   B500000 0010005
+#define   B576000 0010006
+#define  B1000000 0010010
+#define  B1152000 0010011
+#define  B1500000 0010012
+#define  B2000000 0010013
+#define  B2500000 0010014
+#define  B3000000 0010015
+#define  B3500000 0010016
+#define  B4000000 0010017
+
 /* etrax supports these additional three baud rates */
 #define  B921600   0010005
 #define  B1843200  0010006
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

cris-build-fixes-fix-csum_tcpudp_magic-declaration.patch
cris-build-fixes-add-missing-syscalls.patch
cris-build-fixes-hardirqh-include-asm-irqh.patch
cris-build-fixes-atomich-needs-compilerh.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-irq-fixes.patch
cris-build-fixes-sys_crisc-needs-fsh.patch
cris-build-fixes-add-baud-rate-defines.patch
cris-build-fixes-update-eth_v10c-ethernet-driver.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-fix-mtdramh.patch
cris-build-fixes-corrected-and-improved-nmi-and-irq-handling.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec.patch
cris-build-fixes-setupc-needs-paramh.patch
cris-build-fixes-fix-crisksymsc.patch
cris-build-fixes-defconfig-updates.patch
