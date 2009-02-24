From: akpm@linux-foundation.org
Subject: [failures] eeepc-laptop-fix-kconfig.patch removed from -mm tree
Date: Tue, 24 Feb 2009 14:44:48 -0800
Message-ID: <200902242244.n1OMindl017634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758542AbZBXWpb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 17:45:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corentincj@iksaif.net, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     eeepc-laptop: Fix Kconfig
has been removed from the -mm tree.  Its filename was
     eeepc-laptop-fix-kconfig.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eeepc-laptop: Fix Kconfig
From: Corentin Chary <corentincj@iksaif.net>

Add a "select INPUT" to Kconfig now that eeepc-laptop is using the input
layer.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/platform/x86/Kconfig~eeepc-laptop-fix-kconfig drivers/platform/x86/Kconfig
--- a/drivers/platform/x86/Kconfig~eeepc-laptop-fix-kconfig
+++ a/drivers/platform/x86/Kconfig
@@ -307,6 +307,7 @@ config EEEPC_LAPTOP
 	select BACKLIGHT_CLASS_DEVICE
 	select HWMON
 	select RFKILL
+	select INPUT
 	---help---
 	  This driver supports the Fn-Fx keys on Eee PC laptops.
 	  It also adds the ability to switch camera/wlan on/off.
_

Patches currently in -mm which might be from corentincj@iksaif.net are

linux-next.patch
eeepc-laptop-fix-kconfig.patch
asus-laptop-restore-acpi_generate_proc_event.patch
eeepc-laptop-restore-acpi_generate_proc_event.patch
asus-laptop-use-select-instead-of-depends-on.patch

