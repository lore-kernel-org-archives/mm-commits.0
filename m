From: akpm@linux-foundation.org
Subject: [merged] zram-add-copyright.patch removed from -mm tree
Date: Fri, 31 Jan 2014 11:16:13 -0800
Message-ID: <52ebf67d.rnMKjU3Lg/oz28ng%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651AbaAaTQN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 14:16:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org

Subject: [merged] zram-add-copyright.patch removed from -mm tree
To: minchan@kernel.org,ngupta@vflare.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 11:16:13 -0800


The patch titled
     Subject: zram: add copyright
has been removed from the -mm tree.  Its filename was
     zram-add-copyright.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: add copyright

Add my copyright to the zram source code which I maintain.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    1 +
 drivers/block/zram/zram_drv.h |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/block/zram/zram_drv.c~zram-add-copyright drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-add-copyright
+++ a/drivers/block/zram/zram_drv.c
@@ -2,6 +2,7 @@
  * Compressed RAM block device
  *
  * Copyright (C) 2008, 2009, 2010  Nitin Gupta
+ *               2012, 2013 Minchan Kim
  *
  * This code is released using a dual license strategy: BSD/GPL
  * You can choose the licence that better fits your requirements.
diff -puN drivers/block/zram/zram_drv.h~zram-add-copyright drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-add-copyright
+++ a/drivers/block/zram/zram_drv.h
@@ -2,6 +2,7 @@
  * Compressed RAM block device
  *
  * Copyright (C) 2008, 2009, 2010  Nitin Gupta
+ *               2012, 2013 Minchan Kim
  *
  * This code is released using a dual license strategy: BSD/GPL
  * You can choose the licence that better fits your requirements.
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
debugging-keep-track-of-page-owners.patch

