From: akpm@linux-foundation.org
Subject: [merged] maintainers-mark-superh-orphan.patch removed from -mm
 tree
Date: Fri, 04 Apr 2014 12:33:02 -0700
Message-ID: <533f08ee.5RGF4yEVR5WMt1Cz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43233 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbaDDTdD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, pebolle@tiscali.nl, paul.mundt@gmail.com, magnus.damm@gmail.com, kuninori.morimoto.gx@renesas.com, horms@verge.net.au, Laurent.pinchart@ideasonboard.com, geert+renesas@linux-m68k.org

Subject: [merged] maintainers-mark-superh-orphan.patch removed from -mm tree
To: geert+renesas@linux-m68k.org,Laurent.pinchart@ideasonboard.com,horms@verge.net.au,kuninori.morimoto.gx@renesas.com,magnus.damm@gmail.com,paul.mundt@gmail.com,pebolle@tiscali.nl,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:02 -0700


The patch titled
     Subject: MAINTAINERS: mark SuperH orphan
has been removed from the -mm tree.  Its filename was
     maintainers-mark-superh-orphan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: MAINTAINERS: mark SuperH orphan

Paul Mundt's email address bounces regularly, and he hasn't taken any
SuperH patches for about one year.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Suggested-by: Paul Bolle <pebolle@tiscali.nl>
Cc: Paul Mundt <paul.mundt@gmail.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Cc: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    4 ++++
 MAINTAINERS |    4 +---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN CREDITS~maintainers-mark-superh-orphan CREDITS
--- a/CREDITS~maintainers-mark-superh-orphan
+++ a/CREDITS
@@ -2564,6 +2564,10 @@ N: Wolfgang Muees
 E: wolfgang@iksw-muees.de
 D: Auerswald USB driver
 
+N: Paul Mundt
+E: paul.mundt@gmail.com
+D: SuperH maintainer
+
 N: Ian A. Murdock
 E: imurdock@gnu.ai.mit.edu
 D: Creator of Debian distribution
diff -puN MAINTAINERS~maintainers-mark-superh-orphan MAINTAINERS
--- a/MAINTAINERS~maintainers-mark-superh-orphan
+++ a/MAINTAINERS
@@ -8478,12 +8478,10 @@ S:	Maintained
 F:	drivers/net/ethernet/dlink/sundance.c
 
 SUPERH
-M:	Paul Mundt <lethal@linux-sh.org>
 L:	linux-sh@vger.kernel.org
 W:	http://www.linux-sh.org
 Q:	http://patchwork.kernel.org/project/linux-sh/list/
-T:	git git://github.com/pmundt/linux-sh.git sh-latest
-S:	Supported
+S:	Orphan
 F:	Documentation/sh/
 F:	arch/sh/
 F:	drivers/sh/
_

Patches currently in -mm which might be from geert+renesas@linux-m68k.org are

origin.patch
linux-next.patch

