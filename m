From: akpm@linux-foundation.org
Subject: - net-fix-typo-in-drivers-net-usb-kconfig.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:58:16 -0700
Message-ID: <200706121858.l5CIwG26018532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49307 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbXFLTGT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:06:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, jeff@garzik.org, maiurana@gmail.com, mm-commits@vger.kernel.org


The patch titled
     net: fix typo in drivers/net/usb/Kconfig
has been removed from the -mm tree.  Its filename was
     net-fix-typo-in-drivers-net-usb-kconfig.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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
git-netdev-all.patch
fix-x86_64-mm-xen-core-xen-implementation.patch
x86-fix-section-mismatch-warnings-in-mtrr.patch
i386-fix-section-mismatch-warning-in-intel_cacheinfo.patch
git-newsetup.patch
alpha-fix-trivial-section-mismatch-warnings.patch
