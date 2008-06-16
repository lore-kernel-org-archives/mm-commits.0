From: akpm@linux-foundation.org
Subject: - maintainers-update-maintainership-of-pxa2xx-pxa3xx.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:03:38 -0700
Message-ID: <200806160603.m5G63cmN010614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363AbYFPGD4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:03:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.y.miao@gmail.com, eric.miao@marvell.com, nico@marvell.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update maintainership of pxa2xx/pxa3xx
has been removed from the -mm tree.  Its filename was
     maintainers-update-maintainership-of-pxa2xx-pxa3xx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: update maintainership of pxa2xx/pxa3xx
From: Eric Miao <eric.y.miao@gmail.com>

Signed-off-by: Eric Miao <eric.miao@marvell.com>
Acked-by: Russell King <rmk@arm.linux.org.uk>
Acked-by: Nicolas Pitre <nico@marvell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-update-maintainership-of-pxa2xx-pxa3xx MAINTAINERS
--- a/MAINTAINERS~maintainers-update-maintainership-of-pxa2xx-pxa3xx
+++ a/MAINTAINERS
@@ -3330,9 +3330,11 @@ L:	video4linux-list@redhat.com
 W:	http://www.isely.net/pvrusb2/
 S:	Maintained
 
-PXA2xx SUPPORT
-P:	Nicolas Pitre
-M:	nico@cam.org
+PXA2xx/PXA3xx SUPPORT
+P:	Eric Miao
+M:	eric.miao@marvell.com
+P:	Russell King
+M:	linux@arm.linux.org.uk
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 S:	Maintained
 
_

Patches currently in -mm which might be from eric.y.miao@gmail.com are

origin.patch
linux-next.patch

