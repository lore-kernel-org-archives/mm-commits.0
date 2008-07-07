From: akpm@linux-foundation.org
Subject: - w100fb-add-80-mhz-modeline.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:04:54 -0700
Message-ID: <200807070304.m6734slk004700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753193AbYGGDFA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:05:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: philipp.zabel@gmail.com, spyro@f2s.com, mm-commits@vger.kernel.org


The patch titled
     w100fb: add 80 MHz modeline
has been removed from the -mm tree.  Its filename was
     w100fb-add-80-mhz-modeline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w100fb: add 80 MHz modeline
From: Philipp Zabel <philipp.zabel@gmail.com>

This is needed for HTC Blueangel (w3200).  At 96MHz its screen flickers.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Acked-by: Ian Molton <spyro@f2s.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/w100fb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/w100fb.c~w100fb-add-80-mhz-modeline drivers/video/w100fb.c
--- a/drivers/video/w100fb.c~w100fb-add-80-mhz-modeline
+++ a/drivers/video/w100fb.c
@@ -1003,6 +1003,7 @@ static struct w100_pll_info xtal_1431800
 static struct w100_pll_info xtal_16000000[] = {
 	/*freq     M   N_int    N_fac  tfgoal  lock_time */
 	{ 72,      1,   8,       0,     0xe0,        48}, /* tfgoal guessed */
+	{ 80,      1,   9,       0,     0xe0,        13}, /* tfgoal guessed */
 	{ 95,      1,   10,      7,     0xe0,        38}, /* tfgoal guessed */
 	{ 96,      1,   11,      0,     0xe0,        36}, /* tfgoal guessed */
 	{  0,      0,   0,       0,        0,         0},
_

Patches currently in -mm which might be from philipp.zabel@gmail.com are

origin.patch
linux-next.patch

