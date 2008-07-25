From: akpm@linux-foundation.org
Subject: - mmc-add-gpio-based-mmc-sd-driver-add-documentation-abi-testing-configfs-gpiommc.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:29:58 -0700
Message-ID: <200807252329.m6PNTwxI005103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753652AbYGYXaL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:30:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, david-b@pacbell.net, drzeus-list@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     Add Documentation/ABI/testing/configfs-gpiommc
has been removed from the -mm tree.  Its filename was
     mmc-add-gpio-based-mmc-sd-driver-add-documentation-abi-testing-configfs-gpiommc.patch

This patch was dropped because it was folded into mmc-add-gpio-based-mmc-sd-driver.patch

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
spi-add-spi-over-gpio-driver.patch
mmc-add-gpio-based-mmc-sd-driver.patch
mmc-add-gpio-based-mmc-sd-driver-add-documentation-abi-testing-configfs-gpiommc.patch
mmc-add-gpio-based-mmc-sd-driver-add-locking.patch

