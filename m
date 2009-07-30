From: akpm@linux-foundation.org
Subject: [merged] maintainers-move-arpd-to-credits.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:37:52 -0700
Message-ID: <200907302037.n6UKbqqV012182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478AbZG3UiZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:38:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: Move ARPD to CREDITS
has been removed from the -mm tree.  Its filename was
     maintainers-move-arpd-to-credits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: Move ARPD to CREDITS
From: Joe Perches <joe@perches.com>

Jonathan Layes is hard to find.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    3 +++
 MAINTAINERS |    6 ------
 2 files changed, 3 insertions(+), 6 deletions(-)

diff -puN CREDITS~maintainers-move-arpd-to-credits CREDITS
--- a/CREDITS~maintainers-move-arpd-to-credits
+++ a/CREDITS
@@ -2006,6 +2006,9 @@ E: paul@laufernet.com
 D: Soundblaster driver fixes, ISAPnP quirk
 S: California, USA
 
+N: Jonathan Layes
+D: ARPD support
+
 N: Tom Lees
 E: tom@lpsg.demon.co.uk
 W: http://www.lpsg.demon.co.uk/
diff -puN MAINTAINERS~maintainers-move-arpd-to-credits MAINTAINERS
--- a/MAINTAINERS~maintainers-move-arpd-to-credits
+++ a/MAINTAINERS
@@ -951,12 +951,6 @@ W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/vfp/
 
-ARPD SUPPORT
-P:	Jonathan Layes
-L:	netdev@vger.kernel.org
-S:	Maintained
-F:	net/ipv4/arp.c
