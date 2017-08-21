From: akpm@linux-foundation.org
Subject: + lib-cmldinec-clean-up-the-meaningless-comment.patch added to
 -mm tree
Date: Mon, 21 Aug 2017 13:28:31 -0700
Message-ID: <599b426f.mLd5SusMrd4QZ6oB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43560 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754015AbdHUU2c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2017 16:28:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/cmdline.c: remove meaningless comment
has been added to the -mm tree.  Its filename is
     lib-cmldinec-clean-up-the-meaningless-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-cmldinec-clean-up-the-meaningless-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-cmldinec-clean-up-the-meaningless-comment.patch

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

lib-cmldinec-clean-up-the-meaningless-comment.patch

