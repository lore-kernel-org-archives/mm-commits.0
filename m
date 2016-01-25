From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-return-arch-sh-to-maintained-state-with-new-maintainers.patch
 removed from -mm tree
Date: Mon, 25 Jan 2016 10:59:01 -0800
Message-ID: <56a67075.aFBxmB253U8hK0VK%akpm__7676.30763953111$1453748355$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932983AbcAYS7C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jan 2016 13:59:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dalias@libc.org, geert+renesas@glider.be, horms+renesas@verge.net.au, jeff@uClinux.org, peterz@infradead.org, rob@landley.net, stable@vger.kernel.org, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: return arch/sh to maintained state, with new maintainers
has been removed from the -mm tree.  Its filename was
     maintainers-return-arch-sh-to-maintained-state-with-new-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rich Felker <dalias@libc.org>
Subject: MAINTAINERS: return arch/sh to maintained state, with new maintainers

Add Yoshinori Sato and Rich Felker as maintainers for arch/sh
(SUPERH).

Signed-off-by: Rich Felker <dalias@libc.org>
Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Acked-by: D. Jeff Dionne <jeff@uClinux.org>
Acked-by: Rob Landley <rob@landley.net>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Simon Horman <horms+renesas@verge.net.au>
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-return-arch-sh-to-maintained-state-with-new-maintainers MAINTAINERS
--- a/MAINTAINERS~maintainers-return-arch-sh-to-maintained-state-with-new-maintainers
+++ a/MAINTAINERS
@@ -10453,9 +10453,11 @@ S:	Maintained
 F:	drivers/net/ethernet/dlink/sundance.c
 
 SUPERH
+M:	Yoshinori Sato <ysato@users.sourceforge.jp>
+M:	Rich Felker <dalias@libc.org>
 L:	linux-sh@vger.kernel.org
 Q:	http://patchwork.kernel.org/project/linux-sh/list/
-S:	Orphan
+S:	Maintained
 F:	Documentation/sh/
 F:	arch/sh/
 F:	drivers/sh/
_

Patches currently in -mm which might be from dalias@libc.org are


