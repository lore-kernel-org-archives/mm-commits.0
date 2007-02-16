From: akpm@linux-foundation.org
Subject: - powerpc-export-of_find_property.patch removed from -mm tree
Date: Fri, 16 Feb 2007 00:02:52 -0800
Message-ID: <200702160802.l1G82qpY023964@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58819 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423406AbXBPID3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 03:03:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, arnd.bergmann@de.ibm.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: export of_find_property
has been removed from the -mm tree.  Its filename was
     powerpc-export-of_find_property.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: powerpc: export of_find_property
From: Dave Jones <davej@redhat.com>

Without this, building drivers/serial/of_serial.c as a module fails.

WARNING: ".of_find_property" [drivers/serial/of_serial.ko] undefined!

Signed-off-by: Dave Jones <davej@redhat.com>
Acked-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/prom.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/kernel/prom.c~powerpc-export-of_find_property arch/powerpc/kernel/prom.c
--- a/arch/powerpc/kernel/prom.c~powerpc-export-of_find_property
+++ a/arch/powerpc/kernel/prom.c
@@ -1605,6 +1605,7 @@ struct property *of_find_property(const 
 
 	return pp;
 }
+EXPORT_SYMBOL(of_find_property);
 
 /*
  * Find a property with a given name for a given node
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
git-agpgart.patch
git-cpufreq.patch
git-powerpc.patch
loosen-dependancy-on-rtc-cmos.patch
