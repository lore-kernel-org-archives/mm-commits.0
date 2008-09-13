From: akpm@linux-foundation.org
Subject: - input-alps-add-signature-for-dualpoint-model-found-in-dell-latitude-e6500.patch removed from -mm tree
Date: Sat, 13 Sep 2008 00:45:54 -0700
Message-ID: <200809130745.m8D7jsBM026800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753245AbYIMHp7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Sep 2008 03:45:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: el@prans.net, mm-commits@vger.kernel.org


The patch titled
     input: alps: add signature for DualPoint model found in Dell Latitude E6500
has been removed from the -mm tree.  Its filename was
     input-alps-add-signature-for-dualpoint-model-found-in-dell-latitude-e6500.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: alps: add signature for DualPoint model found in Dell Latitude E6500
From: Elvis Pranskevichus <el@prans.net>

Signed-off-by: Elvis Pranskevichus <el@prans.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/alps.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/input/mouse/alps.c~input-alps-add-signature-for-dualpoint-model-found-in-dell-latitude-e6500 drivers/input/mouse/alps.c
--- a/drivers/input/mouse/alps.c~input-alps-add-signature-for-dualpoint-model-found-in-dell-latitude-e6500
+++ a/drivers/input/mouse/alps.c
@@ -54,6 +54,7 @@ static const struct alps_model_info alps
 	{ { 0x20, 0x02, 0x0e },	0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT }, /* XXX */
 	{ { 0x22, 0x02, 0x0a },	0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT },
 	{ { 0x22, 0x02, 0x14 }, 0xff, 0xff, ALPS_PASS | ALPS_DUALPOINT }, /* Dell Latitude D600 */
+	{ { 0x62, 0x02, 0x14 }, 0xcf, 0xcf, ALPS_PASS | ALPS_DUALPOINT }, /* Dell Latitude E6500 */
 	{ { 0x73, 0x02, 0x50 }, 0xcf, 0xcf, ALPS_FW_BK_1 } /* Dell Vostro 1400 */
 };
 
_

Patches currently in -mm which might be from el@prans.net are

linux-next.patch

