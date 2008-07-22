From: akpm@linux-foundation.org
Subject: + mmc-add-gpio-based-mmc-sd-driver-add-documentation-abi-testing-configfs-gpiommc.patch added to -mm tree
Date: Tue, 22 Jul 2008 01:11:11 -0700
Message-ID: <200807220811.m6M8BBEu017934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212AbYGVIMC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 04:12:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de, david-b@pacbell.net, drzeus-list@drzeus.cx


The patch titled
     Add Documentation/ABI/testing/configfs-gpiommc
has been added to the -mm tree.  Its filename is
     mmc-add-gpio-based-mmc-sd-driver-add-documentation-abi-testing-configfs-gpiommc.patch

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
Subject: Add Documentation/ABI/testing/configfs-gpiommc
From: Michael Buesch <mb@bu3sch.de>

This adds a Documentation/ABI entry for the gpiommc configfs interface.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: David Brownell <david-b@pacbell.net>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/configfs-gpiommc |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/configfs-gpiommc
--- /dev/null
+++ a/Documentation/ABI/testing/configfs-gpiommc
@@ -0,0 +1,9 @@
+What:		/config/gpiommc/
+Date:		July 2008
+Contact:	Michael Buesch <mb@bu3sch.de>
+Description:
+		The /config/gpiommc/ directory consists of a group of
+		user-managable subdirectories for the dynamic registration
+		and removal of GPIO based MMC/SD cards.
+		Complete documentation is available in:
+		Documentation/gpiommc.txt
_

Patches currently in -mm which might be from mb@bu3sch.de are

origin.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support.patch
gpio-add-bt8xxgpio-driver.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
gpiolib-allow-user-selection.patch
gpiolib-allow-user-selection-update.patch
spi-add-spi-over-gpio-driver.patch
spi-add-spi-over-gpio-driver-v3.patch
mmc-add-gpio-based-mmc-sd-driver.patch
mmc-add-gpio-based-mmc-sd-driver-v3.patch
mmc-add-gpio-based-mmc-sd-driver-v3-fix-for-configfs-api-change.patch
mmc-add-gpio-based-mmc-sd-driver-add-documentation-abi-testing-configfs-gpiommc.patch
mmc-add-gpio-based-mmc-sd-driver-add-locking.patch

