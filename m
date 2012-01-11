From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-greth-f-patterns.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:29:23 -0800
Message-ID: <20120111212923.9ADB110004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:40669 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758116Ab2AKV3Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:29:24 -0500
Received: by yhpp56 with SMTP id p56so153995yhp.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:29:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jeffrey.t.kirsher@intel.com, kristoffer@gaisler.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update greth F: patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-greth-f-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update greth F: patterns

commit 1fe003fd424 ("greth: Move the Aeroflex Gaisler driver") moved the
files, update the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kristoffer Glembo <kristoffer@gaisler.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-greth-f-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-greth-f-patterns
+++ a/MAINTAINERS
@@ -2906,7 +2906,7 @@ GRETH 10/100/1G Ethernet MAC device driv
 M:	Kristoffer Glembo <kristoffer@gaisler.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	drivers/net/greth*
+F:	drivers/net/ethernet/aeroflex/
 
 GSPCA FINEPIX SUBDRIVER
 M:	Frank Zago <frank@zago.net>
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

