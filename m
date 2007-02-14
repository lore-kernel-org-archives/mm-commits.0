From: akpm@linux-foundation.org
Subject: + video4linux-fix-audio-input-for-avertv-go-007.patch added to -mm tree
Date: Wed, 14 Feb 2007 13:17:58 -0800
Message-ID: <200702142117.l1ELHwbX009426@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46244 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932620AbXBNVSH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 16:18:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damencho@damencho.com, mchehab@infradead.org


The patch titled
     video4linux: Fix audio input for AverTv Go 007
has been added to the -mm tree.  Its filename is
     video4linux-fix-audio-input-for-avertv-go-007.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: video4linux: Fix audio input for AverTv Go 007
From: "Damian Minkov" <damencho@damencho.com>

Fix audio input source for capturing(playing) audio on AverTv Go 007 cards.

Signed-off-by: Damian Minkov <damencho@damencho.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/saa7134/saa7134-cards.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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

video4linux-fix-audio-input-for-avertv-go-007.patch
