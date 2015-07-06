From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-zpool.patch removed from -mm tree
Date: Mon, 06 Jul 2015 12:48:15 -0700
Message-ID: <559adb7f.LcbyyaF1UyYEPyna%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59673 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbbGFTsQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:48:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, minchan@kernel.org, ngupta@vflare.org, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add zpool
has been removed from the -mm tree.  Its filename was
     maintainers-add-zpool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: MAINTAINERS: add zpool

Add entry for zpool to MAINTAINERS file.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN MAINTAINERS~maintainers-add-zpool MAINTAINERS
--- a/MAINTAINERS~maintainers-add-zpool
+++ a/MAINTAINERS
@@ -11350,6 +11350,13 @@ L:	zd1211-devs@lists.sourceforge.net (su
 S:	Maintained
 F:	drivers/net/wireless/zd1211rw/
 
+ZPOOL COMPRESSED PAGE STORAGE API
+M:	Dan Streetman <ddstreet@ieee.org>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	mm/zpool.c
+F:	include/linux/zpool.h
+
 ZR36067 VIDEO FOR LINUX DRIVER
 L:	mjpeg-users@lists.sourceforge.net
 L:	linux-media@vger.kernel.org
_

Patches currently in -mm which might be from ddstreet@ieee.org are


