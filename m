From: akpm@linux-foundation.org
Subject: + net-fix-typo-in-drivers-net-usb-kconfig.patch added to -mm tree
Date: Mon, 11 Jun 2007 12:41:04 -0700
Message-ID: <200706111941.l5BJf4Jc027488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46160 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757315AbXFKTlb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 15:41:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, jeff@garzik.org, maiurana@gmail.com


The patch titled
     net: fix typo in drivers/net/usb/Kconfig
has been added to the -mm tree.  Its filename is
     net-fix-typo-in-drivers-net-usb-kconfig.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: net: fix typo in drivers/net/usb/Kconfig
=46rom: Sam Ravnborg <sam@ravnborg.org>

Replace invisible character with a space.

The diff looks like this on my terminal:
-        <A0>Choose this option if you're using a host-to-host cable
-        <A0>with one of these chips.
+         Choose this option if you're using a host-to-host cable
+         with one of these chips.

Reported-by: Massimo Maiurana <maiurana@gmail.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/usb/Kconfig~net-fix-typo-in-drivers-net-usb-kconf=
ig drivers/net/usb/Kconfig
--- a/drivers/net/usb/Kconfig~net-fix-typo-in-drivers-net-usb-kconfig
+++ a/drivers/net/usb/Kconfig
@@ -313,8 +313,8 @@ config USB_KC2190
 	boolean "KT Technology KC2190 based cables (InstaNet)"
 	depends on USB_NET_CDC_SUBSET && EXPERIMENTAL
 	help
-	 =A0Choose this option if you're using a host-to-host cable
-	 =A0with one of these chips.
+	  Choose this option if you're using a host-to-host cable
+	  with one of these chips.
=20
 config USB_NET_ZAURUS
 	tristate "Sharp Zaurus (stock ROMs) and compatible"
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
git-kbuild.patch
use-posix-bre-in-headers-install-target.patch
net-fix-typo-in-drivers-net-usb-kconfig.patch
fix-x86_64-mm-xen-core-xen-implementation.patch
x86-fix-section-mismatch-warnings-in-mtrr.patch
i386-fix-section-mismatch-warning-in-intel_cacheinfo.patch
git-newsetup.patch
alpha-fix-trivial-section-mismatch-warnings.patch
