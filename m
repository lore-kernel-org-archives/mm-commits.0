From: akpm@linux-foundation.org
Subject: [folded-dropped] memory-hotplug-document-and-enable-config_movable_node-fix.patch removed from -mm tree
Date: Tue, 18 Dec 2012 14:12:51 -0800
Message-ID: <20121218221252.86C0020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f73.google.com ([74.125.82.73]:63817 "EHLO
	mail-wg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab2LRWMz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 17:12:55 -0500
Received: by mail-wg0-f73.google.com with SMTP id dt12so67612wgb.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 14:12:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, tangchen@cn.fujitsu.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug-document-and-enable-config_movable_node-fix
has been removed from the -mm tree.  Its filename was
     memory-hotplug-document-and-enable-config_movable_node-fix.patch

This patch was dropped because it was folded into memory-hotplug-document-and-enable-config_movable_node.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memory-hotplug-document-and-enable-config_movable_node-fix

tweak help text

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN mm/Kconfig~memory-hotplug-document-and-enable-config_movable_node-fix mm/Kconfig
--- a/mm/Kconfig~memory-hotplug-document-and-enable-config_movable_node-fix
+++ a/mm/Kconfig
@@ -151,12 +151,13 @@ config MOVABLE_NODE
 	depends on NUMA
 	default n
 	help
-	  Allow a node to have only movable memory. Pages used by kernel, such
-	  as direct mapping pages can not be migrated. So the corresponding
-	  memory device can not be hotpluged. This option allows users to
+	  Allow a node to have only movable memory.  Pages used by the kernel,
+	  such as direct mapping pages cannot be migrated.  So the corresponding
+	  memory device cannot be hotplugged.  This option allows users to
 	  online all the memory of a node as movable memory so that the whole
-	  node can be hotpluged. Users who don't use hotplug feature are fine
-	  with this option on since they don't online memory as movable.
+	  node can be hotplugged.  Users who don't use the memory hotplug
+	  feature are fine with this option on since they don't online memory
+	  as movable.
 
 	  Say Y here if you want to hotplug a whole node.
 	  Say N here if you want kernel to use memory on all nodes evenly.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
irq-tsk-comm-is-an-array.patch
memory-hotplug-document-and-enable-config_movable_node.patch
memcg-kmem-accounting-basic-infrastructure-fix.patch
slub-slub-specific-propagation-changes-fix.patch
mm-mprotectc-coding-style-cleanups.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2.patch
mm-avoid-possible-deadlock-caused-by-too_many_isolated-fix.patch

