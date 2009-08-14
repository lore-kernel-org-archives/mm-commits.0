From: akpm@linux-foundation.org
Subject: [merged] kbuild-remove-extraneous-blank-line-after-declaration-of-usage.patch removed from -mm tree
Date: Fri, 14 Aug 2009 12:56:19 -0700
Message-ID: <200908141956.n7EJuKEp005626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757097AbZHNT4n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Aug 2009 15:56:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tsrk@tsrk.net, sam@ravnborg.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kbuild: remove extraneous blank line after declaration of usage()
has been removed from the -mm tree.  Its filename was
     kbuild-remove-extraneous-blank-line-after-declaration-of-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
