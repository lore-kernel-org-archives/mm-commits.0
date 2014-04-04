From: akpm@linux-foundation.org
Subject: [merged]
 arch-sh-boards-board-sh7757lcrc-fixup-sdhi-register-size.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:29:51 -0700
Message-ID: <533f082f.+RleG1WTUbt1OPv0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbaDDT3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:29:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kuninori.morimoto.gx@renesas.com, horms@verge.net.au, geert@linux-m68k.org, kuninori.morimoto.gx@gmail.com

Subject: [merged] arch-sh-boards-board-sh7757lcrc-fixup-sdhi-register-size.patch removed from -mm tree
To: kuninori.morimoto.gx@gmail.com,geert@linux-m68k.org,horms@verge.net.au,kuninori.morimoto.gx@renesas.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:29:51 -0700


The patch titled
     Subject: arch/sh/boards/board-sh7757lcr.c: fixup SDHI register size
has been removed from the -mm tree.  Its filename was
     arch-sh-boards-board-sh7757lcrc-fixup-sdhi-register-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

