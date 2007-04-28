From: akpm@linux-foundation.org
Subject: - video4linux-fix-audio-input-for-avertv-go-007.patch removed from -mm tree
Date: Sat, 28 Apr 2007 05:27:51 -0700
Message-ID: <200704281227.l3SCRpB6021380@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031524AbXD1M2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 08:28:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: damencho@damencho.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     video4linux: Fix audio input for AverTv Go 007
has been removed from the -mm tree.  Its filename was
     video4linux-fix-audio-input-for-avertv-go-007.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: video4linux: Fix audio input for AverTv Go 007
From: "Damian Minkov" <damencho@damencho.com>

Fix audio input source for capturing(playing) audio on AverTv Go 007 cards.

Signed-off-by: Damian Minkov <damencho@damencho.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/saa7134/saa7134-cards.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/media/video/saa7134/saa7134-cards.c~video4linux-fix-audio-input-for-avertv-go-007 drivers/media/video/saa7134/saa7134-cards.c
--- a/drivers/media/video/saa7134/saa7134-cards.c~video4linux-fix-audio-input-for-avertv-go-007
+++ a/drivers/media/video/saa7134/saa7134-cards.c
@@ -1543,12 +1543,12 @@ struct saa7134_board saa7134_boards[] = 
 		},{
 			.name = name_comp1,
 			.vmux = 0,
-			.amux = LINE2,
+			.amux = LINE1,
 			.gpio = 0x02,
 		},{
 			.name = name_svideo,
 			.vmux = 6,
-			.amux = LINE2,
+			.amux = LINE1,
 			.gpio = 0x02,
 		}},
 		.radio = {
_

Patches currently in -mm which might be from damencho@damencho.com are

origin.patch
git-dvb.patch
video4linux-fix-audio-input-for-avertv-go-007.patch
