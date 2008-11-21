From: akpm@linux-foundation.org
Subject: + spi-documentation-__initdata-on-struct.patch added to -mm tree
Date: Fri, 21 Nov 2008 14:42:41 -0800
Message-ID: <200811212242.mALMgfcD032647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753618AbYKUWnS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 17:43:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, dbrownell@users.sourceforge.net


The patch titled
     spi documentation: use __initdata on struct
has been added to the -mm tree.  Its filename is
     spi-documentation-__initdata-on-struct.patch

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
Subject: spi documentation: use __initdata on struct
From: roel kluin <roel.kluin@gmail.com>

Use __initdata for data, not __init.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/spi/spi-summary |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/spi/spi-summary~spi-documentation-__initdata-on-struct Documentation/spi/spi-summary
--- a/Documentation/spi/spi-summary~spi-documentation-__initdata-on-struct
+++ a/Documentation/spi/spi-summary
@@ -215,7 +215,7 @@ So for example arch/.../mach-*/board-*.c
 	/* if your mach-* infrastructure doesn't support kernels that can
 	 * run on multiple boards, pdata wouldn't benefit from "__init".
 	 */
-	static struct mysoc_spi_data __init pdata = { ... };
+	static struct mysoc_spi_data __initdata pdata = { ... };
 
 	static __init board_init(void)
 	{
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

spi-documentation-__initdata-on-struct.patch
linux-next.patch
ufs-sector_t-cannot-be-negative.patch
make-various-things-static.patch

