From: akpm@osdl.org
Subject: - pmagb-b-fb-fix-a-default-clock.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:13:10 -0800
Message-ID: <200612082013.kB8KDACC003068@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59483 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946747AbWLHUNZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:13:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     pmagb-b-fb: Fix a default clock frequency
has been removed from the -mm tree.  Its filename was
     pmagb-b-fb-fix-a-default-clock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pmagb-b-fb: Fix a default clock frequency
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Inspection of real hardware has revealed one of the clock frequencies known
to be supported by PMAGB-B hardware is off by 3kHz.  Following is a fix. 
Please apply.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/pmagb-b-fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/pmagb-b-fb.c~pmagb-b-fb-fix-a-default-clock drivers/video/pmagb-b-fb.c
--- a/drivers/video/pmagb-b-fb.c~pmagb-b-fb-fix-a-default-clock
+++ a/drivers/video/pmagb-b-fb.c
@@ -186,7 +186,7 @@ static void __init pmagbbfb_screen_setup
 static void __init pmagbbfb_osc_setup(struct fb_info *info)
 {
 	static unsigned int pmagbbfb_freqs[] __initdata = {
-		130808, 119843, 104000, 92980, 74367, 72800,
+		130808, 119843, 104000, 92980, 74370, 72800,
 		69197, 66000, 65000, 50350, 36000, 32000, 25175
 	};
 	struct pmagbbfb_par *par = info->par;
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
pmagb-b-fb-fix-a-default-clock.patch

