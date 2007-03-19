From: akpm@linux-foundation.org
Subject: - gpio_direction_output-needs-an-initial-value-fix.patch removed from -mm tree
Date: Mon, 19 Mar 2007 14:03:57 -0800
Message-ID: <200703192203.l2JM3vQ4018916@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58768 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030705AbXCSWEU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 18:04:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     gpio_direction_output-needs-an-initial-value fix
has been removed from the -mm tree.  Its filename was
     gpio_direction_output-needs-an-initial-value-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: gpio_direction_output-needs-an-initial-value fix
From: David Brownell <david-b@pacbell.net>

Build fix:  sa1100/generic.c should already have included <asm/gpio.h>,
but it didn't ... causing a build problem with a recent patch.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-sa1100/generic.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm/mach-sa1100/generic.c~gpio_direction_output-needs-an-initial-value-fix arch/arm/mach-sa1100/generic.c
--- a/arch/arm/mach-sa1100/generic.c~gpio_direction_output-needs-an-initial-value-fix
+++ a/arch/arm/mach-sa1100/generic.c
@@ -27,6 +27,7 @@
 #include <asm/mach/map.h>
 #include <asm/mach/flash.h>
 #include <asm/irq.h>
+#include <asm/gpio.h>
 
 #include "generic.h"
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-avr32.patch
8250-make-probing-for-txen-bug-a-config-option.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
blackfin-blackfin-i2c-driver-update-2.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
rtc-kconfig-cleanup.patch
