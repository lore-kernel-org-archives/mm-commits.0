From: akpm@linux-foundation.org
Subject: - maintainers-add-mailing-list-for-man-pages.patch removed from -mm tree
Date: Tue, 07 Oct 2008 16:39:16 -0700
Message-ID: <200810072339.m97NdGZF009541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755139AbYJGXjT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Oct 2008 19:39:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mtk.manpages@googlemail.com, mtk.manpages@gmail.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add mailing list for man-pages
has been removed from the -mm tree.  Its filename was
     maintainers-add-mailing-list-for-man-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-tip.patch
git-block.patch
rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
rlimit-permit-setting-rlimit_nofile-to-rlim_infinity-fix.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
add-config_core_dump_default_elf_headers.patch

