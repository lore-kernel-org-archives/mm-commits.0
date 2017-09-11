From: akpm@linux-foundation.org
Subject: [merged]
 lib-cmldinec-clean-up-the-meaningless-comment.patch removed from -mm tree
Date: Mon, 11 Sep 2017 12:42:37 -0700
Message-ID: <20170911194237.hmHjU40XK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50274 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751110AbdIKTmi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:42:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/cmdline.c: remove meaningless comment
has been removed from the -mm tree.  Its filename was
     lib-cmldinec-clean-up-the-meaningless-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: lib/cmdline.c: remove meaningless comment

One line of code was commented out by c++ style comment for debugging, but
forgot removing it.

Clean it up.

Link: http://lkml.kernel.org/r/1503312113-11843-1-git-send-email-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cmdline.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN lib/cmdline.c~lib-cmldinec-clean-up-the-meaningless-comment lib/cmdline.c
--- a/lib/cmdline.c~lib-cmldinec-clean-up-the-meaningless-comment
+++ a/lib/cmdline.c
@@ -244,5 +244,4 @@ char *next_arg(char *args, char **param,
 
 	/* Chew up trailing spaces. */
 	return skip_spaces(next);
-	//return next;
 }
_

Patches currently in -mm which might be from bhe@redhat.com are


