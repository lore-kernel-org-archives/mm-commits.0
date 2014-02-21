From: akpm@linux-foundation.org
Subject: + arch-sh-boards-board-sh7757lcrc-fixup-sdhi-register-size.patch
 added to -mm tree
Date: Fri, 21 Feb 2014 13:03:45 -0800
Message-ID: <5307bf31.eJqJwoGvHtIKdZ81%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbaBUVDr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 16:03:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kuninori.morimoto.gx@renesas.com, horms@verge.net.au, geert@linux-m68k.org, kuninori.morimoto.gx@gmail.com

Subject: + arch-sh-boards-board-sh7757lcrc-fixup-sdhi-register-size.patch added to -mm tree
To: kuninori.morimoto.gx@gmail.com,geert@linux-m68k.org,horms@verge.net.au,kuninori.morimoto.gx@renesas.com
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 13:03:45 -0800


The patch titled
     Subject: arch/sh/boards/board-sh7757lcr.c: fixup SDHI register size
has been added to the -mm tree.  Its filename is
     arch-sh-boards-board-sh7757lcrc-fixup-sdhi-register-size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-sh-boards-board-sh7757lcrc-fixup-sdhi-register-size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-sh-boards-board-sh7757lcrc-fixup-sdhi-register-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Subject: arch/sh/boards/board-sh7757lcr.c: fixup SDHI register size

sh7757lcr SDHI register size is 0x100

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/boards/board-sh7757lcr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sh/boards/board-sh7757lcr.c~arch-sh-boards-board-sh7757lcrc-fixup-sdhi-register-size arch/sh/boards/board-sh7757lcr.c
--- a/arch/sh/boards/board-sh7757lcr.c~arch-sh-boards-board-sh7757lcrc-fixup-sdhi-register-size
+++ a/arch/sh/boards/board-sh7757lcr.c
@@ -252,7 +252,7 @@ static struct sh_mobile_sdhi_info sdhi_i
 static struct resource sdhi_resources[] = {
 	[0] = {
 		.start  = 0xffe50000,
-		.end    = 0xffe501ff,
+		.end    = 0xffe500ff,
 		.flags  = IORESOURCE_MEM,
 	},
 	[1] = {
_

Patches currently in -mm which might be from kuninori.morimoto.gx@gmail.com are

arch-sh-boards-board-sh7757lcrc-fixup-sdhi-register-size.patch

