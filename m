From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-marvell-ccic-f-patterns.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:29:10 -0800
Message-ID: <20120111212910.9E79B1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:40829 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934068Ab2AKV3L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:29:11 -0500
Received: by mail-gy0-f202.google.com with SMTP id r15so137111ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:29:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, corbet@lwn.net, mchehab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update marvell ccic F: patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-marvell-ccic-f-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update marvell ccic F: patterns

Commit f8fc729870ee ("[media] marvell-cam: Move cafe-ccic into its own
directory") moved the files, update the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Acked-by: Mauro Carvalho Chehab<mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-marvell-ccic-f-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-marvell-ccic-f-patterns
+++ a/MAINTAINERS
@@ -1659,7 +1659,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	Documentation/video4linux/cafe_ccic
-F:	drivers/media/video/cafe_ccic*
+F:	drivers/media/video/marvell-ccic/
 
 CAIF NETWORK LAYER
 M:	Sjur Braendeland <sjur.brandeland@stericsson.com>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-staging-cx25821-add-l-linux-media.patch
kernelh-neaten-panic-prototype.patch
linkage-remove-unused-noret_and-macro.patch
treewide-remove-useless-noret_type-macro-and-uses.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
linkage-remove-unused-attrib_noret-macro.patch

