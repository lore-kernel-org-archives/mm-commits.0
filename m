From: akpm@linux-foundation.org
Subject: [folded] dio-optimize-cache-misses-in-the-submission-path-v2-fix.patch removed from -mm tree
Date: Thu, 12 Jan 2012 16:58:48 -0800
Message-ID: <20120113005849.4DF2620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:36893 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426Ab2AMA6u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2012 19:58:50 -0500
Received: by mail-wi0-f202.google.com with SMTP id hq12so87123wib.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2012 16:58:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dio: using prefetch requires including prefetch.h
has been removed from the -mm tree.  Its filename was
     dio-optimize-cache-misses-in-the-submission-path-v2-fix.patch

This patch was dropped because it was folded into dio-optimize-cache-misses-in-the-submission-path-v2.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: dio: using prefetch requires including prefetch.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/direct-io.c~dio-optimize-cache-misses-in-the-submission-path-v2-fix fs/direct-io.c
--- a/fs/direct-io.c~dio-optimize-cache-misses-in-the-submission-path-v2-fix
+++ a/fs/direct-io.c
@@ -36,6 +36,7 @@
 #include <linux/rwsem.h>
 #include <linux/uio.h>
 #include <linux/atomic.h>
+#include <linux/prefetch.h>
 
 /*
  * How many user pages to map in one call to get_user_pages().  This determines
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
kdump-add-udev-events-for-memory-online-offline.patch
dio-optimize-cache-misses-in-the-submission-path-v2.patch

