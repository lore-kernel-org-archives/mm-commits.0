From: akpm@linux-foundation.org
Subject: + maintainers-add-mailing-list-for-man-pages.patch added to -mm tree
Date: Thu, 02 Oct 2008 22:51:38 -0700
Message-ID: <200810030551.m935pcTi013196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721AbYJCFvl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 01:51:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mtk.manpages@googlemail.com, mtk.manpages@gmail.com


The patch titled
     MAINTAINERS: add mailing list for man-pages
has been added to the -mm tree.  Its filename is
     maintainers-add-mailing-list-for-man-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add mailing list for man-pages
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>

Nowadays, man-pages has an associated mailing list.  Mention that list
in MAINTAINERS.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-mailing-list-for-man-pages MAINTAINERS
--- a/MAINTAINERS~maintainers-add-mailing-list-for-man-pages
+++ a/MAINTAINERS
@@ -2704,6 +2704,7 @@ MAN-PAGES: MANUAL PAGES FOR LINUX -- Sec
 P:	Michael Kerrisk
 M:	mtk.manpages@gmail.com
 W:	http://www.kernel.org/doc/man-pages
+L:	linux-man@vger.kernel.org
 S:	Supported
 
 MARVELL LIBERTAS WIRELESS DRIVER
_

Patches currently in -mm which might be from mtk.manpages@googlemail.com are

maintainers-add-mailing-list-for-man-pages.patch
git-block.patch
rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
rlimit-permit-setting-rlimit_nofile-to-rlim_infinity-fix.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch

