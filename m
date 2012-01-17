From: akpm@linux-foundation.org
Subject: + memcg-replace-mem_cont-by-mem_res_ctlr.patch added to -mm tree
Date: Tue, 17 Jan 2012 14:32:15 -0800
Message-ID: <20120117223216.2EDEC100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:37361 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab2AQWcR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2012 17:32:17 -0500
Received: by yhjj52 with SMTP id j52so519698yhj.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2012 14:32:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: memcg: replace MEM_CONT by MEM_RES_CTLR
has been added to the -mm tree.  Its filename is
     memcg-replace-mem_cont-by-mem_res_ctlr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg: replace MEM_CONT by MEM_RES_CTLR

Correct an #endif comment in memcontrol.h from MEM_CONT to MEM_RES_CTLR.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~memcg-replace-mem_cont-by-mem_res_ctlr include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-replace-mem_cont-by-mem_res_ctlr
+++ a/include/linux/memcontrol.h
@@ -396,7 +396,7 @@ static inline void mem_cgroup_replace_pa
 static inline void mem_cgroup_reset_owner(struct page *page)
 {
 }
-#endif /* CONFIG_CGROUP_MEM_CONT */
+#endif /* CONFIG_CGROUP_MEM_RES_CTLR */
 
 #if !defined(CONFIG_CGROUP_MEM_RES_CTLR) || !defined(CONFIG_DEBUG_VM)
 static inline bool
_
Subject: Subject: memcg: replace MEM_CONT by MEM_RES_CTLR

Patches currently in -mm which might be from hughd@google.com are

origin.patch
proc-clear_refs-do-not-clear-reserved-pages.patch
mm-memcg-update-the-correct-soft-limit-tree-during-migration.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
prio_tree-debugging-patch.patch

