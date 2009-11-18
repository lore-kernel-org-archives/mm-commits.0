From: akpm@linux-foundation.org
Subject: + maintainers-mark-cifs-mailing-list-as-moderated-for-non-subscribers.patch added to -mm tree
Date: Wed, 18 Nov 2009 14:43:10 -0800
Message-ID: <200911182243.nAIMhAEh028749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753242AbZKRWnL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Nov 2009 17:43:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, sfrench@samba.org


The patch titled
     MAINTAINERS: mark cifs mailing list as "moderated for non-subscribers"
has been added to the -mm tree.  Its filename is
     maintainers-mark-cifs-mailing-list-as-moderated-for-non-subscribers.patch

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
Subject: MAINTAINERS: mark cifs mailing list as "moderated for non-subscribers"
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

If non-subscribers post bug report to CIFS mailing list, they will get
following messages.

	Your mail to 'linux-cifs-client' with the subject

	    [PATCH x/x] cifs: xxxxxxxxxxxxx

	Is being held until the list moderator can review it for approval.

	The reason it is being held:

	    Post by non-member to a members-only list

	Either the message will get posted to the list, or you will receive
	notification of the moderator's decision.  If you would like to cancel
	this posting, please visit the following URL:

members-only list should be written as so in MAINTAINERS file.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-mark-cifs-mailing-list-as-moderated-for-non-subscribers MAINTAINERS
--- a/MAINTAINERS~maintainers-mark-cifs-mailing-list-as-moderated-for-non-subscribers
+++ a/MAINTAINERS
@@ -1445,8 +1445,8 @@ F:	include/linux/coda*.h
 
 COMMON INTERNET FILE SYSTEM (CIFS)
 M:	Steve French <sfrench@samba.org>
-L:	linux-cifs-client@lists.samba.org
-L:	samba-technical@lists.samba.org
+L:	linux-cifs-client@lists.samba.org (moderated for non-subscribers)
+L:	samba-technical@lists.samba.org (moderated for non-subscribers)
 W:	http://linux-cifs.samba.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
 S:	Supported
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mm-allow-memory-hotplug-and-hibernation-in-the-same-kernel.patch
linux-next.patch
oom-dump-stack-and-vm-state-when-oom-killer-panics.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place.patch
rmap-simplify-try_to_unmap_file.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim.patch
vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep.patch
vmscan-stop-kswapd-waiting-on-congestion-when-the-min-watermark-is-not-being-met-v2.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-mlocking-in-try_to_unmap_one-fix.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-config_mmu-for-pg_mlocked.patch
mm-pass-address-down-to-rmap-ones.patch
mm-stop-ptlock-enlarging-struct-page.patch
mm-sigbus-instead-of-abusing-oom.patch
mm-add-numa-node-symlink-for-memory-section-in-sysfs.patch
mm-refactor-register_cpu_under_node.patch
mm-refactor-unregister_cpu_under_node.patch
mm-add-numa-node-symlink-for-cpu-devices-in-sysfs.patch
documentation-abi-sys-devices-system-cpu-cpu-node.patch
vmscan-separate-scswap_cluster_max-and-scnr_max_reclaim.patch
vmscan-kill-hibernation-specific-reclaim-logic-and-unify-it.patch
vmscan-zone_reclaim-dont-use-insane-swap_cluster_max.patch
vmscan-kill-scswap_cluster_max.patch
vmscan-make-consistent-of-reclaim-bale-out-between-do_try_to_free_page-and-shrink_zone.patch
mm-memory_hotplug-make-offline_pages-static.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm.patch
maintainers-mark-cifs-mailing-list-as-moderated-for-non-subscribers.patch
lib-introduce-strim.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

