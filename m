From: akpm@linux-foundation.org
Subject: + i2c-i2c-ibm_iic-fast-mode-parm-desc-fixup.patch added to -mm tree
Date: Tue, 25 Mar 2008 15:57:10 -0700
Message-ID: <200803252257.m2PMvAKS017828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754401AbYCYW5N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 18:57:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org


The patch titled
     i2c: i2c-ibm_iic fast mode parm desc fixup
has been added to the -mm tree.  Its filename is
     i2c-i2c-ibm_iic-fast-mode-parm-desc-fixup.patch

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
Subject: i2c: i2c-ibm_iic fast mode parm desc fixup
From: Paul Mundt <lethal@linux-sh.org>

Noticed this when grepping for fast mode module params, the i2c-ibm_iic driver
was using a non-existent variable for MODULE_PARM_DESC.  Fix it up to reflect
what it's actually supposed to be describing.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-ibm_iic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/i2c/busses/i2c-ibm_iic.c~i2c-i2c-ibm_iic-fast-mode-parm-desc-fixup drivers/i2c/busses/i2c-ibm_iic.c
--- a/drivers/i2c/busses/i2c-ibm_iic.c~i2c-i2c-ibm_iic-fast-mode-parm-desc-fixup
+++ a/drivers/i2c/busses/i2c-ibm_iic.c
@@ -63,7 +63,7 @@ MODULE_PARM_DESC(iic_force_poll, "Force 
 
 static int iic_force_fast;
 module_param(iic_force_fast, bool, 0);
-MODULE_PARM_DESC(iic_fast_poll, "Force fast mode (400 kHz)");
+MODULE_PARM_DESC(iic_force_fast, "Force fast mode (400 kHz)");
 
 #define DBG_LEVEL 0
 
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
i2c-renesas-highlander-fpga-smbus-support.patch
i2c-i2c-ibm_iic-fast-mode-parm-desc-fixup.patch
maple-allow-removal-and-reinsertion-of-keyboard-driver-module.patch
maple-add-driver-for-sega-dreamcast-controller.patch
input-touchscreen-driver-for-the-superh-migor-board.patch
smc91x-add-insw-outsw-to-default-config-v2.patch
git-s390.patch
git-sh.patch
smc91x-fix-build-breakage-from-the-smc_get_mac_addr-api-upgrade.patch
taint-kernel-after-warn_oncondition.patch
sm501-add-uart-support.patch
rtc-rtc-rs5c372-fix-up-null-name-in-transfer-error-path.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
asm-futexh-should-include-linux-uaccessh.patch
remove-duplicated-unlikely-in-is_err.patch
introduce-a-generic-__fls-implementation.patch
implement-__fls-on-all-64-bit-archs.patch
use-__fls-for-fls64-on-64-bit-archs.patch

