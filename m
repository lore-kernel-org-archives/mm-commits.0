From: akpm@linux-foundation.org
Subject: + add-taskstatsh-to-kbuild.patch added to -mm tree
Date: Thu, 03 May 2007 00:20:40 -0700
Message-ID: <200705030720.l437KemP007088@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40252 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755218AbXECHUz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 03:20:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwmw2@infradead.org, balbir@linux.vnet.ibm.com, dzickus@redhat.com


The patch titled
     Add taskstats.h to kbuild
has been added to the -mm tree.  Its filename is
     add-taskstatsh-to-kbuild.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -139,6 +139,7 @@ header-y += sockios.h
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
git-kbuild.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch
block2mtd_paramline-mustnt-be-__initdata.patch
git-battery.patch
increase-slab-redzone-to-64bits.patch
increase-slab-redzone-to-64bits-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
clean-up-mutex_trylock-noise.patch
add-taskstatsh-to-kbuild.patch
rename-get_property-to-of_get_property-drivers.patch
