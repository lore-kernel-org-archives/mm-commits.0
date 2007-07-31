From: akpm@linux-foundation.org
Subject: - spi-loopback-mode-definition.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:57:03 -0700
Message-ID: <200707312357.l6VNv3ia029364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43415 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760224AbXHAAQh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:16:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     SPI loopback mode definition
has been removed from the -mm tree.  Its filename was
     spi-loopback-mode-definition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SPI loopback mode definition
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Loopback mode is supported by various controllers.  This mode can be
useful for testing, especially in conjunction with spidev driver.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spi/spi.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/spi/spi.h~spi-loopback-mode-definition include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spi-loopback-mode-definition
+++ a/include/linux/spi/spi.h
@@ -77,6 +77,7 @@ struct spi_device {
 #define	SPI_CS_HIGH	0x04			/* chipselect active high? */
 #define	SPI_LSB_FIRST	0x08			/* per-word bits-on-wire */
 #define	SPI_3WIRE	0x10			/* SI/SO signals shared */
+#define	SPI_LOOP	0x20			/* loopback mode */
 	u8			bits_per_word;
 	int			irq;
 	void			*controller_state;
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
