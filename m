From: akpm@linux-foundation.org
Subject: + add-balbir-as-the-maintainer-for-memory-resource-controller.patch added to -mm tree
Date: Thu, 28 Feb 2008 11:37:27 -0800
Message-ID: <200802281937.m1SJbRtp016608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759042AbYB1TnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 14:43:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, rientjes@google.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     Add memory resource controller maintainers
has been added to the -mm tree.  Its filename is
     add-balbir-as-the-maintainer-for-memory-resource-controller.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add memory resource controller maintainers


Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN MAINTAINERS~add-balbir-as-the-maintainer-for-memory-resource-controller MAINTAINERS
--- a/MAINTAINERS~add-balbir-as-the-maintainer-for-memory-resource-controller
+++ a/MAINTAINERS
@@ -2626,6 +2626,17 @@ L:	linux-kernel@vger.kernel.org
 W:	http://www.linux-mm.org
 S:	Maintained
 
+MEMORY RESOURCE CONTROLLER
+P:	Balbir Singh
+M:	balbir@linux.vnet.ibm.com
+P:	Pavel Emelyanov
+M:	xemul@openvz.org
+P:	KAMEZAWA Hiroyuki
+M:	kamezawa.hiroyu@jp.fujitsu.com
+L:	linux-mm@kvack.org
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 MEI MN10300/AM33 PORT
 P:	David Howells
 M:	dhowells@redhat.com
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
memory-resource-controller-use-strstrip-while-parsing-arguments.patch
control-groups-add-paul-menage-a-maintainer.patch
add-balbir-as-the-maintainer-for-memory-resource-controller.patch
git-kvm.patch
memory-controller-rename-to-memory-resource-controller.patch
memcg-mm_match_cgroup-not-vm_match_cgroup.patch
memcg-move_lists-on-page-not-page_cgroup.patch
memcg-page_cache_release-not-__free_page.patch
memcg-when-do_swaps-do_wp_page-fails.patch
memcg-fix-vm_bug_on-from-page-migration.patch
memcg-bad-page-if-page_cgroup-when-free.patch
memcg-mem_cgroup_charge-never-null.patch
memcg-remove-mem_cgroup_uncharge.patch
memcg-memcontrol-whitespace-cleanups.patch
memcg-memcontrol-uninlined-and-static.patch
memcg-remove-clear_page_cgroup-and-atomics.patch
memcg-css_put-after-remove_list.patch
memcg-fix-mem_cgroup_move_lists-locking.patch
memcg-simplify-force_empty-and-move_lists.patch

