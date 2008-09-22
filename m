From: akpm@linux-foundation.org
Subject: + maintainers-add-entry-for-uvesafb.patch added to -mm tree
Date: Mon, 22 Sep 2008 16:01:46 -0700
Message-ID: <200809222301.m8MN1kK4002645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751545AbYIVXCX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Sep 2008 19:02:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: spock@gentoo.org, krzysztof.h1@poczta.fm


The patch titled
     MAINTAINERS: add entry for uvesafb
has been added to the -mm tree.  Its filename is
     maintainers-add-entry-for-uvesafb.patch

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
Subject: MAINTAINERS: add entry for uvesafb
From: Michal Januszewski <spock@gentoo.org>

Add a maintainer entry for the uvesafb driver.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN MAINTAINERS~maintainers-add-entry-for-uvesafb MAINTAINERS
--- a/MAINTAINERS~maintainers-add-entry-for-uvesafb
+++ a/MAINTAINERS
@@ -4489,6 +4489,13 @@ W:	http://kernel.org/~kzak/util-linux-ng
 T:	git://git.kernel.org/pub/scm/utils/util-linux-ng/util-linux-ng.git
 S:	Maintained
 
+UVESAFB DRIVER
+P:	Michal Januszewski
+M:	spock@gentoo.org
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+W:	http://dev.gentoo.org/~spock/projects/uvesafb/
+S:	Maintained
+
 VFAT/FAT/MSDOS FILESYSTEM:
 P:	OGAWA Hirofumi
 M:	hirofumi@mail.parknet.co.jp
_

Patches currently in -mm which might be from spock@gentoo.org are

uvesafb-dont-treat-mode-info-retrieval-failures-as-errors.patch
maintainers-add-entry-for-uvesafb.patch

