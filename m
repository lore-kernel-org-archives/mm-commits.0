From: akpm@linux-foundation.org
Subject: [merged] autofs4-comment-typo-remove-a-a-doubled-word.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:38:30 -0700
Message-ID: <53ea6d36.a7iTifoMPGQssdvR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f73.google.com ([209.85.218.73]:49687 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891AbaHLTia (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:38:30 -0400
Received: by mail-oi0-f73.google.com with SMTP id u20so1912456oif.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:38:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: comment typo: remove a a doubled word
has been removed from the -mm tree.  Its filename was
     autofs4-comment-typo-remove-a-a-doubled-word.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: autofs4: comment typo: remove a a doubled word

Signed-off-by: NeilBrown <neilb@suse.de>
Acked-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/autofs4/root.c~autofs4-comment-typo-remove-a-a-doubled-word fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-comment-typo-remove-a-a-doubled-word
+++ a/fs/autofs4/root.c
@@ -377,7 +377,7 @@ static struct vfsmount *autofs4_d_automo
 		 * this because the leaves of the directory tree under the
 		 * mount never trigger mounts themselves (they have an autofs
 		 * trigger mount mounted on them). But v4 pseudo direct mounts
-		 * do need the leaves to to trigger mounts. In this case we
+		 * do need the leaves to trigger mounts. In this case we
 		 * have no choice but to use the list_empty() check and
 		 * require user space behave.
 		 */
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
linux-next.patch

