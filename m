From: akpm@linux-foundation.org
Subject: + fb-nvidiafb-recognizes-geforcego-7300-chip-as-mobile.patch added to -mm tree
Date: Tue, 31 Mar 2009 16:37:05 -0700
Message-ID: <200903312337.n2VNb5KJ010798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764241AbZCaXiy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 19:38:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sergey.senozhatsky@mail.by


The patch titled
     fb: nvidiafb recognizes geforcego 7300 chip as mobile
has been added to the -mm tree.  Its filename is
     fb-nvidiafb-recognizes-geforcego-7300-chip-as-mobile.patch

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
Subject: fb: nvidiafb recognizes geforcego 7300 chip as mobile
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>

nvidiafb recognizes geforcego 7300 chip as mobile

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nv_setup.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/nvidia/nv_setup.c~fb-nvidiafb-recognizes-geforcego-7300-chip-as-mobile drivers/video/nvidia/nv_setup.c
--- a/drivers/video/nvidia/nv_setup.c~fb-nvidiafb-recognizes-geforcego-7300-chip-as-mobile
+++ a/drivers/video/nvidia/nv_setup.c
@@ -362,6 +362,7 @@ int NVCommonSetup(struct fb_info *info)
 	case 0x0186:
 	case 0x0187:
 	case 0x018D:
+	case 0x01D7:
 	case 0x0228:
 	case 0x0286:
 	case 0x028C:
_

Patches currently in -mm which might be from sergey.senozhatsky@mail.by are

fb-nvidiafb-recognizes-geforcego-7300-chip-as-mobile.patch

