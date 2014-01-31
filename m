From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-add-copyright.patch removed from -mm tree
Date: Fri, 31 Jan 2014 11:16:15 -0800
Message-ID: <52ebf67f.cT28J6pgbcvzh5Zr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50597 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932811AbaAaTQP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 14:16:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org

Subject: [merged] zsmalloc-add-copyright.patch removed from -mm tree
To: minchan@kernel.org,ngupta@vflare.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 11:16:15 -0800


The patch titled
     Subject: zsmalloc: add copyright
has been removed from the -mm tree.  Its filename was
     zsmalloc-add-copyright.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: add copyright

Add my copyright to the zsmalloc source code which I maintain.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zsmalloc.h |    1 +
 mm/zsmalloc.c            |    1 +
 2 files changed, 2 insertions(+)

diff -puN include/linux/zsmalloc.h~zsmalloc-add-copyright include/linux/zsmalloc.h
--- a/include/linux/zsmalloc.h~zsmalloc-add-copyright
+++ a/include/linux/zsmalloc.h
@@ -2,6 +2,7 @@
  * zsmalloc memory allocator
  *
  * Copyright (C) 2011  Nitin Gupta
+ * Copyright (C) 2012, 2013 Minchan Kim
  *
  * This code is released using a dual license strategy: BSD/GPL
  * You can choose the license that better fits your requirements.
diff -puN mm/zsmalloc.c~zsmalloc-add-copyright mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-add-copyright
+++ a/mm/zsmalloc.c
@@ -2,6 +2,7 @@
  * zsmalloc memory allocator
  *
  * Copyright (C) 2011  Nitin Gupta
+ * Copyright (C) 2012, 2013 Minchan Kim
  *
  * This code is released using a dual license strategy: BSD/GPL
  * You can choose the license that better fits your requirements.
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
debugging-keep-track-of-page-owners.patch

