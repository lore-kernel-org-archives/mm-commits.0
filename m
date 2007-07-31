From: akpm@linux-foundation.org
Subject: - remove-one-more-leftover-reference-to-devfs.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:58:11 -0700
Message-ID: <200707312358.l6VNwB8Y029530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40204 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760905AbXHAAKD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:10:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjt@tls.msk.ru, mm-commits@vger.kernel.org


The patch titled
     Remove one more leftover reference to devfs
has been removed from the -mm tree.  Its filename was
     remove-one-more-leftover-reference-to-devfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove one more leftover reference to devfs
From: Michael Tokarev <mjt@tls.msk.ru>

Signed-off-by: Michael Tokarev <mjt@tls.msk.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/i386/Kconfig~remove-one-more-leftover-reference-to-devfs arch/i386/Kconfig
--- a/arch/i386/Kconfig~remove-one-more-leftover-reference-to-devfs
+++ a/arch/i386/Kconfig
@@ -458,8 +458,7 @@ config MICROCODE
 	tristate "/dev/cpu/microcode - Intel IA32 CPU microcode support"
 	select FW_LOADER
 	---help---
-	  If you say Y here and also to "/dev file system support" in the
-	  'File systems' section, you will be able to update the microcode on
+	  If you say Y here, you will be able to update the microcode on
 	  Intel processors in the IA32 family, e.g. Pentium Pro, Pentium II,
 	  Pentium III, Pentium 4, Xeon etc.  You will obviously need the
 	  actual microcode binary data itself which is not shipped with the
_

Patches currently in -mm which might be from mjt@tls.msk.ru are

origin.patch
