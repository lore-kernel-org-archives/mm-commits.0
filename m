From: akpm@linux-foundation.org
Subject: - add-taskstatsh-to-kbuild.patch removed from -mm tree
Date: Tue, 08 May 2007 19:52:31 -0700
Message-ID: <200705090252.l492qVTx009581@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031555AbXEICwr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:52:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwmw2@infradead.org, balbir@linux.vnet.ibm.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Add taskstats.h to kbuild
has been removed from the -mm tree.  Its filename was
     add-taskstatsh-to-kbuild.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add taskstats.h to kbuild
From: David Woodhouse <dwmw2@infradead.org>

Add taskstats.h to include/linux/Kbuild, make headers_install would then
pickup taskstats.h.  This needs to be done as taskstats.h is a user
interface header.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/Kbuild~add-taskstatsh-to-kbuild include/linux/Kbuild
--- a/include/linux/Kbuild~add-taskstatsh-to-kbuild
+++ a/include/linux/Kbuild
@@ -141,6 +141,7 @@ header-y += sockios.h
 header-y += som.h
 header-y += sound.h
 header-y += synclink.h
+header-y += taskstats.h
 header-y += telephony.h
 header-y += termios.h
 header-y += ticable.h
_

Patches currently in -mm which might be from dwmw2@infradead.org are

origin.patch
git-mtd.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch
git-battery.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
introduce-freezer-flags-rev-2.patch
