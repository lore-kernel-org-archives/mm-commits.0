From: akpm@linux-foundation.org
Subject: + spi_imx-spelling-fixes.patch added to -mm tree
Date: Sun, 27 Jan 2008 11:30:08 -0800
Message-ID: <200801271930.m0RJU6VK026846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51288 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751061AbYA0TbG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 14:31:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, dbrownell@users.sourceforge.net


The patch titled
     spi_imx spelling fixes
has been added to the -mm tree.  Its filename is
     spi_imx-spelling-fixes.patch

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
Subject: spi_imx spelling fixes
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_imx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/spi_imx.c~spi_imx-spelling-fixes drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi_imx-spelling-fixes
+++ a/drivers/spi/spi_imx.c
@@ -157,7 +157,7 @@
 #define SPI_FIFO_BYTE_WIDTH		(2)
 #define SPI_FIFO_OVERFLOW_MARGIN	(2)
 
-/* DMA burst lenght for half full/empty request trigger */
+/* DMA burst length for half full/empty request trigger */
 #define SPI_DMA_BLR			(SPI_FIFO_DEPTH * SPI_FIFO_BYTE_WIDTH / 2)
 
 /* Dummy char output to achieve reads.
_

Patches currently in -mm which might be from joe@perches.com are

git-alsa.patch
git-cpufreq.patch
git-powerpc.patch
git-dvb.patch
git-hwmon.patch
git-ieee1394.patch
git-infiniband.patch
git-jfs.patch
git-kvm.patch
git-net.patch
git-selinux.patch
git-s390.patch
git-sh.patch
git-unionfs.patch
git-x86.patch
uml-add-missing-space.patch
uml-style-fixes-in-arch-um-kernel.patch
maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources.patch
spi_imx-spelling-fixes.patch
