From: akpm@linux-foundation.org
Subject: + kbuild-remove-extraneous-blank-line-after-declaration-of-usage.patch added to -mm tree
Date: Mon, 27 Jul 2009 16:23:01 -0700
Message-ID: <200907272323.n6RNN15g026826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750737AbZG0XXg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jul 2009 19:23:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tsrk@tsrk.net, sam@ravnborg.org


The patch titled
     kbuild: remove extraneous blank line after declaration of usage()
has been added to the -mm tree.  Its filename is
     kbuild-remove-extraneous-blank-line-after-declaration-of-usage.patch

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
Subject: kbuild: remove extraneous blank line after declaration of usage()
From: Trevor Keith <tsrk@tsrk.net>

Signed-off-by: Trevor Keith <tsrk@tsrk.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/basic/fixdep.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN scripts/basic/fixdep.c~kbuild-remove-extraneous-blank-line-after-declaration-of-usage scripts/basic/fixdep.c
--- a/scripts/basic/fixdep.c~kbuild-remove-extraneous-blank-line-after-declaration-of-usage
+++ a/scripts/basic/fixdep.c
@@ -125,7 +125,6 @@ char *depfile;
 char *cmdline;
 
 static void usage(void)
