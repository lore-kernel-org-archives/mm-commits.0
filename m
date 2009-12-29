From: akpm@linux-foundation.org
Subject: [merged] drivers-block-dac960c-use-dac960_v2_controller.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:33:06 -0800
Message-ID: <200912292133.nBTLX64c008677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818AbZL2VdQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:33:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/DAC960.c: use DAC960_V2_Controller
has been removed from the -mm tree.  Its filename was
     drivers-block-dac960c-use-dac960_v2_controller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/DAC960.c: use DAC960_V2_Controller
From: Julia Lawall <julia@diku.dk>

DAC960_LP_Controller and DAC960_V2_Controller have the same value, but
elsewhere it is DAC960_V1_Controller or DAC960_V2_Controller that is used
in the FirmwareType field.

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/DAC960.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/DAC960.c~drivers-block-dac960c-use-dac960_v2_controller drivers/block/DAC960.c
--- a/drivers/block/DAC960.c~drivers-block-dac960c-use-dac960_v2_controller
+++ a/drivers/block/DAC960.c
@@ -7101,7 +7101,7 @@ static struct DAC960_privdata DAC960_BA_
 
 static struct DAC960_privdata DAC960_LP_privdata = {
 	.HardwareType =		DAC960_LP_Controller,
-	.FirmwareType 	=	DAC960_LP_Controller,
+	.FirmwareType 	=	DAC960_V2_Controller,
 	.InterruptHandler =	DAC960_LP_InterruptHandler,
 	.MemoryWindowSize =	DAC960_LP_RegisterWindowSize,
 };
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-media-video-move-dereference-after-null-test.patch
arch-mips-alchemy-correct-code-taking-the-size-of-a-pointer.patch
drivers-isdn-eliminate-duplicated-test.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-edac-introduce-missing-kfree.patch

