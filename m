From: akpm@linux-foundation.org
Subject: + backlight-s6e63m0-reorder-inclusions-of-linux-xxxh.patch added to -mm tree
Date: Thu, 20 Dec 2012 12:36:03 -0800
Message-ID: <20121220203603.EC8B582004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:58571 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2LTUgE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 15:36:04 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so94848ghb.3
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 12:36:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: backlight: s6e63m0: reorder inclusions of <linux/xxx.h>
has been added to the -mm tree.  Its filename is
     backlight-s6e63m0-reorder-inclusions-of-linux-xxxh.patch

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
backlight-add-lms501kf03-lcd-driver.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-ld9040-use-sleep-instead-of-delay.patch
backlight-ld9040-remove-unnecessary-null-deference-check.patch
backlight-ld9040-replace-efault-with-einval.patch
backlight-ld9040-remove-redundant-return-variables.patch
backlight-ld9040-reorder-inclusions-of-linux-xxxh.patch
backlight-s6e63m0-use-lowercase-names-of-structs.patch
backlight-s6e63m0-use-sleep-instead-of-delay.patch
backlight-s6e63m0-remove-unnecessary-null-deference-check.patch
backlight-s6e63m0-replace-efault-with-einval.patch
backlight-s6e63m0-remove-redundant-variable-before_power.patch
backlight-s6e63m0-reorder-inclusions-of-linux-xxxh.patch
backlight-ams369fg06-use-sleep-instead-of-delay.patch
backlight-ams369fg06-remove-unnecessary-null-deference-check.patch
backlight-ams369fg06-replace-efault-with-einval.patch
backlight-ams369fg06-remove-redundant-variable-before_power.patch
backlight-ams369fg06-reorder-inclusions-of-linux-xxxh.patch

