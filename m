From: akpm@osdl.org
Subject: - config_computone-should-depend-on-isaeisapci.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:10:54 -0800
Message-ID: <200612140610.kBE6Asxr002027@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52204 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbWLNGLK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:11:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viro@ftp.linux.org.uk, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     CONFIG_COMPUTONE should depend on ISA|EISA|PCI
has been removed from the -mm tree.  Its filename was
     config_computone-should-depend-on-isaeisapci.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CONFIG_COMPUTONE should depend on ISA|EISA|PCI
From: Al Viro <viro@ftp.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/Kconfig~config_computone-should-depend-on-isaeisapci drivers/char/Kconfig
--- a/drivers/char/Kconfig~config_computone-should-depend-on-isaeisapci
+++ a/drivers/char/Kconfig
@@ -97,7 +97,7 @@ config SERIAL_NONSTANDARD
 
 config COMPUTONE
 	tristate "Computone IntelliPort Plus serial support"
-	depends on SERIAL_NONSTANDARD
+	depends on SERIAL_NONSTANDARD && (ISA || EISA || PCI)
 	---help---
 	  This driver supports the entire family of Intelliport II/Plus
 	  controllers with the exception of the MicroChannel controllers and
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

m68k-work-around-binutils-tokenizer-change.patch
slab-leaks3-default-y.patch

