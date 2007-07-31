From: akpm@linux-foundation.org
Subject: + spi-loopback-mode-definition.patch added to -mm tree
Date: Mon, 30 Jul 2007 21:50:00 -0700
Message-ID: <200707310450.l6V4o0ND016142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60002 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761667AbXGaEuX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 00:50:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net


The patch titled
     SPI loopback mode definition
has been added to the -mm tree.  Its filename is
     spi-loopback-mode-definition.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

spi_mpc83xx-turn-off-spi-unit-while-switching-mode.patch
spi_mpc83xx-get-rid-of-magic-numbers.patch
spi_mpc83xx-support-for-lsb-first-transfers.patch
spi_mpc83xx-fix-qelsb-mode-shifts.patch
spi-loopback-mode-definition.patch
spidev-supports-more-communications-modes.patch
spidev_test-utility.patch
spi_mpc83xx-support-loopback-mode.patch
