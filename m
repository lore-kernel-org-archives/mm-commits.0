From: akpm@linux-foundation.org
Subject: - fs-remove-some-aop_truncated_page-fix.patch removed from -mm tree
Date: Tue, 07 Aug 2007 13:31:43 -0700
Message-ID: <200708072031.l77KVh32002495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59007 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759323AbXHGUcM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 16:32:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michal.k.k.piotrowski@gmail.com, mhalcrow@us.ibm.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     fs-remove-some-aop_truncated_page fix
has been removed from the -mm tree.  Its filename was
     fs-remove-some-aop_truncated_page-fix.patch

This patch was dropped because it was folded into fs-remove-some-aop_truncated_page.patch

------------------------------------------------------
Subject: fs-remove-some-aop_truncated_page fix
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

fs/ecryptfs/mmap.c: In function 'ecryptfs_get_lower_page':
fs/ecryptfs/mmap.c:585: warning: label 'retry' defined but not used

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/mmap.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN fs/ecryptfs/mmap.c~fs-remove-some-aop_truncated_page-fix fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~fs-remove-some-aop_truncated_page-fix
+++ a/fs/ecryptfs/mmap.c
@@ -582,7 +582,6 @@ int ecryptfs_get_lower_page(struct page 
 {
 	int rc = 0;
 
-retry:
 	*lower_page = grab_cache_page(lower_inode->i_mapping, lower_page_index);
 	if (!(*lower_page)) {
 		rc = -EINVAL;
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmail.com are

git-alsa.patch
git-kvm.patch
fs-remove-some-aop_truncated_page.patch
fs-remove-some-aop_truncated_page-fix.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
reiser4.patch
