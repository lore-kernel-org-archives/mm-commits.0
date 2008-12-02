From: akpm@linux-foundation.org
Subject: - spi-documentation-__initdata-on-struct.patch removed from -mm tree
Date: Tue, 02 Dec 2008 10:38:25 -0800
Message-ID: <200812021838.mB2IcPYD006881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753755AbYLBSih (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 13:38:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi documentation: use __initdata on struct
has been removed from the -mm tree.  Its filename was
     spi-documentation-__initdata-on-struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
gbefb-unsigned-var-pixclock-cannot-be-less-than-0.patch
ufs-sector_t-cannot-be-negative.patch
make-various-things-static.patch

