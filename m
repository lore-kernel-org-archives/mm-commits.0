From: akpm@linux-foundation.org
Subject: - maintainers-add-entry-for-uvesafb.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:17:48 -0700
Message-ID: <200810182317.m9INHm97029161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258AbYJRXRz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:17:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: spock@gentoo.org, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add entry for uvesafb
has been removed from the -mm tree.  Its filename was
     maintainers-add-entry-for-uvesafb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -4480,6 +4480,13 @@ W:	http://kernel.org/~kzak/util-linux-ng
 T:	git://git.kernel.org/pub/scm/utils/util-linux-ng/util-linux-ng.git
 S:	Maintained
 
+UVESAFB DRIVER
+P:	Michal Januszewski
+M:	spock@gentoo.org
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+W:	http://dev.gentoo.org/~spock/projects/uvesafb/
+S:	Maintained
+
 VFAT/FAT/MSDOS FILESYSTEM
 P:	OGAWA Hirofumi
 M:	hirofumi@mail.parknet.co.jp
_

Patches currently in -mm which might be from spock@gentoo.org are

origin.patch

