From: akpm@osdl.org
Subject: + config_computone-should-depend-on-isaeisapci.patch added to -mm tree
Date: Sun, 10 Dec 2006 12:01:22 -0800
Message-ID: <200612102001.kBAK1MvV001667@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56379 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762476AbWLJUB2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 15:01:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ftp.linux.org.uk, viro@zeniv.linux.org.uk


The patch titled
     CONFIG_COMPUTONE should depend on ISA|EISA|PCI
has been added to the -mm tree.  Its filename is
     config_computone-should-depend-on-isaeisapci.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
config_computone-should-depend-on-isaeisapci.patch
appldata_mem-dependes-on-vm-counters.patch
uml-problems-with-linux-ioh.patch
missing-includes-in-hilkbd.patch
hci-endianness-annotations.patch
lockd-endianness-annotations-rebased.patch
slab-leaks3-default-y.patch

