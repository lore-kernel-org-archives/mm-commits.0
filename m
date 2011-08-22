From: akpm@linux-foundation.org
Subject: + leds-renesas-tpu-led-driver-v2-fix.patch added to -mm tree
Date: Mon, 22 Aug 2011 16:11:50 -0700
Message-ID: <201108222311.p7MNBodF012402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753912Ab1HVXMO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Aug 2011 19:12:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, damm@opensource.se, grant.likely@secretlab.ca, lethal@linux-sh.org, rpurdie@rpsys.net


The patch titled
     leds-renesas-tpu-led-driver-v2-fix
has been added to the -mm tree.  Its filename is
     leds-renesas-tpu-led-driver-v2-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds-renesas-tpu-led-driver-v2-fix
From: Axel Lin <axel.lin@gmail.com>

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
drivers-video-backlight-ep93xx_blc-add-missing-include-of-linux-moduleh.patch
leds-add-missing-include-of-linux-moduleh.patch
linux-next.patch
leds-renesas-tpu-led-driver-v2-fix.patch

