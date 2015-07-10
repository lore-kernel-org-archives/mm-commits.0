From: akpm@linux-foundation.org
Subject: + maintainers-change-my-email-address-to-kernelorg.patch added to -mm tree
Date: Fri, 10 Jul 2015 14:21:19 -0700
Message-ID: <55a0374f.fT4m+oEcf0VtXzSY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932579AbbGJVVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jul 2015 17:21:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: change mhocko's email address to kernel.org
has been added to the -mm tree.  Its filename is
     maintainers-change-my-email-address-to-kernelorg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-change-my-email-address-to-kernelorg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-change-my-email-address-to-kernelorg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: MAINTAINERS: change mhocko's email address to kernel.org

I am moving from mhocko@suse.cz to mhocko@kernel.org for kernel related
stuff.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-change-my-email-address-to-kernelorg MAINTAINERS
--- a/MAINTAINERS~maintainers-change-my-email-address-to-kernelorg
+++ a/MAINTAINERS
@@ -2863,7 +2863,7 @@ F:	kernel/cpuset.c
 
 CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)
 M:	Johannes Weiner <hannes@cmpxchg.org>
-M:	Michal Hocko <mhocko@suse.cz>
+M:	Michal Hocko <mhocko@kernel.org>
 L:	cgroups@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
maintainers-change-my-email-address-to-kernelorg.patch
mm-vmscan-do-not-wait-for-page-writeback-for-gfp_nofs-allocations.patch
mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault.patch
selftests-vm-add-tests-for-lock-on-fault.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch

