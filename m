From: akpm@linux-foundation.org
Subject: - memcg-allocate-all-page_cgroup-at-boot-fixpatch.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:52:51 -0700
Message-ID: <200810182352.m9INqpNi002012@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751839AbYJRXxY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:53:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg-allocate-all-page_cgroup-at-boot-fix.patch
has been removed from the -mm tree.  Its filename was
     memcg-allocate-all-page_cgroup-at-boot-fixpatch.patch

This patch was dropped because it was folded into memcg-allocate-all-page_cgroup-at-boot.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-allocate-all-page_cgroup-at-boot-fix.patch
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

compile fix to memcg-allocate-all-page_cgroup-at-boot.patch

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Makefile |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/Makefile~memcg-allocate-all-page_cgroup-at-boot-fixpatch mm/Makefile
--- a/mm/Makefile~memcg-allocate-all-page_cgroup-at-boot-fixpatch
+++ a/mm/Makefile
@@ -33,5 +33,4 @@ obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
-obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o
