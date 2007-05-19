From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-crypto.patch removed from -mm tree
Date: Sat, 19 May 2007 10:18:17 -0700
Message-ID: <200705191718.l4JHIG3n007000@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49884 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756395AbXESRVO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 19 May 2007 13:21:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, herbert@gondor.apana.org.au, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects: crypto
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-crypto.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects: crypto
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/Kconfig |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN crypto/Kconfig~use-menuconfig-objects-crypto crypto/Kconfig
--- a/crypto/Kconfig~use-menuconfig-objects-crypto
+++ a/crypto/Kconfig
@@ -2,9 +2,7 @@
 # Cryptographic API Configuration
 #
 
-menu "Cryptographic options"
-
-config CRYPTO
+menuconfig CRYPTO
 	bool "Cryptographic API"
 	help
 	  This option provides the core Cryptographic API.
@@ -463,5 +461,3 @@ config CRYPTO_TEST
 source "drivers/crypto/Kconfig"
 
 endif	# if CRYPTO
-
-endmenu
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

use-menuconfig-objects-acpi.patch
use-menuconfig-objects-ii-sound.patch
git-ieee1394.patch
use-menuconfig-objects-ii-infiniband.patch
use-menuconfig-objects-ii-kvm-virt.patch
use-menuconfig-objects-ii-netdev-general100mbit.patch
use-menuconfig-objects-dccp.patch
use-menuconfig-objects-ipvs.patch
use-menuconfig-objects-sctp.patch
use-menuconfig-objects-tipc.patch
use-menuconfig-objects-arcnet.patch
use-menuconfig-objects-toeknring.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch
use-menuconfig-objects-oldcd.patch
use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-ib-block.patch
use-menuconfig-objects-ii-block-devices.patch
use-menuconfig-objects-ii-usb.patch
usb-fix-debug-output-of-ark3116.patch
use-menuconfig-objects-ii-auxdisplay.patch
use-menuconfig-objects-ii-edac.patch
use-menuconfig-objects-ii-ipmi.patch
use-menuconfig-objects-ii-misc-strange-dev.patch
use-menuconfig-objects-ii-module-menu.patch
use-menuconfig-objects-ii-oprofile.patch
use-menuconfig-objects-ii-telephony.patch
use-menuconfig-objects-ii-tpm.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-crypto-hw.patch
use-menuconfig-objects-i2o.patch
use-menuconfig-objects-parport.patch
use-menuconfig-objects-pnp.patch
use-menuconfig-objects-w1.patch
use-menuconfig-objects-ii-isdn.patch
use-menuconfig-objects-ii-md.patch
