From: akpm@linux-foundation.org
Subject: + nommu-ramfs-remove-unused-local-var.patch added to -mm tree
Date: Wed, 16 Dec 2009 15:33:39 -0800
Message-ID: <200912162333.nBGNXd0e022133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761579AbZLPXeD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 18:34:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, dhowells@redhat.com, gerg@snapgear.com


The patch titled
     nommu: ramfs: remove unused local var
has been added to the -mm tree.  Its filename is
     nommu-ramfs-remove-unused-local-var.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: ramfs: remove unused local var
From: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ramfs/file-nommu.c~nommu-ramfs-remove-unused-local-var fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~nommu-ramfs-remove-unused-local-var
+++ a/fs/ramfs/file-nommu.c
@@ -60,7 +60,7 @@ const struct inode_operations ramfs_file
  */
 int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
 {
-	unsigned long npages, xpages, loop, limit;
+	unsigned long npages, xpages, loop;
 	struct page *pages;
 	unsigned order;
 	void *data;
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
nommu-ramfs-remove-unused-local-var.patch
linux-next.patch
documentation-cpu-freq-governorstxt-fix-default-value-for-ondemand-governor.patch
serial-fit-blackfin-uart-over-sport-driver-into-common-uart-infrastructure.patch
spidev-add-proper-section-markers.patch

