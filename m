From: akpm@linux-foundation.org
Subject: [folded] kcore-register-vmemmap-range-fix.patch removed from -mm tree
Date: Tue, 22 Sep 2009 14:46:13 -0700
Message-ID: <200909222146.n8MLkDe9006147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144AbZIVVq6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 17:46:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, jirislaby@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, ralf@linux-mips.org, randy.dunlap@oracle.com, xiyou.wangcong@gmail.com, mm-co


The patch titled
     kcore-register-vmemmap-range-fix
has been removed from the -mm tree.  Its filename was
     kcore-register-vmemmap-range-fix.patch

This patch was dropped because it was folded into kcore-register-vmemmap-range.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kcore-register-vmemmap-range-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/kcore.c~kcore-register-vmemmap-range-fix fs/proc/kcore.c
--- a/fs/proc/kcore.c~kcore-register-vmemmap-range-fix
+++ a/fs/proc/kcore.c
@@ -186,7 +186,7 @@ int get_sparsemem_vmemmap_info(struct kc
 
 }
 #else
-int get_sparsemem_vmemamp_info(struct kcore_list *ent, struct list_head *head)
+int get_sparsemem_vmemmap_info(struct kcore_list *ent, struct list_head *head)
 {
 	return 1;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
generic-ipi-make-struct-call_function_data-lockless.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support.patch
sdio-add-mmc_quirk_lenient_fn0.patch
at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver.patch
mmc-core-sdio-suspend-resume-support.patch
procfs-provide-stack-information-for-threads-v08.patch
kcore-register-vmemmap-range.patch
kcore-register-vmemmap-range-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
drivers-video-add-kmalloc-null-tests-fix.patch
drivers-video-tmiofbc-fix-uninitialised-return-value.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch

