From: akpm@linux-foundation.org
Subject: [merged] mm-numa-balancing-rearrange-kconfig-entry.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 10:56:49 -0800
Message-ID: <5489e8f1.1PXqz+1rG1hukOGs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45228 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360AbaLKS4u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:56:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, mgorman@suse.de, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/numa balancing: rearrange Kconfig entry
has been removed from the -mm tree.  Its filename was
     mm-numa-balancing-rearrange-kconfig-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/numa balancing: rearrange Kconfig entry

Add the default enable config option after the NUMA_BALANCING option so
that it appears related in the nconfig interface.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN init/Kconfig~mm-numa-balancing-rearrange-kconfig-entry init/Kconfig
--- a/init/Kconfig~mm-numa-balancing-rearrange-kconfig-entry
+++ a/init/Kconfig
@@ -893,14 +893,6 @@ config ARCH_SUPPORTS_INT128
 config ARCH_WANT_NUMA_VARIABLE_LOCALITY
 	bool
 
-config NUMA_BALANCING_DEFAULT_ENABLED
-	bool "Automatically enable NUMA aware memory/task placement"
-	default y
-	depends on NUMA_BALANCING
-	help
-	  If set, automatic NUMA balancing will be enabled if running on a NUMA
-	  machine.
-
 config NUMA_BALANCING
 	bool "Memory placement aware NUMA scheduler"
 	depends on ARCH_SUPPORTS_NUMA_BALANCING
@@ -913,6 +905,14 @@ config NUMA_BALANCING
 
 	  This system will be inactive on UMA systems.
 
+config NUMA_BALANCING_DEFAULT_ENABLED
+	bool "Automatically enable NUMA aware memory/task placement"
+	default y
+	depends on NUMA_BALANCING
+	help
+	  If set, automatic NUMA balancing will be enabled if running on a NUMA
+	  machine.
+
 menuconfig CGROUPS
 	boolean "Control Group support"
 	select KERNFS
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

origin.patch
linux-next.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch

