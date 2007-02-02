From: akpm@linux-foundation.org
Subject: + maintainers-ufs-entry.patch added to -mm tree
Date: Fri, 02 Feb 2007 00:48:03 -0800
Message-ID: <200702020848.l128m3VC004000@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40136 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbXBBIsM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 03:48:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dushistov@mail.ru


The patch titled
     MAINTAINERS: ufs entry
has been added to the -mm tree.  Its filename is
     maintainers-ufs-entry.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MAINTAINERS: ufs entry
From: Evgeniy Dushistov <dushistov@mail.ru>

Mark ufs file system as maintainable, and add me as maintainer, to help
people find appropriate person to assign bugs.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN MAINTAINERS~maintainers-ufs-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-ufs-entry
+++ a/MAINTAINERS
@@ -3665,6 +3665,12 @@ M:	ysato@users.sourceforge.jp
 W:	http://uclinux-h8.sourceforge.jp/
 S:	Supported
 
+UFS FILESYSTEM
+P: Evgeniy Dushistov
+M: dushistov@mail.ru
+L: linux-kernel@vger.kernel.org
+S: Maintained
+
 USB DIAMOND RIO500 DRIVER
 P:	Cesar Miquel
 M:	miquel@df.uba.ar
_

Patches currently in -mm which might be from dushistov@mail.ru are

maintainers-ufs-entry.patch
ufs2-write-mount-as-rw.patch
ufs2-write-inodes-write.patch
ufs2-write-block-allocation-update.patch
