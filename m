From: akpm@linux-foundation.org
Subject: + autofs4-comment-typo-remove-a-a-doubled-word.patch added to -mm tree
Date: Mon, 21 Jul 2014 16:00:07 -0700
Message-ID: <53cd9b77.viJKB4deXEF+fXLp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:65034 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaGUXAI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Jul 2014 19:00:08 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so1676527oah.4
        for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2014 16:00:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: comment typo: remove a a doubled word
has been added to the -mm tree.  Its filename is
     autofs4-comment-typo-remove-a-a-doubled-word.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs4-comment-typo-remove-a-a-doubled-word.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs4-comment-typo-remove-a-a-doubled-word.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -373,7 +373,7 @@ static struct vfsmount *autofs4_d_automo
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

autofs4-remove-unused-autofs4_ispending.patch
autofs4-remove-a-redundant-assignment.patch
autofs4-comment-typo-remove-a-a-doubled-word.patch
autofs4-remove-some-unused-inline-functions.patch
autofs4-dont-take-spinlock-when-not-needed-in-autofs4_lookup_expiring.patch
linux-next.patch

