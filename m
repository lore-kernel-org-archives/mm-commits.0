From: akpm@linux-foundation.org
Subject: + mm-fix-a-typo-of-migrate_reserve-in-comment.patch added to -mm
 tree
Date: Wed, 07 Jan 2015 13:33:57 -0800
Message-ID: <54ada645.BWaEX0v2oxkIaVHL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201AbbAGVd6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2015 16:33:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix typo of MIGRATE_RESERVE in comment
has been added to the -mm tree.  Its filename is
     mm-fix-a-typo-of-migrate_reserve-in-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-a-typo-of-migrate_reserve-in-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-a-typo-of-migrate_reserve-in-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-fix-a-typo-of-migrate_reserve-in-comment.patch
kexec-remove-never-used-member-destination-in-kimage.patch
vmcore-fix-pt_note-n_namesz-n_descsz-overflow-issue.patch

