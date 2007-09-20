From: akpm@linux-foundation.org
Subject: + avertv-studio-307-has-only-one-composite-input.patch added to -mm tree
Date: Wed, 19 Sep 2007 22:15:48 -0700
Message-ID: <200709200515.l8K5Fmbr029483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48293 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752693AbXITFQh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 01:16:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stsp@aknet.ru, mchehab@infradead.org, nshmyrev@yandex.ru


The patch titled
     AverTV Studio 307 has only one composite input
has been added to the -mm tree.  Its filename is
     avertv-studio-307-has-only-one-composite-input.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: AverTV Studio 307 has only one composite input
From: Stas Sergeev <stsp@aknet.ru>

AverTV Studio 307 has only one composite input.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>
Acked-by: Nickolay V. Shmyrev <nshmyrev@yandex.ru>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/saa7134/saa7134-cards.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/media/video/saa7134/saa7134-cards.c~avertv-studio-307-has-only-one-composite-input drivers/media/video/saa7134/saa7134-cards.c
--- a/drivers/media/video/saa7134/saa7134-cards.c~avertv-studio-307-has-only-one-composite-input
+++ a/drivers/media/video/saa7134/saa7134-cards.c
@@ -32,6 +32,7 @@ static char name_mute[]    = "mute";
 static char name_radio[]   = "Radio";
 static char name_tv[]      = "Television";
 static char name_tv_mono[] = "TV (mono only)";
+static char name_comp[]    = "Composite";
 static char name_comp1[]   = "Composite1";
 static char name_comp2[]   = "Composite2";
 static char name_comp3[]   = "Composite3";
@@ -1535,12 +1536,7 @@ struct saa7134_board saa7134_boards[] = 
 			.tv   = 1,
 			.gpio = 0x00,
 		},{
-			.name = name_comp1,
-			.vmux = 0,
-			.amux = LINE1,
-			.gpio = 0x02,
-		},{
-			.name = name_comp2,
+			.name = name_comp,
 			.vmux = 3,
 			.amux = LINE1,
 			.gpio = 0x02,
_

Patches currently in -mm which might be from stsp@aknet.ru are

origin.patch
fix-mux-setup-for-composite-sound-on-avertv-307.patch
avertv-studio-307-has-only-one-composite-input.patch
