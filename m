From: akpm@linux-foundation.org
Subject: + add-new-cgroup-list-to-cc-notice.patch added to -mm tree
Date: Wed, 09 Nov 2011 15:17:31 -0800
Message-ID: <201111092317.pA9NHVal028361@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:40227 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab1KIXRk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2011 18:17:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, James.Bottomley@HansenPartnership.com


The patch titled
     Subject: MAINTAINERS: add new cgroup list to CC notice
has been added to the -mm tree.  Its filename is
     add-new-cgroup-list-to-cc-notice.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: MAINTAINERS: add new cgroup list to CC notice

As discussed at Kernel Summit(2011), new cgroups mailing list is opened by
James.  This list is for discussing general cgroup design and patches
including all subsystems and for getting more attentions to
cgroups/namespaces related issues by developpers.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~add-new-cgroup-list-to-cc-notice MAINTAINERS
--- a/MAINTAINERS~add-new-cgroup-list-to-cc-notice
+++ a/MAINTAINERS
@@ -1938,6 +1938,7 @@ CONTROL GROUPS (CGROUPS)
 M:	Paul Menage <paul@paulmenage.org>
 M:	Li Zefan <lizf@cn.fujitsu.com>
 L:	containers@lists.linux-foundation.org
+L:	cgroups@vger.kernel.org
 S:	Maintained
 F:	include/linux/cgroup*
 F:	kernel/cgroup*
@@ -4305,6 +4306,7 @@ MEMORY RESOURCE CONTROLLER
 M:	Balbir Singh <bsingharora@gmail.com>
 M:	Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
 M:	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
+L:	cgroups@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/memcontrol.c
_
Subject: Subject: MAINTAINERS: add new cgroup list to CC notice

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

add-new-cgroup-list-to-cc-notice.patch
linux-next.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
cgroup-fix-task-counter-common-ancestor-logic.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags-fix.patch

