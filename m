From: akpm@linux-foundation.org
Subject: + kernel-groupsc-remove-return-value-of-set_groups-fix.patch
 added to -mm tree
Date: Tue, 18 Feb 2014 15:03:54 -0800
Message-ID: <5303e6da.8AUkafeibRPHwvcf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbaBRXDz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 18:03:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, udknight@gmail.com, serge.hallyn@canonical.com, eparis@redhat.com, ebiederm@xmission.com, akpm@linux-foundation.org

Subject: + kernel-groupsc-remove-return-value-of-set_groups-fix.patch added to -mm tree
To: akpm@linux-foundation.org,ebiederm@xmission.com,eparis@redhat.com,serge.hallyn@canonical.com,udknight@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 15:03:54 -0800


The patch titled
     Subject: kernel-groupsc-remove-return-value-of-set_groups-fix
has been added to the -mm tree.  Its filename is
     kernel-groupsc-remove-return-value-of-set_groups-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-groupsc-remove-return-value-of-set_groups-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-groupsc-remove-return-value-of-set_groups-fix.patch

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
Subject: kernel-groupsc-remove-return-value-of-set_groups-fix

remove obsolete claims from set_groups() comment

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Wang YanQing <udknight@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/groups.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/groups.c~kernel-groupsc-remove-return-value-of-set_groups-fix kernel/groups.c
--- a/kernel/groups.c~kernel-groupsc-remove-return-value-of-set_groups-fix
+++ a/kernel/groups.c
@@ -157,9 +157,6 @@ int groups_search(const struct group_inf
  * set_groups - Change a group subscription in a set of credentials
  * @new: The newly prepared set of credentials to alter
  * @group_info: The group list to install
- *
- * Validate a group subscription and, if valid, insert it into a set
- * of credentials.
  */
 void set_groups(struct cred *new, struct group_info *group_info)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch
linux-next-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

