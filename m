From: akpm@linux-foundation.org
Subject: + cris-build-fixes-fix-csum_tcpudp_magic-declaration.patch added to -mm tree
Date: Tue, 30 Oct 2007 15:09:33 -0700
Message-ID: <200710302209.l9UM9Xi3030321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53458 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894AbXJ3WJi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 18:09:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     cris build fixes: fix csum_tcpudp_magic() declaration
has been added to the -mm tree.  Its filename is
     cris-build-fixes-fix-csum_tcpudp_magic-declaration.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cris build fixes: fix csum_tcpudp_magic() declaration
From: Jesper Nilsson <jesper.nilsson@axis.com>

Remove int from prototype, no longer needed and causes compile error.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-cris/checksum.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-cris/checksum.h~cris-build-fixes-fix-csum_tcpudp_magic-declaration include/asm-cris/checksum.h
--- a/include/asm-cris/checksum.h~cris-build-fixes-fix-csum_tcpudp_magic-declaration
+++ a/include/asm-cris/checksum.h
@@ -62,7 +62,7 @@ static inline __sum16 ip_fast_csum(const
  * returns a 16-bit checksum, already complemented
  */
 
-static inline __sum16 int csum_tcpudp_magic(__be32 saddr, __be32 daddr,
+static inline __sum16 csum_tcpudp_magic(__be32 saddr, __be32 daddr,
 						   unsigned short len,
 						   unsigned short proto,
 						   __wsum sum)
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
