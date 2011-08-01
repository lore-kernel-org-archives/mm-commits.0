From: akpm@linux-foundation.org
Subject: [merged] maintainers-orphan-framerelay-dlci.patch removed from -mm tree
Date: Mon, 01 Aug 2011 11:49:23 -0700
Message-ID: <201108011847.p71IlF1F005624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936Ab1HASrU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2011 14:47:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, davem@davemloft.net, shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: orphan FrameRelay DLCI
has been removed from the -mm tree.  Its filename was
     maintainers-orphan-framerelay-dlci.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: orphan FrameRelay DLCI
From: Joe Perches <joe@perches.com>

Mike McLagan hasn't contributed in many years and his email bounces.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-orphan-framerelay-dlci MAINTAINERS
--- a/MAINTAINERS~maintainers-orphan-framerelay-dlci
+++ a/MAINTAINERS
@@ -2643,9 +2643,8 @@ S:	Maintained
 F:	arch/x86/math-emu/
 
 FRAME RELAY DLCI/FRAD (Sangoma drivers too)
-M:	Mike McLagan <mike.mclagan@linux.org>
 L:	netdev@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	drivers/net/wan/dlci.c
 F:	drivers/net/wan/sdla.c
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch

