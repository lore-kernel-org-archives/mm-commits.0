From: akpm@linux-foundation.org
Subject: - maintainers-add-util-linux-ng-package.patch removed from -mm tree
Date: Tue, 27 May 2008 00:26:42 -0700
Message-ID: <200805270726.m4R7QgXo014692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755844AbYE0H1l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:27:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kzak@redhat.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add util-linux-ng package
has been removed from the -mm tree.  Its filename was
     maintainers-add-util-linux-ng-package.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add util-linux-ng package
From: Karel Zak <kzak@redhat.com>

(akpm: we often deal with util-linux and I (at least) can never remember
where they hang out).

Signed-off-by: Karel Zak <kzak@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN MAINTAINERS~maintainers-add-util-linux-ng-package MAINTAINERS
--- a/MAINTAINERS~maintainers-add-util-linux-ng-package
+++ a/MAINTAINERS
@@ -4361,6 +4361,14 @@ M:	gregkh@suse.de
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


