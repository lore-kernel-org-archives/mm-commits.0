From: akpm@linux-foundation.org
Subject: + documentation-gpiotxt-mentions-generic_gpio.patch added to -mm tree
Date: Thu, 10 May 2007 17:13:56 -0700
Message-ID: <200705110013.l4B0DuvS002046@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756255AbXEKAOJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 20:14:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     Documentation/gpio.txt mentions GENERIC_GPIO
has been added to the -mm tree.  Its filename is
     documentation-gpiotxt-mentions-generic_gpio.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Documentation/gpio.txt mentions GENERIC_GPIO
From: David Brownell <david-b@pacbell.net>

Documentation/gpio.txt should mention the Kconfig GENERIC_GPIO flag, for
platforms to declare when relevant.  This should help minimize goofs like
omitting it, or not depending on it when needed.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gpio.txt |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN Documentation/gpio.txt~documentation-gpiotxt-mentions-generic_gpio Documentation/gpio.txt
--- a/Documentation/gpio.txt~documentation-gpiotxt-mentions-generic_gpio
+++ a/Documentation/gpio.txt
@@ -66,7 +66,9 @@ registers; another might implement it by
 used for several very different kinds of GPIO controller.
 
 That said, if the convention is supported on their platform, drivers should
-use it when possible:
+use it when possible.  Platforms should declare GENERIC_GPIO support in
+Kconfig (boolean true), which multi-platform drivers can depend on when
+using the include file:
 
 	#include <asm/gpio.h>
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
documentation-gpiotxt-mentions-generic_gpio.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
git-leds.patch
at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
use-menuconfig-objects-ii-rtc.patch
mpc52xx-psc-spi-master-driver-update.patch
mpc52xx-psc-spi-master-driver-update-tidy.patch
rtc-rs5c313c-error-and-warning-are-fixed.patch
rtc-rs5c313c-rtc_time-value-are-fixed.patch
rtc-rs5c313c-add-error-handling-to-avoid-hardware-hangup.patch
