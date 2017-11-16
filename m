From: akpm@linux-foundation.org
Subject: [merged]
 memory-hotplug-fix-comments-when-add-section.patch removed from -mm tree
Date: Thu, 16 Nov 2017 12:05:37 -0800
Message-ID: <20171116200537.jdWELJJXz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47642 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935910AbdKPUFi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:05:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fan.du@intel.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory hotplug: fix comments when adding section
has been removed from the -mm tree.  Its filename was
     memory-hotplug-fix-comments-when-add-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fan Du <fan.du@intel.com>
Subject: memory hotplug: fix comments when adding section

Here, pfn_to_node should be page_to_nid.

Link: http://lkml.kernel.org/r/1510735205-22540-1-git-send-email-fan.du@intel.com
Signed-off-by: Fan Du <fan.du@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-fix-comments-when-add-section mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-fix-comments-when-add-section
+++ a/mm/memory_hotplug.c
@@ -265,7 +265,7 @@ static int __meminit __add_section(int n
 	/*
 	 * Make all the pages reserved so that nobody will stumble over half
 	 * initialized state.
-	 * FIXME: We also have to associate it with a node because pfn_to_node
+	 * FIXME: We also have to associate it with a node because page_to_nid
 	 * relies on having page with the proper node.
 	 */
 	for (i = 0; i < PAGES_PER_SECTION; i++) {
_

Patches currently in -mm which might be from fan.du@intel.com are


