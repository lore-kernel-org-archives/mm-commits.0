From: akpm@linux-foundation.org
Subject: +
 memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
 added to -mm tree
Date: Wed, 06 Apr 2016 11:54:44 -0700
Message-ID: <57055b74.Wxz5UFhc560kkg7f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41102 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbcDFSyp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Apr 2016 14:54:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vkuznets@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory_hotplug-introduce-config_memory_hotplug_default_online-fix
has been added to the -mm tree.  Its filename is
     memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

