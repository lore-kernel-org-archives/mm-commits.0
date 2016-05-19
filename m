From: akpm@linux-foundation.org
Subject: [folded-merged]
 memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
 removed from -mm tree
Date: Thu, 19 May 2016 16:48:37 -0700
Message-ID: <573e50d5.oxa1qW4iFFtKMgQG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45319 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbcESXsn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 19:48:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vkuznets@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory_hotplug-introduce-config_memory_hotplug_default_online-fix
has been removed from the -mm tree.  Its filename was
     memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch

This patch was dropped because it was folded into memory_hotplug-introduce-config_memory_hotplug_default_online.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memory_hotplug-introduce-config_memory_hotplug_default_online-fix

tweak Kconfig text

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/Kconfig~memory_hotplug-introduce-config_memory_hotplug_default_online-fix mm/Kconfig
--- a/mm/Kconfig~memory_hotplug-introduce-config_memory_hotplug_default_online-fix
+++ a/mm/Kconfig
@@ -197,10 +197,10 @@ config MEMORY_HOTPLUG_DEFAULT_ONLINE
         default n
         depends on MEMORY_HOTPLUG
         help
-	  This option changes the default policy setting for memory hotplug
+	  This option sets the default policy setting for memory hotplug
 	  onlining policy (/sys/devices/system/memory/auto_online_blocks) which
-	  determines what happens to the newly added memory regions. Policy
-	  setting can always be changed in runtime.
+	  determines what happens to newly added memory regions. Policy setting
+	  can always be changed at runtime.
 	  See Documentation/memory-hotplug.txt for more information.
 
 	  Say Y here if you want all hot-plugged memory blocks to appear in
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-nodemaskh-create-next_node_in-helper.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-uninline-page_mapped.patch
memory_hotplug-introduce-config_memory_hotplug_default_online.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix.patch
mm-page_alloc-only-check-pagecompound-for-high-order-pages-fix.patch
mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask-fix.patch
mm-page_alloc-shorten-the-page-allocator-fast-path-fix.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch
mm-page_alloc-un-inline-the-bad-part-of-free_pages_check-fix.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix.patch

