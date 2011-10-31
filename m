From: akpm@linux-foundation.org
Subject: [folded] leds-renesas-tpu-led-driver-v2-fix.patch removed from -mm tree
Date: Mon, 31 Oct 2011 16:51:03 -0700
Message-ID: <201110312351.p9VNp3Mm000739@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:53720 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab1JaXvR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2011 19:51:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, damm@opensource.se, grant.likely@secretlab.ca, lethal@linux-sh.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: leds-renesas-tpu-led-driver-v2-fix
has been removed from the -mm tree.  Its filename was
     leds-renesas-tpu-led-driver-v2-fix.patch

This patch was dropped because it was folded into leds-renesas-tpu-led-driver-v2.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: leds-renesas-tpu-led-driver-v2-fix

include linux/module.h

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Magnus Damm <damm@opensource.se>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-renesas-tpu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/leds/leds-renesas-tpu.c~leds-renesas-tpu-led-driver-v2-fix drivers/leds/leds-renesas-tpu.c
--- a/drivers/leds/leds-renesas-tpu.c~leds-renesas-tpu-led-driver-v2-fix
+++ a/drivers/leds/leds-renesas-tpu.c
@@ -17,6 +17,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/spinlock.h>
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
backlight-rename-corgibl_limit_intensity-to-genericbl_limit_intensity.patch
leds-renesas-tpu-led-driver-v2.patch
leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register.patch
leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register-fix.patch
drivers-leds-leds-lm3530c-add-__devexit_p-where-needed.patch

