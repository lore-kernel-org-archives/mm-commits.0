From: akpm@linux-foundation.org
Subject: + maintainers-add-bfin_sdh-driver.patch added to -mm tree
Date: Tue, 09 Mar 2010 12:31:44 -0800
Message-ID: <201003092031.o29KVi8H003402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494Ab0CIUbs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 15:31:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org


The patch titled
     MAINTAINERS: add bfin_sdh driver
has been added to the -mm tree.  Its filename is
     maintainers-add-bfin_sdh-driver.patch

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
Subject: MAINTAINERS: add bfin_sdh driver
From: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN MAINTAINERS~maintainers-add-bfin_sdh-driver MAINTAINERS
--- a/MAINTAINERS~maintainers-add-bfin_sdh-driver
+++ a/MAINTAINERS
@@ -1259,6 +1259,13 @@ W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/rtc/rtc-bfin.c
 
+BLACKFIN SDH DRIVER
+M:	Cliff Cai <cliff.cai@analog.com>
+L:	uclinux-dist-devel@blackfin.uclinux.org
+W:	http://blackfin.uclinux.org
+S:	Supported
+F:	drivers/mmc/host/bfin_sdh.c
+
 BLACKFIN SERIAL DRIVER
 M:	Sonic Zhang <sonic.zhang@analog.com>
 L:	uclinux-dist-devel@blackfin.uclinux.org
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-next.patch
maintainers-add-bfin_sdh-driver.patch
fbdev-bf54x-lq043fb-bfin-t350mcqb-fb-drop-custom-mmap-handler.patch
blackfin-remove-the-obsolete-and-unnecessary-dma-api-comments.patch

