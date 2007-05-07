From: akpm@linux-foundation.org
Subject: - m68k-export-csum_partial_copy_from_user.patch removed from -mm tree
Date: Sun, 06 May 2007 23:47:09 -0700
Message-ID: <200705070647.l476l9f3020373@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754075AbXEGGr3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 02:47:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, dhowells@redhat.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: export csum_partial_copy_from_user
has been removed from the -mm tree.  Its filename was
     m68k-export-csum_partial_copy_from_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m68k: export csum_partial_copy_from_user
From: Geert Uytterhoeven <geert@linux-m68k.org>

net/rxrpc/af-rxrpc.ko needs csum_partial_copy_from_user

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/lib/checksum.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/m68k/lib/checksum.c~m68k-export-csum_partial_copy_from_user arch/m68k/lib/checksum.c
--- a/arch/m68k/lib/checksum.c~m68k-export-csum_partial_copy_from_user
+++ a/arch/m68k/lib/checksum.c
@@ -320,6 +320,9 @@ csum_partial_copy_from_user(const void _
 	return(sum);
 }
 
+EXPORT_SYMBOL(csum_partial_copy_from_user);
+
+
 /*
  * copy from kernel space while checksumming, otherwise like csum_partial
  */
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
introduce-config_has_dma.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
spin_lock_unlocked-cleanup-in-arch-m68k.patch
ehci-ps3-ohci-ps3-fix-compilation.patch
allow-arch-to-initialize-arch-field-of-the-module-structure.patch
