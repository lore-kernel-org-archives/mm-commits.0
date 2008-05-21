From: akpm@linux-foundation.org
Subject: + maintainers-add-util-linux-ng-package.patch added to -mm tree
Date: Wed, 21 May 2008 01:33:50 -0700
Message-ID: <200805210833.m4L8XogE004255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760360AbYEUIeU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 May 2008 04:34:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kzak@redhat.com


The patch titled
     MAINTAINERS: add util-linux-ng package
has been added to the -mm tree.  Its filename is
     maintainers-add-util-linux-ng-package.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add util-linux-ng package
From: Karel Zak <kzak@redhat.com>

(akmp: we often deal with util-linux and I (at least) can never remember
where they hang out).

Signed-off-by: Karel Zak <kzak@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN MAINTAINERS~maintainers-add-util-linux-ng-package MAINTAINERS
--- a/MAINTAINERS~maintainers-add-util-linux-ng-package
+++ a/MAINTAINERS
@@ -4359,6 +4359,14 @@ M:	gregkh@suse.de
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
+UTIL-LINUX-NG PACKAGE
+P:	Karel Zak
+M:	kzak@redhat.com
+L:	util-linux-ng@vger.kernel.org
+W:	http://kernel.org/~kzak/util-linux-ng/
+T:	git://git.kernel.org/pub/scm/utils/util-linux-ng/util-linux-ng.git
+S:	Maintained
+
 VFAT/FAT/MSDOS FILESYSTEM:
 P:	OGAWA Hirofumi
 M:	hirofumi@mail.parknet.co.jp
_

Patches currently in -mm which might be from kzak@redhat.com are

maintainers-add-util-linux-ng-package.patch

