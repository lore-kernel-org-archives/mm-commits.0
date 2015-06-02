From: akpm@linux-foundation.org
Subject: + maintainers-add-zpool.patch added to -mm tree
Date: Tue, 02 Jun 2015 15:31:27 -0700
Message-ID: <556e2ebf.1ts2aiGW7HX21Krn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbbFBWb2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2015 18:31:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, minchan@kernel.org, ngupta@vflare.org, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add zpool
has been added to the -mm tree.  Its filename is
     maintainers-add-zpool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-zpool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-zpool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -11044,6 +11044,13 @@ L:	zd1211-devs@lists.sourceforge.net (su
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

mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
frontswap-allow-multiple-backends.patch
zpool-change-pr_info-to-pr_debug.patch
zpool-remove-zpool_evict.patch
maintainers-add-zpool.patch
linux-next.patch

