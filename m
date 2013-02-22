From: akpm@linux-foundation.org
Subject: [merged] backlight-s6e63m0-reorder-inclusions-of-linux-xxxh.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:40:41 -0800
Message-ID: <20130222204041.A8C4A31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:55537 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767Ab3BVUkm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:40:42 -0500
Received: by mail-qc0-f201.google.com with SMTP id o22so103957qcr.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:40:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: s6e63m0: reorder inclusions of <linux/xxx.h>
has been removed from the -mm tree.  Its filename was
     backlight-s6e63m0-reorder-inclusions-of-linux-xxxh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: s6e63m0: reorder inclusions of <linux/xxx.h>

Reorder inclusions of <linux/xxx.h> for redability, according to
alphabetical ordering.  Also, unnecessary header comments are removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/s6e63m0.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff -puN drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-reorder-inclusions-of-linux-xxxh drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-reorder-inclusions-of-linux-xxxh
+++ a/drivers/video/backlight/s6e63m0.c
@@ -9,28 +9,19 @@
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
+#include <linux/spi/spi.h>
+#include <linux/wait.h>
 
 #include "s6e63m0_gamma.h"
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

