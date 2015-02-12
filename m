From: akpm@linux-foundation.org
Subject: [merged] mm-fix-a-typo-of-migrate_reserve-in-comment.patch
 removed from -mm tree
Date: Thu, 12 Feb 2015 11:36:11 -0800
Message-ID: <54dd00ab.p0sJnhpihXaSqEUC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbbBLTgM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:36:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix typo of MIGRATE_RESERVE in comment
has been removed from the -mm tree.  Its filename was
     mm-fix-a-typo-of-migrate_reserve-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm: fix typo of MIGRATE_RESERVE in comment

Found it when I want to jump to the definition of MIGRATE_RESERVE ctags.

Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mmzone.h~mm-fix-a-typo-of-migrate_reserve-in-comment include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-fix-a-typo-of-migrate_reserve-in-comment
+++ a/include/linux/mmzone.h
@@ -426,7 +426,7 @@ struct zone {
 	const char		*name;
 
 	/*
-	 * Number of MIGRATE_RESEVE page block. To maintain for just
+	 * Number of MIGRATE_RESERVE page block. To maintain for just
 	 * optimization. Protected by zone->lock.
 	 */
 	int			nr_migrate_reserve_block;
_

Patches currently in -mm which might be from bhe@redhat.com are

origin.patch
kexec-remove-never-used-member-destination-in-kimage.patch
vmcore-fix-pt_note-n_namesz-n_descsz-overflow-issue.patch

