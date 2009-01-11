From: akpm@linux-foundation.org
Subject: - drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch removed from -mm tree
Date: Sun, 11 Jan 2009 00:21:27 -0800
Message-ID: <200901110821.n0B8LRRN023000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750946AbZAKIVw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Jan 2009 03:21:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david-b@pacbell.net, dtor@mail.ru, marek.vasut@gmail.com, nico@marvell.com, rmk+kernel@arm.linux.org.uk, vsauder@inhand.com, mm-commits@vger.kernel.org


The patch titled
     drivers/input/touchscreen/ucb1400_ts.c needs GPIO
has been removed from the -mm tree.  Its filename was
     drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/input/touchscreen/ucb1400_ts.c needs GPIO
From: Andrew Morton <akpm@linux-foundation.org>

ia64 allmodconfig:

include/asm-generic/gpio.h: In function `gpio_get_value_cansleep':
include/asm-generic/gpio.h:147: error: implicit declaration of function `gpio_get_value'
include/asm-generic/gpio.h: In function `gpio_set_value_cansleep':
include/asm-generic/gpio.h:153: error: implicit declaration of function `gpio_set_value'

recent linux-next breakage.  Not sure what caused it..

Cc: Marek Vasut <marek.vasut@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Vernon Sauder <vsauder@inhand.com>
Cc: Nicolas Pitre <nico@marvell.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/input/touchscreen/Kconfig~drivers-input-touchscreen-ucb1400_tsc-needs-gpio drivers/input/touchscreen/Kconfig
--- a/drivers/input/touchscreen/Kconfig~drivers-input-touchscreen-ucb1400_tsc-needs-gpio
+++ a/drivers/input/touchscreen/Kconfig
@@ -246,6 +246,7 @@ config TOUCHSCREEN_UCB1400
 	tristate "Philips UCB1400 touchscreen"
 	depends on AC97_BUS
 	depends on UCB1400_CORE
+	depends on GPIOLIB
 	help
 	  This enables support for the Philips UCB1400 touchscreen interface.
 	  The UCB1400 is an AC97 audio codec.  The touchscreen interface
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
filesystem-freeze-implement-generic-freeze-feature.patch
i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
clocksource-pass-clocksource-to-read-callback.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
smp_call_function_single-be-slightly-less-stupid.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

