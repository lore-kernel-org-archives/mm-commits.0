From: akpm@linux-foundation.org
Subject: - usb-move-usb-mon-up-to-misc-options-in-kconfig.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:07:33 -0700
Message-ID: <200808042007.m74K7XLb027795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762128AbYHDUIL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:08:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: simon@fire.lp0.eu, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: move usb/mon/ up to misc options in Kconfig
has been removed from the -mm tree.  Its filename was
     usb-move-usb-mon-up-to-misc-options-in-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: move usb/mon/ up to misc options in Kconfig
From: Simon Arlott <simon@fire.lp0.eu>

This makes "USB Monitor" appear under "Miscellaneous USB options" section
instead of in the middle of device specific drivers in the "USB Imaging
devices" section.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/usb/Kconfig~usb-move-usb-mon-up-to-misc-options-in-kconfig drivers/usb/Kconfig
--- a/drivers/usb/Kconfig~usb-move-usb-mon-up-to-misc-options-in-kconfig
+++ a/drivers/usb/Kconfig
@@ -95,6 +95,8 @@ config USB
 
 source "drivers/usb/core/Kconfig"
 
+source "drivers/usb/mon/Kconfig"
+
 source "drivers/usb/host/Kconfig"
 
 source "drivers/usb/class/Kconfig"
@@ -103,8 +105,6 @@ source "drivers/usb/storage/Kconfig"
 
 source "drivers/usb/image/Kconfig"
 
-source "drivers/usb/mon/Kconfig"
