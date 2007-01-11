From: akpm@osdl.org
Subject: - nfs-fix-race-in-nfs_release_page-tidy.patch removed from -mm tree
Date: Wed, 10 Jan 2007 23:08:18 -0800
Message-ID: <200701110708.l0B78IGf019011@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37250 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965314AbXAKHI0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 02:08:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, Trond.Myklebust@netapp.com, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     nfs-fix-race-in-nfs_release_page-tidy
has been removed from the -mm tree.  Its filename was
     nfs-fix-race-in-nfs_release_page-tidy.patch

This patch was dropped because it was folded into nfs-fix-race-in-nfs_release_page.patch

------------------------------------------------------
Subject: nfs-fix-race-in-nfs_release_page-tidy
From: Andrew Morton <akpm@osdl.org>

Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/truncate.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/truncate.c~nfs-fix-race-in-nfs_release_page-tidy mm/truncate.c
--- a/mm/truncate.c~nfs-fix-race-in-nfs_release_page-tidy
+++ a/mm/truncate.c
@@ -341,8 +341,7 @@ failed:
 	return 0;
 }
 
-static int
-do_launder_page(struct address_space *mapping, struct page *page)
+static int do_launder_page(struct address_space *mapping, struct page *page)
 {
 	if (!PageDirty(page))
 		return 0;
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
nfs-fix-race-in-nfs_release_page.patch
nfs-fix-race-in-nfs_release_page-tidy.patch
fd_zero-build-fix.patch
