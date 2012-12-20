From: akpm@linux-foundation.org
Subject: + backlight-ld9040-reorder-inclusions-of-linux-xxxh.patch added to -mm tree
Date: Thu, 20 Dec 2012 12:34:14 -0800
Message-ID: <20121220203415.4478A82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:64244 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab2LTUeQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 15:34:16 -0500
Received: by mail-vc0-f201.google.com with SMTP id p1so406003vcq.4
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 12:34:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: backlight: ld9040: reorder inclusions of <linux/xxx.h>
has been added to the -mm tree.  Its filename is
     backlight-ld9040-reorder-inclusions-of-linux-xxxh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
backlight-add-lms501kf03-lcd-driver.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-ld9040-use-sleep-instead-of-delay.patch
backlight-ld9040-remove-unnecessary-null-deference-check.patch
backlight-ld9040-replace-efault-with-einval.patch
backlight-ld9040-remove-redundant-return-variables.patch
backlight-ld9040-reorder-inclusions-of-linux-xxxh.patch
backlight-s6e63m0-use-lowercase-names-of-structs.patch

