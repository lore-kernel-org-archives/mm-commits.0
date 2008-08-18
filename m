From: akpm@linux-foundation.org
Subject: - maintainers-add-maintainers-for-gru-xpc-xpnet-and-xp.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:40:16 -0700
Message-ID: <200808181940.m7IJeGZZ008437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934062AbYHRTsY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:48:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add maintainers for GRU, XPC, XPNET and XP
has been removed from the -mm tree.  Its filename was
     maintainers-add-maintainers-for-gru-xpc-xpnet-and-xp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add maintainers for GRU, XPC, XPNET and XP
From: Jack Steiner <steiner@sgi.com>

Add MAINTAINERS for GRU, XPNET, XPC and XP drivers.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN MAINTAINERS~maintainers-add-maintainers-for-gru-xpc-xpnet-and-xp MAINTAINERS
--- a/MAINTAINERS~maintainers-add-maintainers-for-gru-xpc-xpnet-and-xp
+++ a/MAINTAINERS
@@ -3754,6 +3754,16 @@ L:	linux-visws-devel@lists.sf.net
 W:	http://linux-visws.sf.net
 S:	Maintained for 2.6.
 
+SGI GRU DRIVER
+P:	Jack Steiner
+M:	steiner@sgi.com
+S:	Maintained
+
+SGI XP/XPC/XPNET DRIVER
+P:	Dean Nelson
+M:	dcn@sgi.com
+S:	Maintained
+
 SIMTEC EB110ATX (Chalice CATS)
 P:	Ben Dooks
 P:	Vincent Sanders
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch
linux-next.patch
drivers-misc-use-div_round_up.patch

