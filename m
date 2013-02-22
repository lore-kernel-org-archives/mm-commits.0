From: akpm@linux-foundation.org
Subject: [merged] backlight-ld9040-reorder-inclusions-of-linux-xxxh.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:40:23 -0800
Message-ID: <20130222204023.8F5155A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:41085 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757713Ab3BVUkY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:40:24 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so103880ghb.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:40:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ld9040: reorder inclusions of <linux/xxx.h>
has been removed from the -mm tree.  Its filename was
     backlight-ld9040-reorder-inclusions-of-linux-xxxh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ld9040: reorder inclusions of <linux/xxx.h>

Reorder inclusions of <linux/xxx.h> for redability, according to
alphabetical ordering.  Also, unnecessary header comments are removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ld9040.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff -puN drivers/video/backlight/ld9040.c~backlight-ld9040-reorder-inclusions-of-linux-xxxh drivers/video/backlight/ld9040.c
--- a/drivers/video/backlight/ld9040.c~backlight-ld9040-reorder-inclusions-of-linux-xxxh
+++ a/drivers/video/backlight/ld9040.c
@@ -9,29 +9,20 @@
  * under the terms of the GNU General Public License as published by the
  * Free Software Foundation; either version 2 of the License, or (at your
  * option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
  */
 
-#include <linux/wait.h>
-#include <linux/fb.h>
+#include <linux/backlight.h>
 #include <linux/delay.h>
+#include <linux/fb.h>
 #include <linux/gpio.h>
-#include <linux/spi/spi.h>
-#include <linux/irq.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/lcd.h>
-#include <linux/backlight.h>
 #include <linux/module.h>
 #include <linux/regulator/consumer.h>
+#include <linux/spi/spi.h>
+#include <linux/wait.h>
 
 #include "ld9040_gamma.h"
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

