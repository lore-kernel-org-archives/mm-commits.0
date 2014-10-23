From: akpm@linux-foundation.org
Subject: + befs-remove-dead-code.patch added to -mm tree
Date: Thu, 23 Oct 2014 12:45:09 -0700
Message-ID: <54495ac5.k9WyCpTHvwlHoRkf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbaJWTpJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Oct 2014 15:45:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: befs: remove dead code
has been added to the -mm tree.  Its filename is
     befs-remove-dead-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/befs-remove-dead-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/befs-remove-dead-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: befs: remove dead code

Coverity id: 1042674

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN fs/befs/linuxvfs.c~befs-remove-dead-code fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~befs-remove-dead-code
+++ a/fs/befs/linuxvfs.c
@@ -271,10 +271,6 @@ more:
 	}
 	ctx->pos++;
 	goto more;
-
-	befs_debug(sb, "<--- %s pos %lld", __func__, ctx->pos);
