From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-tulip-f-patterns.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:29:19 -0800
Message-ID: <20120111212920.25CAF200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:62274 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934068Ab2AKV3W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:29:22 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so32568eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:29:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, davem@davemloft.net, davies@maniac.ultranet.com, grundler@parisc-linux.org, jeffrey.t.kirsher@intel.com, tori@unhappy.mine.nu, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update tulip F: patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-tulip-f-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update tulip F: patterns

commit a88394cfb58 ("ewrk3/tulip: Move the DEC - Tulip drivers") moved the
files, update the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Grant Grundler <grundler@parisc-linux.org>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Tobias Ringstrom <tori@unhappy.mine.nu>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: David Davies <davies@maniac.ultranet.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-tulip-f-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-tulip-f-patterns
+++ a/MAINTAINERS
@@ -2096,7 +2096,7 @@ DAVICOM FAST ETHERNET (DMFE) NETWORK DRI
 L:	netdev@vger.kernel.org
 S:	Orphan
 F:	Documentation/networking/dmfe.txt
-F:	drivers/net/ethernet/tulip/dmfe.c
+F:	drivers/net/ethernet/dec/tulip/dmfe.c
 
 DC390/AM53C974 SCSI driver
 M:	Kurt Garloff <garloff@suse.de>
@@ -6640,7 +6640,7 @@ TULIP NETWORK DRIVERS
 M:	Grant Grundler <grundler@parisc-linux.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	drivers/net/ethernet/tulip/
+F:	drivers/net/ethernet/dec/tulip/
 
 TUN/TAP driver
 M:	Maxim Krasnyansky <maxk@qualcomm.com>
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

