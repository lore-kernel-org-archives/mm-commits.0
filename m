From: akpm@linux-foundation.org
Subject: - alpha-miata-remove-dead-url.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:10:46 -0700
Message-ID: <200810182310.m9INAkO5027607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142AbYJRXLC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:11:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Alpha Miata: remove dead URL
has been removed from the -mm tree.  Its filename was
     alpha-miata-remove-dead-url.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Alpha Miata: remove dead URL
From: Adrian Bunk <bunk@kernel.org>

Remove a dead URL.

Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/alpha/Kconfig~alpha-miata-remove-dead-url arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~alpha-miata-remove-dead-url
+++ a/arch/alpha/Kconfig
@@ -222,8 +222,7 @@ config ALPHA_MIATA
 	bool "Miata"
 	help
 	  The Digital PersonalWorkStation (PWS 433a, 433au, 500a, 500au, 600a,
-	  or 600au).  There is an Installation HOWTO for this hardware at
-	  <http://eijk.homelinux.org/~stefan/miata.html>.
+	  or 600au).
 
 config ALPHA_MIKASA
 	bool "Mikasa"
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

