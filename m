From: akpm@linux-foundation.org
Subject: - spi-add-spi-over-gpio-driver-v3.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:29:32 -0700
Message-ID: <200807252329.m6PNTWP6005086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753511AbYGYX3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:29:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, david-b@pacbell.net, drzeus-list@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     spi-add-spi-over-gpio-driver-v3
has been removed from the -mm tree.  Its filename was
     spi-add-spi-over-gpio-driver-v3.patch

This patch was dropped because it was folded into spi-add-spi-over-gpio-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi-add-spi-over-gpio-driver-v3
From: Michael Buesch <mb@bu3sch.de>

Simple spelling fixes since v2.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: David Brownell <david-b@pacbell.net>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                  |   10 +++++-----
 drivers/spi/Kconfig          |    2 +-
 include/linux/spi/spi_gpio.h |   12 +++++++++---
 3 files changed, 15 insertions(+), 9 deletions(-)

diff -puN drivers/spi/Kconfig~spi-add-spi-over-gpio-driver-v3 drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi-add-spi-over-gpio-driver-v3
+++ a/drivers/spi/Kconfig
@@ -107,7 +107,7 @@ config SPI_GPIO
 	help
 	  This is a platform driver that can be used for bitbanging
 	  an SPI bus over GPIO pins.
-	  Select this, if you have any SPI device that is connected via
+	  Select this if you have any SPI device that is connected via
 	  GPIO pins.
 	  The module will be called spi_gpio.
 
diff -puN include/linux/spi/spi_gpio.h~spi-add-spi-over-gpio-driver-v3 include/linux/spi/spi_gpio.h
--- a/include/linux/spi/spi_gpio.h~spi-add-spi-over-gpio-driver-v3
+++ a/include/linux/spi/spi_gpio.h
@@ -15,7 +15,9 @@
 #include <linux/spi/spi.h>
 
 
-/** struct spi_gpio_platform_data - Data definitions for a SPI-GPIO device.
+/**
+ * struct spi_gpio_platform_data - Data definitions for a SPI-GPIO device.
+ *
  * This structure holds information about a GPIO-based SPI device.
  *
  * @pin_clk: The GPIO pin number of the CLOCK pin.
@@ -51,13 +53,17 @@ struct spi_gpio_platform_data {
 	void *boardinfo_setup_data;
 };
 
-/** SPI_GPIO_PLATDEV_NAME - The platform device name string.
+/**
+ * SPI_GPIO_PLATDEV_NAME - The platform device name string.
+ *
  * The name string that has to be used for platform_device_alloc
  * when allocating a spi-gpio device.
  */
 #define SPI_GPIO_PLATDEV_NAME	"spi-gpio"
 
-/** spi_gpio_next_id - Get another platform device ID number.
+/**
+ * spi_gpio_next_id - Get another platform device ID number.
+ *
  * This returns the next platform device ID number that has to be used
  * for platform_device_alloc. The ID is opaque and should not be used for
  * anything else.
_

Patches currently in -mm which might be from mb@bu3sch.de are

origin.patch
spi-add-spi-over-gpio-driver.patch
spi-add-spi-over-gpio-driver-v3.patch
mmc-add-gpio-based-mmc-sd-driver.patch
mmc-add-gpio-based-mmc-sd-driver-v3.patch
mmc-add-gpio-based-mmc-sd-driver-v3-fix-for-configfs-api-change.patch
mmc-add-gpio-based-mmc-sd-driver-add-documentation-abi-testing-configfs-gpiommc.patch
mmc-add-gpio-based-mmc-sd-driver-add-locking.patch

