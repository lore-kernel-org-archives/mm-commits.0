From: akpm@linux-foundation.org
Subject: + memory-hotplug-fix-comments-when-add-section.patch added to -mm tree
Date: Wed, 15 Nov 2017 11:50:08 -0800
Message-ID: <5a0c9a70.mx71mJwBsspvSnDp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41020 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756561AbdKOTuJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 14:50:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fan.du@intel.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory hotplug: fix comments when adding section
has been added to the -mm tree.  Its filename is
     memory-hotplug-fix-comments-when-add-section.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory-hotplug-fix-comments-when-add-section.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory-hotplug-fix-comments-when-add-section.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

memory-hotplug-fix-comments-when-add-section.patch

