From: akpm@linux-foundation.org
Subject: + usb-move-usb-mon-up-to-misc-options-in-kconfig.patch added to -mm tree
Date: Mon, 28 Jul 2008 19:51:20 -0700
Message-ID: <200807290251.m6T2pK4O010470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573AbYG2CwN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 22:52:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: simon@fire.lp0.eu, greg@kroah.com


The patch titled
     usb: move usb/mon/ up to misc options in Kconfig
has been added to the -mm tree.  Its filename is
     usb-move-usb-mon-up-to-misc-options-in-kconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
