From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplug-unexport-memhp_auto_online.patch removed from -mm tree
Date: Tue, 07 Apr 2020 18:59:16 -0700
Message-ID: <20200408015916.KyTs6NR52%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHB7R (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:59:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bhe@redhat.com, david@redhat.com, ehabkost@redhat.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, imammedo@redhat.com, kys@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de, pankaj.gupta.linux@gmail.com, paulus@samba.org, rafael@kernel.org, richard.weiyang@gmail.com, sthemmin@microsoft.com, vkuznets@redhat.com, wei.liu@kernel.org, yuhuang@redhat.com


The patch titled
     Subject: mm/memory_hotplug: unexport memhp_auto_online
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-unexport-memhp_auto_online.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: unexport memhp_auto_online

All in-tree users except the mm-core are gone. Let's drop the export.

Link: http://lkml.kernel.org/r/20200317104942.11178-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Yumei Huang <yuhuang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-unexport-memhp_auto_online
+++ a/mm/memory_hotplug.c
@@ -71,7 +71,6 @@ bool memhp_auto_online;
 #else
 bool memhp_auto_online = true;
 #endif
-EXPORT_SYMBOL_GPL(memhp_auto_online);
 
 static int __init setup_memhp_default_state(char *str)
 {
_

Patches currently in -mm which might be from david@redhat.com are

drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup-fix.patch
